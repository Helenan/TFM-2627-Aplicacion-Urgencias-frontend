import 'package:flutter/material.dart';

import '../app/theme/colors.dart';
import 'nav_entry.dart';

class BottomNavbar<T> extends StatelessWidget implements PreferredSizeWidget {
  final List<NavEntry> entries;
  final double height;

  const BottomNavbar({super.key, required this.entries, this.height = 96});

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final navTheme = Theme.of(context).navigationBarTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: navTheme.backgroundColor,
        border: const Border(top: BorderSide(color: AppColors.navBarBorder)),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: MediaQuery.removeViewInsets(
          context: context,
          removeBottom: true,
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: height,
              child: Row(
                children: [for (final entry in entries) Expanded(child: entry)],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
