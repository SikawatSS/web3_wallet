import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:web3_wallet/data/datasources/local/database/daos/balance_dao.dart';
import 'package:web3_wallet/data/datasources/local/database/daos/token_balance_dao.dart';
import 'package:web3_wallet/data/datasources/local/database/tables/balance_table.dart';
import 'package:web3_wallet/data/datasources/local/database/tables/token_balance_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [BalanceTable, TokenBalanceTable],
  daos: [BalanceDao, TokenBalanceDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from == 1 && to == 2) {
          await m.createTable(tokenBalanceTable);
        }
      },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'web3_wallet_db');
  }
}
