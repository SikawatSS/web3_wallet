import 'package:dartz/dartz.dart';
import 'package:web3_wallet/core/failure.dart';
import 'package:web3_wallet/domain/entities/balance.dart';
import 'package:web3_wallet/domain/entities/token_balance.dart';

abstract class WalletRepository {
  Future<Either<Failure, Balance>> getBalance({
    required String address,
    required int chainId,
  });

  Future<Either<Failure, Balance>> getCachedBalance({
    required String address,
    required int chainId,
  });

  Future<Either<Failure, List<TokenBalance>>> getTokenBalances({
    required String address,
    required int chainId,
  });

  Future<Either<Failure, List<TokenBalance>>> getCachedTokenBalances({
    required String address,
    required int chainId,
  });
}
