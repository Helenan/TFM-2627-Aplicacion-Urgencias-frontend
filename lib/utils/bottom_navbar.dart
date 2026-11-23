import 'package:flutter/material.dart';

import 'nav_entry.dart';

class BottomNavbar<T> extends StatelessWidget implements PreferredSizeWidget {
  final List<NavEntry> entries;
  final double height;

  const BottomNavbar({super.key, required this.entries, this.height = 100});

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final navTheme = Theme.of(context).navigationBarTheme;

    return Container(
      height: height,
      color: navTheme.backgroundColor,
      child: MediaQuery.removeViewInsets(
        context: context,
        removeBottom: true,
        child: SafeArea(
          child: Row(
            children: [
              for (final entry in entries)
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.black45, width: 0.5),
                        left: BorderSide(color: Colors.black45, width: 0.5),
                        right: BorderSide(color: Colors.black45, width: 0.5),
                      ),
                    ),
                    child: entry,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
