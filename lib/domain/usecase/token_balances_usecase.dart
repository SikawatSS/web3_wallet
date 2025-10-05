import 'package:dartz/dartz.dart';
import 'package:web3_wallet/core/failure.dart';
import 'package:web3_wallet/domain/entities/token_balance.dart';
import 'package:web3_wallet/domain/repositories/wallet_repository.dart';

class GetTokenBalancesUseCase {
  final WalletRepository walletRepository;

  GetTokenBalancesUseCase({required this.walletRepository});

  Future<Either<Failure, List<TokenBalance>>> call({
    required String address,
    required int chainId,
  }) async {
    return walletRepository.getTokenBalances(
      address: address,
      chainId: chainId,
    );
  }
}
