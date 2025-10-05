import 'package:dartz/dartz.dart';
import 'package:web3_wallet/core/failure.dart';
import 'package:web3_wallet/domain/entities/balance.dart';
import 'package:web3_wallet/domain/repositories/wallet_repository.dart';

class GetBalanceUseCase {
  final WalletRepository walletRepository;

  GetBalanceUseCase({required this.walletRepository});

  Future<Either<Failure, Balance>> call({
    required String address,
    required int chainId,
  }) async {
    return walletRepository.getBalance(address: address, chainId: chainId);
  }
}
