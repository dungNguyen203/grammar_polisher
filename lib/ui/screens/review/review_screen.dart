import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:grammar_polisher/utils/extensions/date_time_extensions.dart';

import '../../../data/models/word.dart';
import '../../../data/models/word_status.dart';
import '../../../generated/assets.dart';
import '../../../navigation/app_router.dart';
import '../../../utils/global_values.dart';
import '../../blocs/iap/iap_bloc.dart';
import '../../commons/ads/banner_ad_widget.dart';
import '../../commons/ads/rewarded_ad_mixin.dart';
import '../../commons/base_page.dart';
import '../../commons/dialogs/paywall_dialog.dart';
import '../../commons/rounded_button.dart';
import '../vocabulary/bloc/vocabulary_bloc.dart';
import '../vocabulary/widgets/vocabulary_item.dart';
import 'widgets/empty_review_page.dart';
import 'widgets/schedule_modal.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> with RewardedAdMixin {
  bool _hasReviewed = GlobalValues.lastReviewTime == null ? false : GlobalValues.lastReviewTime!.isSameDay(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final vocabularyState = context.watch<VocabularyBloc>().state;
    final reviewWords = vocabularyState.words.where((word) => word.status == WordStatus.star).toList();
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isPremium = context.watch<IapBloc>().state.boughtNoAdsTime != null;
    return BasePage(
      title: 'Review',
      actions: [
        if (vocabularyState.words.any((word) => word.status == WordStatus.unknown))
          TextButton(
            onPressed: () => _showScheduleModal(context, reviewWords),
            child: Text(
              'Schedule',
              style: textTheme.titleSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
      ],
      child: reviewWords.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: reviewWords.length,
                    itemBuilder: (context, index) {
                      final word = reviewWords[index];
                      return Column(
                        children: [
                          VocabularyItem(
                            word: word,
                            showReviewButton: false,
                          ),
                          if (index == 1) ...[
                            BannerAdWidget(
                              paddingHorizontal: 16,
                              paddingVertical: 8,
                              isPremium: isPremium,
                            ),
                          ]
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                RoundedButton(
                  onPressed: () => _startFlashcards(context, reviewWords),
                  borderRadius: 16,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_hasReviewed && !isPremium) ...[
                        SvgPicture.asset(
                          Assets.svgTimerPlay,
                          colorFilter: ColorFilter.mode(colorScheme.onPrimary, BlendMode.srcIn),
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        'Start Flashcards',
                        style: textTheme.titleSmall?.copyWith(color: colorScheme.onPrimary, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            )
          : EmptyReviewPage(
              hasWords: vocabularyState.words.any((word) => word.status == WordStatus.unknown),
            ),
    );
  }

  void _showScheduleModal(BuildContext context, List<Word> reviewWords) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ScheduleModal(
        reviewWords: reviewWords,
      ),
    );
  }

  void _startFlashcards(BuildContext context, List<Word> reviewWords) {
    if (_hasReviewed && !isPremium) {
      showRewardedAd((_, __) {
        context.push(RoutePaths.flashcards, extra: {'words': reviewWords});
      });
    } else {
      context.push(RoutePaths.flashcards, extra: {'words': reviewWords});
    }
    setState(() {
      _hasReviewed = true;
    });
    GlobalValues.setLastReviewTime(DateTime.now());
  }

  @override
  bool get isPremium => context.read<IapBloc>().state.boughtNoAdsTime != null;
}
