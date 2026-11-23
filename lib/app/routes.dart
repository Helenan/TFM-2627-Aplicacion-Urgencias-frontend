import 'package:flutter/material.dart';
import 'package:tfm_2627_aplicacion_urgencias_frontend/features/register/register_page.dart';

import '../features/auth/login_page.dart';
import '../features/auth/user_page.dart';
import '../features/home/home_page.dart';

abstract final class AppRoutes {
  static const login = '/login';
  static const home = '/home';
  static const user = '/user';
  static const register = '/register';

  static final Map<String, WidgetBuilder> routes = {
    login: (_) => const LoginPage(),
    home: (_) => const HomePage(),
    user: (_) => const UserPage(),
    register: (_) => const RegisterPage(),
  };
}
