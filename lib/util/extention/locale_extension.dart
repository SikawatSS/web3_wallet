import 'package:flutter/material.dart';
import 'package:web3_wallet/l10n/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
