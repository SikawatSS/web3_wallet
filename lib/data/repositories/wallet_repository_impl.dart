import 'package:dartz/dartz.dart';
import 'package:web3_wallet/core/failure.dart';
import 'package:web3_wallet/data/datasources/local/balance_local_datasource.dart';
import 'package:web3_wallet/data/datasources/local/token_balance_local_datasource.dart';
import 'package:web3_wallet/data/datasources/remote/etherscan_remote_datasource.dart';
import 'package:web3_wallet/domain/entities/balance.dart';
import 'package:web3_wallet/domain/entities/token_balance.dart';
import 'package:web3_wallet/domain/repositories/wallet_repository.dart';

class WalletRepositoryImpl implements WalletRepository {
  final EtherscanRemoteDataSource remoteDataSource;
  final BalanceLocalDataSource localDataSource;
  final TokenBalanceLocalDataSource tokenBalanceLocalDataSource;

  WalletRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.tokenBalanceLocalDataSource,
  });

  @override
  Future<Either<Failure, Balance>> getCachedBalance({
    required String address,
    required int chainId,
  }) async {
    try {
      final cachedBalance = await localDataSource.getCachedBalance(
        address: address,
        chainId: chainId,
      );

      if (cachedBalance == null) {
        return Left(Failure(message: 'No cached balance found', code: 404));
      }

      return Right(cachedBalance);
    } catch (e) {
      return Left(
        Failure(message: 'Failed to get cached balance: $e', code: 500),
      );
    }
  }

  @override
  Future<Either<Failure, Balance>> getBalance({
    required String address,
    required int chainId,
  }) async {
    try {
      // Fetch from remote
      final result = await remoteDataSource.getBalance(
        address: address,
        chainId: chainId,
      );

      return result.fold(
        (failure) async {
          // If remote fails, try to get from cache
          final cachedBalance = await localDataSource.getCachedBalance(
            address: address,
            chainId: chainId,
          );

          if (cachedBalance != null) {
            return Right(cachedBalance);
          }
          return Left(failure);
        },
        (data) async {
          // Cache the fresh data
          await localDataSource.cacheBalance(
            address: address,
            chainId: chainId,
            balance: data,
          );
          return Right(data);
        },
      );
    } catch (e) {
      return Left(Failure(message: 'Failed to get balance: $e', code: 500));
    }
  }

  @override
  Future<Either<Failure, List<TokenBalance>>> getCachedTokenBalances({
    required String address,
    required int chainId,
  }) async {
    try {
      final cachedTokenBalances = await tokenBalanceLocalDataSource
          .getCachedTokenBalances(address: address, chainId: chainId);

      if (cachedTokenBalances.isEmpty) {
        return Left(
          Failure(message: 'No cached token balances found', code: 404),
        );
      }

      return Right(cachedTokenBalances);
    } catch (e) {
      return Left(
        Failure(message: 'Failed to get cached token balances: $e', code: 500),
      );
    }
  }

  @override
  Future<Either<Failure, List<TokenBalance>>> getTokenBalances({
    required String address,
    required int chainId,
  }) async {
    try {
      // Fetch from remote
      final result = await remoteDataSource.getTokenBalances(
        address: address,
        chainId: chainId,
      );

      return result.fold(
        (failure) async {
          // If remote fails, try to get from cache
          final cachedTokenBalances = await tokenBalanceLocalDataSource
              .getCachedTokenBalances(address: address, chainId: chainId);

          if (cachedTokenBalances.isNotEmpty) {
            return Right(cachedTokenBalances);
          }
          return Left(failure);
        },
        (data) async {
          // Cache the fresh data
          await tokenBalanceLocalDataSource.cacheTokenBalances(
            address: address,
            chainId: chainId,
            tokenBalances: data,
          );
          return Right(data);
        },
      );
    } catch (e) {
      return Left(
        Failure(message: 'Failed to get token balances: $e', code: 500),
      );
    }
  }
}
