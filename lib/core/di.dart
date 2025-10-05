import 'package:get_it/get_it.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web3_wallet/core/api/api_client.dart';
import 'package:web3_wallet/data/datasources/local/balance_local_datasource.dart';
import 'package:web3_wallet/core/db/app_database.dart';
import 'package:web3_wallet/data/datasources/local/token_balance_local_datasource.dart';
import 'package:web3_wallet/data/datasources/remote/etherscan_remote_datasource.dart';
import 'package:web3_wallet/data/repositories/wallet_repository_impl.dart';
import 'package:web3_wallet/domain/repositories/wallet_repository.dart';
import 'package:web3_wallet/domain/usecase/balance_usecase.dart';
import 'package:web3_wallet/domain/usecase/cached_balance_usecase.dart';
import 'package:web3_wallet/domain/usecase/cached_token_balances_usecase.dart';
import 'package:web3_wallet/domain/usecase/token_balances_usecase.dart';

final getIt = GetIt.instance;

void setupDi() {
  // Database - async singleton for faster initialization
  getIt.registerSingletonAsync<AppDatabase>(() async {
    final db = AppDatabase();
    await db.customSelect('SELECT 1').get();
    return db;
  });

  // Dio Client
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());

  // Data Sources
  getIt.registerFactory<EtherscanRemoteDataSource>(
    () => EtherscanRemoteDataSourceImpl(
      apiClient: getIt<ApiClient>(),
      apiKey: dotenv.env['ETHERSCAN_API_KEY']!,
      apiUrl: dotenv.env['ETHERSCAN_API_URL']!,
    ),
  );

  getIt.registerFactory<BalanceLocalDataSource>(
    () => BalanceLocalDataSourceImpl(database: getIt<AppDatabase>()),
  );

  getIt.registerFactory<TokenBalanceLocalDataSource>(
    () => TokenBalanceLocalDataSourceImpl(database: getIt<AppDatabase>()),
  );

  // Wallet Repositories
  getIt.registerFactory<WalletRepository>(
    () => WalletRepositoryImpl(
      remoteDataSource: getIt<EtherscanRemoteDataSource>(),
      localDataSource: getIt<BalanceLocalDataSource>(),
      tokenBalanceLocalDataSource: getIt<TokenBalanceLocalDataSource>(),
    ),
  );

  // Wallet UseCases
  getIt.registerFactory<GetBalanceUseCase>(
    () => GetBalanceUseCase(walletRepository: getIt<WalletRepository>()),
  );

  getIt.registerFactory<GetCachedBalanceUseCase>(
    () => GetCachedBalanceUseCase(walletRepository: getIt<WalletRepository>()),
  );

  getIt.registerFactory<GetTokenBalancesUseCase>(
    () => GetTokenBalancesUseCase(walletRepository: getIt<WalletRepository>()),
  );

  getIt.registerFactory<GetCachedTokenBalancesUseCase>(
    () => GetCachedTokenBalancesUseCase(
      walletRepository: getIt<WalletRepository>(),
    ),
  );
}
