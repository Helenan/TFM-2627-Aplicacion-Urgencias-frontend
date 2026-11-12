import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void showErrorBanner(BuildContext context, String message, {int seconds = 4}) {
  final theme = Theme.of(context);

  Flushbar(
    message: message,
    duration: Duration(seconds: seconds),
    flushbarPosition: FlushbarPosition.TOP,
    flushbarStyle: FlushbarStyle.FLOATING,
    backgroundColor: theme.colorScheme.errorContainer,
    borderRadius: BorderRadius.circular(12),
    margin: const EdgeInsets.all(12),
    icon: const Icon(Icons.error_outline, color: Colors.white),
  ).show(context);
}
