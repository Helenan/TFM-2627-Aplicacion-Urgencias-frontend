import 'package:flutter/material.dart';

import '../app/theme/colors.dart';

class NavEntry extends StatelessWidget {
  final Icon icon;
  final String? label;
  final Future<void> Function(BuildContext context)? onTap;

  const NavEntry({super.key, required this.icon, this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final navTheme = theme.navigationBarTheme;
    final labelStyle =
        navTheme.labelTextStyle?.resolve({}) ?? const TextStyle();

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () async {
        if (onTap != null) {
          await onTap!(context);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 36,
            alignment: Alignment.center,
            decoration: ShapeDecoration(
              color: AppColors.componentBackground,
              shape: const StadiumBorder(),
            ),
            child: IconTheme.merge(
              data: IconThemeData(size: 26, color: theme.colorScheme.primary),
              child: icon,
            ),
          ),
          if (label != null) ...[
            const SizedBox(height: 6),
            Text(
              label!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: labelStyle,
            ),
          ],
        ],
      ),
    );
  }
}
