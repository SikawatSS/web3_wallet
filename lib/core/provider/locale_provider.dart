import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  static const String _localeKey = 'app_locale';

  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  bool get isEnglish => _locale.languageCode == 'en';
  bool get isThai => _locale.languageCode == 'th';

  LocaleProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString(_localeKey) ?? 'en';

    _locale = Locale(localeCode);

    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;

    _locale = locale;

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }

  void toggleLocale() {
    final newLocale = _locale.languageCode == 'en'
        ? const Locale('th')
        : const Locale('en');

    setLocale(newLocale);
  }
}
