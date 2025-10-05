import 'package:drift/drift.dart';
import 'package:web3_wallet/core/db/app_database.dart';
import 'package:web3_wallet/data/datasources/local/database/tables/token_balance_table.dart';

part 'token_balance_dao.g.dart';

@DriftAccessor(tables: [TokenBalanceTable])
class TokenBalanceDao extends DatabaseAccessor<AppDatabase>
    with _$TokenBalanceDaoMixin {
  TokenBalanceDao(super.db);

  /// Get all token balances for a specific address and chain
  Future<List<TokenBalanceEntity>> getTokenBalances({
    required String address,
    required int chainId,
  }) {
    return (select(tokenBalanceTable)..where(
          (tbl) => tbl.address.equals(address) & tbl.chainId.equals(chainId),
        ))
        .get();
  }

  /// Insert or update a single token balance
  Future<void> upsertTokenBalance({
    required String address,
    required int chainId,
    required String contractAddress,
    required String tokenName,
    required String tokenSymbol,
    required String tokenQuantity,
    required String tokenDivisor,
  }) {
    return into(tokenBalanceTable).insertOnConflictUpdate(
      TokenBalanceTableCompanion.insert(
        address: address,
        chainId: chainId,
        contractAddress: contractAddress,
        tokenName: tokenName,
        tokenSymbol: tokenSymbol,
        tokenQuantity: tokenQuantity,
        tokenDivisor: tokenDivisor,
        updatedAt: DateTime.now(),
      ),
    );
  }

  /// Insert or update multiple token balances (batch operation)
  Future<void> upsertTokenBalances({
    required String address,
    required int chainId,
    required List<Map<String, dynamic>> tokenBalances,
  }) async {
    await batch((batch) {
      for (final token in tokenBalances) {
        batch.insert(
          tokenBalanceTable,
          TokenBalanceTableCompanion.insert(
            address: address,
            chainId: chainId,
            contractAddress: token['contractAddress'] as String,
            tokenName: token['tokenName'] as String,
            tokenSymbol: token['tokenSymbol'] as String,
            tokenQuantity: token['tokenQuantity'] as String,
            tokenDivisor: token['tokenDivisor'] as String,
            updatedAt: DateTime.now(),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  /// Delete all token balances for a specific address and chain
  Future<int> deleteTokenBalances({
    required String address,
    required int chainId,
  }) {
    return (delete(tokenBalanceTable)..where(
          (tbl) => tbl.address.equals(address) & tbl.chainId.equals(chainId),
        ))
        .go();
  }

  /// Clear all token balances
  Future<int> clearAllTokenBalances() {
    return delete(tokenBalanceTable).go();
  }

  /// Watch token balances changes for a specific address and chain
  Stream<List<TokenBalanceEntity>> watchTokenBalances({
    required String address,
    required int chainId,
  }) {
    return (select(tokenBalanceTable)..where(
          (tbl) => tbl.address.equals(address) & tbl.chainId.equals(chainId),
        ))
        .watch();
  }
}
