import 'package:flutter/material.dart';

class PaywallButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String name;
  final String description;
  final String price;

  const PaywallButton({
    super.key,
    required this.name,
    required this.description,
    required this.price,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: colorScheme.primaryContainer,
          border: Border.all(
            color: colorScheme.primary,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            Text(
              price,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
