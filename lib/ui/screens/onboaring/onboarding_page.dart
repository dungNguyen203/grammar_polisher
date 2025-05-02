import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final Widget header;
  final String label;
  final String content;

  const OnboardingPage({
    super.key,
    required this.header,
    required this.label,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox(
              width: 600,
              child: Center(
                child: Text(
                  label,
                  style: textTheme.titleLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: header,
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: 600,
                  child: Text(
                    content,
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
