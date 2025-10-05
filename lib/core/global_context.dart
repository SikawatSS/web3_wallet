import 'package:flutter/material.dart';

class GlobalContext {
  GlobalContext._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static BuildContext get context => navigatorKey.currentContext!;

  static bool get hasContext => navigatorKey.currentContext != null;
}
