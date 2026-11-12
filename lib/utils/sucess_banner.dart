import 'package:another_flushbar/another_flushbar.dart';
import 'package:flutter/material.dart';

void showSuccessBanner(
  BuildContext context,
  String message, {
  int seconds = 3,
}) {
  Flushbar(
    message: message,
    duration: Duration(seconds: seconds),
    flushbarPosition: FlushbarPosition.TOP,
    flushbarStyle: FlushbarStyle.FLOATING,
    backgroundColor: Colors.green.shade700,
    borderRadius: BorderRadius.circular(12),
    margin: const EdgeInsets.all(12),
    icon: const Icon(Icons.check_circle, color: Colors.white),
  ).show(context);
}
