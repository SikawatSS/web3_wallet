import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mocktail/mocktail.dart';
import 'package:web3_wallet/core/api/api_client.dart';
import 'package:web3_wallet/data/datasources/local/balance_local_datasource.dart';
import 'package:web3_wallet/data/datasources/local/token_balance_local_datasource.dart';
import 'package:web3_wallet/data/datasources/remote/etherscan_remote_datasource.dart';
import 'package:web3_wallet/domain/repositories/wallet_repository.dart';
import 'package:web3_wallet/domain/usecase/balance_usecase.dart';
import 'package:web3_wallet/domain/usecase/cached_balance_usecase.dart';
import 'package:web3_wallet/domain/usecase/cached_token_balances_usecase.dart';
import 'package:web3_wallet/domain/usecase/token_balances_usecase.dart';
import 'package:web3_wallet/l10n/app_localizations.dart';
import 'package:web3_wallet/util/theme.dart';

// Mock classes for testing

/// Mock ApiClient
class MockApiClient extends Mock implements ApiClient {}

/// Mock EtherscanRemoteDataSource
class MockEtherscanRemoteDataSource extends Mock
    implements EtherscanRemoteDataSource {}

/// Mock BalanceLocalDataSource
class MockBalanceLocalDataSource extends Mock
    implements BalanceLocalDataSource {}

/// Mock TokenBalanceLocalDataSource
class MockTokenBalanceLocalDataSource extends Mock
    implements TokenBalanceLocalDataSource {}

/// Mock WalletRepository
class MockWalletRepository extends Mock implements WalletRepository {}

/// Mock GetBalanceUseCase
class MockGetBalanceUseCase extends Mock implements GetBalanceUseCase {}

/// Mock GetCachedBalanceUseCase
class MockGetCachedBalanceUseCase extends Mock
    implements GetCachedBalanceUseCase {}

/// Mock GetTokenBalancesUseCase
class MockGetTokenBalancesUseCase extends Mock
    implements GetTokenBalancesUseCase {}

/// Mock GetCachedTokenBalancesUseCase
class MockGetCachedTokenBalancesUseCase extends Mock
    implements GetCachedTokenBalancesUseCase {}

// Test Helper Functions

/// Creates a properly wrapped widget for testing with MaterialApp, localization, and theme
Widget createTestWidget(Widget child) {
  return MaterialApp(
    theme: AppTheme.lightTheme,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: child,
  );
}
