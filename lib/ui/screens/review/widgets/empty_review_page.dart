import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../generated/assets.dart';
import '../../../../navigation/app_router.dart';
import '../../../commons/rounded_button.dart';
import '../../vocabulary/bloc/vocabulary_bloc.dart';

class EmptyReviewPage extends StatelessWidget {
  final bool hasWords;
  const EmptyReviewPage({super.key, required this.hasWords});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          hasWords ? 'No words to review' : 'Congratulations!\nYou mastered all words!',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Image.asset(
          Assets.pngBook,
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Keep learning with our Grammarly AI\nto improve your English skills',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withAlpha(150),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        if (hasWords) ...[
          RoundedButton(
            expand: false,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            borderRadius: 8,
            onPressed: () => _onAddRandomWords(context),
            child: Text(
              'Randomly add 10 words to review',
            ),
          ),
          TextButton(
            onPressed: () => _onAddWords(context),
            child: Text(
              'Add manually by yourself',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ),
        ] else RoundedButton(
          expand: false,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          borderRadius: 8,
          onPressed: () => _onAddRandomWords(context),
          child: Text(
            'Learn with Grammarly AI',
          ),
        ),
      ],
    );
  }

  void _onAddWords(BuildContext context) {
    context.go(RoutePaths.vocabulary);
  }

  _onAddRandomWords(BuildContext context) {
     context.read<VocabularyBloc>().add(const VocabularyEvent.addWordRandomly());
  }
}
