import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/models/category_data.dart';
import '../../../../navigation/app_router.dart';
import '../../../commons/animated_progress_bar.dart';

class HomeItem extends StatelessWidget {
  final CategoryData category;

  const HomeItem({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => _onTap(context),
      child: Container(
        decoration: BoxDecoration(color: colorScheme.primaryContainer, borderRadius: BorderRadius.circular(16)),
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.title,
                    style: textTheme.titleMedium?.copyWith(
                      decoration: category.progress == category.total ? TextDecoration.lineThrough : null,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    category.description,
                    style: textTheme.bodyMedium?.copyWith(
                      decoration: category.progress == category.total ? TextDecoration.lineThrough : null,
                      color: colorScheme.secondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8.0),
                  AnimatedProgressBar(value: category.progress / category.total),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTap(BuildContext context) {
    context.push(RoutePaths.category, extra: {'category': category});
  }
}
