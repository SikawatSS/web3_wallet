import 'package:dartz/dartz.dart';
import 'package:web3_wallet/core/failure.dart';
import 'package:web3_wallet/domain/entities/balance.dart';
import 'package:web3_wallet/domain/repositories/wallet_repository.dart';

class GetCachedBalanceUseCase {
  final WalletRepository walletRepository;

  GetCachedBalanceUseCase({required this.walletRepository});

  Future<Either<Failure, Balance>> call({
    required String address,
    required int chainId,
  }) async {
    return await walletRepository.getCachedBalance(
      address: address,
      chainId: chainId,
    );
  }
}
