// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get balance => 'Balance';

  @override
  String get tokenBalances => 'Token Balances';

  @override
  String get loading => 'Loading';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Retry';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get unknownError => 'Unknown Error';

  @override
  String get unknownErrorDescription =>
      'Something went wrong.\nPlease try again.';

  @override
  String get unknownErrorButton => 'OK';

  @override
  String get overview => 'Overview';

  @override
  String get crypto => 'Crypto';

  @override
  String get totalValue => 'Total Value';

  @override
  String get estTotalValue => 'Est. Total Value';

  @override
  String get eth => 'ETH';

  @override
  String get usdt => 'USDT';

  @override
  String get wallet => 'Wallet : ';
}
