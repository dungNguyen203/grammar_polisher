import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../data/models/lesson.dart';
import '../../../../generated/assets.dart';
import '../bloc/lesson_bloc.dart';

class CategoryItem extends StatelessWidget {
  final bool hasAds;
  final Lesson lesson;
  final Function(bool?) onMark;
  final bool isBeta;
  final VoidCallback? onTap;

  const CategoryItem({
    super.key,
    required this.lesson,
    required this.onMark,
    this.hasAds = false,
    this.isBeta = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return BlocBuilder<LessonBloc, LessonState>(
      builder: (context, state) {
        final isMarked = state.markedLessons[lesson.id] ?? false;
        return MaterialButton(
          elevation: 0.0,
          padding: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: isMarked ? colorScheme.secondaryContainer : colorScheme.primaryContainer,
          onPressed: isBeta ? null : onTap,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          lesson.title,
                          style: textTheme.titleSmall?.copyWith(
                            decoration: isMarked ? TextDecoration.lineThrough : null,
                            color: isMarked
                                ? colorScheme.onSecondaryContainer
                                : colorScheme.onPrimaryContainer.withValues(
                                    alpha: isBeta ? 0.5 : 1,
                                  ),
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        if (hasAds)
                          SvgPicture.asset(
                            Assets.svgTimerPlay,
                            height: 16,
                            colorFilter: ColorFilter.mode(
                              colorScheme.onPrimaryContainer,
                              BlendMode.srcIn,
                            ),
                          )
                      ],
                    ),
                    if (lesson.subTitle != null)
                      Text(
                        lesson.subTitle!,
                        style: textTheme.bodySmall?.copyWith(
                          decoration: isMarked ? TextDecoration.lineThrough : null,
                          color: isMarked
                              ? colorScheme.onSecondaryContainer
                              : colorScheme.onPrimaryContainer.withValues(
                                  alpha: isBeta ? 0.5 : 1,
                                ),
                        ),
                      ),
                  ],
                ),
              ),
              Checkbox(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                value: state.markedLessons[lesson.id] ?? false,
                onChanged: isBeta ? null : onMark,
              )
            ],
          ),
        );
      },
    );
  }
}
