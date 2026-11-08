import 'package:flutter/material.dart';

class ErrorContainer extends StatelessWidget {
  final String errorMessage;

  const ErrorContainer({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        border: Border.all(color: theme.colorScheme.error, width: 2),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsetsGeometry.symmetric(vertical: 10, horizontal: 5),
            child: Icon(Icons.info_outline, color: theme.colorScheme.error),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: errorMessage,
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
