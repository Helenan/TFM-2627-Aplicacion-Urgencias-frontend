import 'package:flutter/material.dart';

class NavEntry extends StatelessWidget {
  final Icon icon;
  final String? label;
  final Future<void> Function(BuildContext context)? onTap;

  const NavEntry({super.key, required this.icon, this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final navTheme = Theme.of(context).navigationBarTheme;
    final labelStyle =
        navTheme.labelTextStyle?.resolve({}) ?? const TextStyle();

    return InkWell(
      onTap: () async {
        if (onTap != null) {
          await onTap!(context);
        }
      },
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (label != null) Text(label!, style: labelStyle),
            const SizedBox(height: 4),

            icon,
          ],
        ),
      ),
    );
  }
}
