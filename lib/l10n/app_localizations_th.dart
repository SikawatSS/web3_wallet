// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get balance => 'ยอดเงิน';

  @override
  String get tokenBalances => 'ยอดเงิน';

  @override
  String get loading => 'กำลังโหลด';

  @override
  String get error => 'เกิดข้อผิดพลาด';

  @override
  String get retry => 'ลองอีกครั้ง';

  @override
  String get tryAgain => 'ลองอีกครั้ง';

  @override
  String get unknownError => 'เกิดข้อผิดพลาด';

  @override
  String get unknownErrorDescription => 'เกิดข้อผิดพลาด\nกรุณาลองอีกครั้ง';

  @override
  String get unknownErrorButton => 'OK';

  @override
  String get overview => 'ภาพรวม';

  @override
  String get crypto => 'Crypto';

  @override
  String get totalValue => 'ค่ารวม';

  @override
  String get estTotalValue => 'ค่ารวม';

  @override
  String get eth => 'ETH';

  @override
  String get usdt => 'USDT';

  @override
  String get wallet => 'Wallet : ';
}
