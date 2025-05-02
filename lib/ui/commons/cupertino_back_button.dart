import 'package:flutter/material.dart';

class ShadowButton extends StatelessWidget {
  final VoidCallback onPress;
  final Widget child;
  const ShadowButton({
    super.key,
    required this.onPress,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return IconButton(
      style: IconButton.styleFrom(
        elevation: 8.0,
        backgroundColor: colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadowColor: colorScheme.primary.withValues(alpha: 0.1),
        padding: const EdgeInsets.all(0),
      ),
      onPressed: onPress,
      icon: child,
    );
  }
}
