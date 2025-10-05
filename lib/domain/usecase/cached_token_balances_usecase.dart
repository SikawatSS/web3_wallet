import 'package:dartz/dartz.dart';
import 'package:web3_wallet/core/failure.dart';
import 'package:web3_wallet/domain/entities/token_balance.dart';
import 'package:web3_wallet/domain/repositories/wallet_repository.dart';

class GetCachedTokenBalancesUseCase {
  final WalletRepository walletRepository;

  GetCachedTokenBalancesUseCase({required this.walletRepository});

  Future<Either<Failure, List<TokenBalance>>> call({
    required String address,
    required int chainId,
  }) async {
    return await walletRepository.getCachedTokenBalances(
      address: address,
      chainId: chainId,
    );
  }
}
