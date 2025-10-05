import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:web3_wallet/core/db/app_database.dart';
import 'package:web3_wallet/core/di.dart';
import 'package:web3_wallet/core/global_context.dart';
import 'package:web3_wallet/core/provider/locale_provider.dart';
import 'package:web3_wallet/l10n/app_localizations.dart';
import 'package:web3_wallet/util/theme.dart';

import 'presentation/wallet/page/wallet_landing.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env.development');

  setupDi();

  await getIt.getAsync<AppDatabase>();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: GlobalContext.navigatorKey,
        title: dotenv.env['APP_NAME']!,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        home: const WalletLandingPage(),
      ),
    );
  }
}
