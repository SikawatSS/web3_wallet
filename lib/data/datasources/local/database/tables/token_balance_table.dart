import 'package:drift/drift.dart';

@DataClassName('TokenBalanceEntity')
class TokenBalanceTable extends Table {
  @override
  String get tableName => 'token_balances';

  // Composite primary key - wallet address + chain ID + contract address
  TextColumn get address => text()();
  IntColumn get chainId => integer()();
  TextColumn get contractAddress => text()();

  // Token data
  TextColumn get tokenName => text()();
  TextColumn get tokenSymbol => text()();
  TextColumn get tokenQuantity => text()();
  TextColumn get tokenDivisor => text()();

  // Metadata
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {address, chainId, contractAddress};
}
