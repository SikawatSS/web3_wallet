import 'package:web3_wallet/core/db/app_database.dart';
import 'package:web3_wallet/data/models/balance_model.dart';

abstract class BalanceLocalDataSource {
  /// Get cached balance from local database
  Future<BalanceModel?> getCachedBalance({
    required String address,
    required int chainId,
  });

  /// Cache balance to local database
  Future<void> cacheBalance({
    required String address,
    required int chainId,
    required BalanceModel balance,
  });

  /// Delete cached balance
  Future<void> deleteCachedBalance({
    required String address,
    required int chainId,
  });

  /// Clear all cached balances
  Future<void> clearAllBalances();
}

class BalanceLocalDataSourceImpl implements BalanceLocalDataSource {
  final AppDatabase database;

  BalanceLocalDataSourceImpl({required this.database});

  @override
  Future<BalanceModel?> getCachedBalance({
    required String address,
    required int chainId,
  }) async {
    final result = await database.balanceDao.getBalance(
      address: address,
      chainId: chainId,
    );

    if (result == null) return null;

    return BalanceModel(weiAmount: BigInt.parse(result.weiAmount));
  }

  @override
  Future<void> cacheBalance({
    required String address,
    required int chainId,
    required BalanceModel balance,
  }) async {
    await database.balanceDao.upsertBalance(
      address: address,
      chainId: chainId,
      weiAmount: balance.weiAmount.toString(),
    );
  }

  @override
  Future<void> deleteCachedBalance({
    required String address,
    required int chainId,
  }) async {
    await database.balanceDao.deleteBalance(address: address, chainId: chainId);
  }

  @override
  Future<void> clearAllBalances() async {
    await database.balanceDao.clearAllBalances();
  }
}
