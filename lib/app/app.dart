import 'package:flutter/material.dart';
import 'routes.dart';
import 'theme/theme.dart';

class AppUrgencias extends StatelessWidget {
  const AppUrgencias({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.mainTheme,
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}
