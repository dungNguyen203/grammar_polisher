import 'package:flutter/material.dart';

class AnimatedProgressBar extends StatelessWidget {
  final double value;
  const AnimatedProgressBar({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    var activeWidth = value * (size.width - 32);
    if (activeWidth <= 36) {
      activeWidth = 36;
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Container(
        height: 24,
        width: double.infinity,
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: 24,
              width: activeWidth,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    '${(value * 100).toStringAsFixed(0)}%',
                    style: textTheme.titleSmall?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}