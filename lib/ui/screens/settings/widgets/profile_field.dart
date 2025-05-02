import 'package:flutter/material.dart';

class ProfileField extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final String? value;

  const ProfileField({
    super.key,
    required this.onPressed,
    required this.title,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (value != null) ...[
              const SizedBox(height: 8.0),
              Text(
                value!,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.secondary,
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
