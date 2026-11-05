import 'package:flutter/material.dart';

import '../features/auth/login_page.dart';
import '../features/home/home_page.dart';

abstract final class AppRoutes {
  static const login = '/login';
  static const home = '/home';

  static final Map<String, WidgetBuilder> routes = {
    login: (_) => const LoginPage(),
    home: (_) => const HomePage(),
  };
}
