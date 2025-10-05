import 'package:drift/drift.dart';

@DataClassName('BalanceEntity')
class BalanceTable extends Table {
  @override
  String get tableName => 'balances';

  // Primary key - wallet address + chain ID combination
  TextColumn get address => text()();
  IntColumn get chainId => integer()();

  // Balance data - stored as string since BigInt is not natively supported
  TextColumn get weiAmount => text()();

  // Metadata
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {address, chainId};
}
