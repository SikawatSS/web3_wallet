import 'package:drift/drift.dart';
import 'package:web3_wallet/core/db/app_database.dart';
import 'package:web3_wallet/data/datasources/local/database/tables/balance_table.dart';

part 'balance_dao.g.dart';

@DriftAccessor(tables: [BalanceTable])
class BalanceDao extends DatabaseAccessor<AppDatabase> with _$BalanceDaoMixin {
  BalanceDao(super.db);

  /// Get balance for a specific address and chain
  Future<BalanceEntity?> getBalance({
    required String address,
    required int chainId,
  }) {
    return (select(balanceTable)
          ..where((tbl) =>
              tbl.address.equals(address) & tbl.chainId.equals(chainId)))
        .getSingleOrNull();
  }

  /// Insert or update balance
  Future<void> upsertBalance({
    required String address,
    required int chainId,
    required String weiAmount,
  }) {
    return into(balanceTable).insertOnConflictUpdate(
      BalanceTableCompanion.insert(
        address: address,
        chainId: chainId,
        weiAmount: weiAmount,
        updatedAt: DateTime.now(),
      ),
    );
  }

  /// Delete balance for specific address and chain
  Future<int> deleteBalance({
    required String address,
    required int chainId,
  }) {
    return (delete(balanceTable)
          ..where((tbl) =>
              tbl.address.equals(address) & tbl.chainId.equals(chainId)))
        .go();
  }

  /// Get all balances
  Future<List<BalanceEntity>> getAllBalances() {
    return select(balanceTable).get();
  }

  /// Clear all balances
  Future<int> clearAllBalances() {
    return delete(balanceTable).go();
  }

  /// Watch balance changes for a specific address and chain
  Stream<BalanceEntity?> watchBalance({
    required String address,
    required int chainId,
  }) {
    return (select(balanceTable)
          ..where((tbl) =>
              tbl.address.equals(address) & tbl.chainId.equals(chainId)))
        .watchSingleOrNull();
  }
}
