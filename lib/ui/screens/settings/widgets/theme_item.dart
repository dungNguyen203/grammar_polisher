import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grammar_polisher/utils/extensions/string_extensions.dart';

import '../bloc/settings_bloc.dart';

class ThemeItem extends StatelessWidget {
  final VoidCallback? onPress;
  final ThemeMode themeMode;
  final bool hasDivider;

  const ThemeItem({super.key, required this.themeMode, this.onPress, this.hasDivider = false});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final selectedThemeMode = state.settingsSnapshot.themeMode;
        return InkWell(
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          onTap: onPress,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 30,
                    decoration: BoxDecoration(
                      color: _getThemeColor(themeMode, colorScheme.primary),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: colorScheme.secondary, width: 1),
                    ),
                    child:
                    themeMode == ThemeMode.system
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Row(
                        children: [
                          Container(
                            width: 25,
                            height: 30,
                            color:
                            ColorScheme.fromSeed(
                              seedColor: colorScheme.primary,
                              brightness: Brightness.dark,
                            ).primaryContainer,
                          ),
                        ],
                      ),
                    )
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    themeMode.toString().toTitle().split(' ').last,
                    style: textTheme.titleSmall?.copyWith(
                      color: colorScheme.secondary.withValues(alpha: selectedThemeMode == themeMode.index ? 1 : 0.6),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(child: Container(color: Colors.transparent)),
                ],
              ),
              if (hasDivider) ...[
                const SizedBox(height: 8),
                Container(height: 1.5, color: colorScheme.secondary.withValues(alpha: 0.2)),
              ],
            ],
          ),
        );
      },
    );
  }

  _getThemeColor(ThemeMode themeMode, Color primaryColor) {
    switch (themeMode) {
      case ThemeMode.dark:
        return ColorScheme.fromSeed(seedColor: primaryColor, brightness: Brightness.dark).primaryContainer;
      default:
        return ColorScheme.fromSeed(seedColor: primaryColor, brightness: Brightness.light).primaryContainer;
    }
  }
}
