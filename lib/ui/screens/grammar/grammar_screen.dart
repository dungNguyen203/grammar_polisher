import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grammar_polisher/utils/app_snack_bar.dart';

import '../../../../generated/assets.dart';
import '../../../data/models/category_data.dart';
import '../../../data/models/lesson.dart';
import '../../blocs/iap/iap_bloc.dart';
import '../../commons/ads/banner_ad_widget.dart';
import '../../commons/base_page.dart';
import 'bloc/lesson_bloc.dart';
import 'widget/home_item.dart';

class GrammarScreen extends StatefulWidget {
  final List<CategoryData> categories = [
    const CategoryData(id: 1, title: 'Tenses', description: '13 tenses in English', progress: 0, total: 13, lessons: [
      Lesson(id: 1, title: 'Simple Present', subTitle: 'S + to be/V + O', path: Assets.presentSimplePresentTense),
      Lesson(id: 2, title: 'Present Continuous', subTitle: 'S + to be + V-ing + O', path: Assets.presentPresentContinuousTense),
      Lesson(id: 3, title: 'Present Perfect', subTitle: 'S + have/has + V3 + O', path: Assets.presentPresentPerfectTense),
      Lesson(
          id: 4,
          title: 'Present Perfect Continuous',
          subTitle: 'S + have/has + been + V-ing + O',
          path: Assets.presentPresentPerfectContinuousTense),
      Lesson(id: 5, title: 'Simple Past', subTitle: 'S + V2 + O', path: Assets.pastSimplePastTense),
      Lesson(id: 6, title: 'Past Continuous', subTitle: 'S + was/were + V-ing + O', path: Assets.pastPastContinuousTense),
      Lesson(id: 7, title: 'Past Perfect', subTitle: 'S + had + V3 + O', path: Assets.pastPastPerfectTense),
      Lesson(
          id: 8,
          title: 'Past Perfect Continuous',
          subTitle: 'S + had + been + V-ing + O',
          path: Assets.pastPastPerfectContinuousTense),
      Lesson(id: 9, title: 'Simple Future', subTitle: 'S + will + V + O', path: Assets.futureFutureSimpleTense),
      Lesson(id: 10, title: 'Future Continuous', subTitle: 'S + will + be + V-ing + O', path: Assets.futureFutureContinuousTense),
      Lesson(id: 11, title: 'Future Perfect', subTitle: 'S + will + have + V3 + O', path: Assets.futureFuturePerfectTense),
      Lesson(
          id: 12,
          title: 'Future Perfect Continuous',
          subTitle: 'S + will + have + been + V-ing + O',
          path: Assets.futureFuturePerfectContinuousTense),
      Lesson(id: 13, title: 'Near Future', subTitle: 'S + to be + going to + V + O', path: Assets.futureNearFuture),
    ]),
    const CategoryData(id: 2, title: 'Sentences', description: 'Sentences in English', progress: 0, total: 8, lessons: [
      Lesson(
          id: 14,
          title: 'Passive Voice',
          subTitle: 'Emphasize the action rather than the doer',
          path: Assets.sentencesPassiveVoice),
      Lesson(id: 15, title: 'Reported Speech', subTitle: 'Report what someone else said', path: Assets.sentencesReportedSpeech),
      Lesson(
          id: 16,
          title: 'Conditional Sentences',
          subTitle: '4 types of conditional sentences',
          path: Assets.sentencesConditionalSentences),
      Lesson(id: 17, title: 'Wish Sentences', subTitle: 'Express regret or desire', path: Assets.sentencesWishSentences),
      Lesson(
          id: 18, title: 'Question Tags', subTitle: 'Short questions at the end of a sentence', path: Assets.sentencesQuestionTags),
      Lesson(
          id: 19,
          title: 'Imperative Sentences',
          subTitle: 'Give orders or instructions',
          path: Assets.sentencesImperativeSentences),
      Lesson(
          id: 20, title: 'Comparison Sentences', subTitle: 'Compare two or more things', path: Assets.sentencesComparisonSentences),
      Lesson(
          id: 21, title: 'Exclamatory Sentences', subTitle: 'Express strong feelings', path: Assets.sentencesExclamatorySentences),
    ]),
    const CategoryData(id: 3, title: 'Words', description: 'Words in English', progress: 0, total: 9, lessons: [
      Lesson(id: 22, title: 'Nouns', subTitle: 'Person, place, thing, or idea', path: Assets.wordFamiliesNouns),
      Lesson(id: 23, title: 'Pronouns', subTitle: 'Replace nouns', path: Assets.wordsPronouns),
      Lesson(id: 24, title: 'Adjectives', subTitle: 'Describe nouns', path: Assets.wordFamiliesAdjectives),
      Lesson(id: 25, title: 'Adverbs', subTitle: 'Describe verbs, adjectives, or other adverbs', path: Assets.wordFamiliesAdverbs),
      Lesson(
          id: 26,
          title: 'Prepositions',
          subTitle: 'Show the relationship between a noun and another word',
          path: Assets.wordsPreposition),
      Lesson(id: 27, title: 'Conjunctions', subTitle: 'Connect words, phrases, or clauses', path: Assets.wordsConjunction),
      Lesson(id: 28, title: 'Interjections', subTitle: 'Express strong feelings or emotions', path: Assets.wordsInterjection),
      Lesson(id: 29, title: 'Articles', subTitle: 'A, an, the', path: Assets.wordsArticle),
      Lesson(
          id: 32,
          title: 'Modals Verbs',
          subTitle: 'Can, could, may, might, must, shall, should, will, would',
          path: Assets.wordsModalVerbs),
    ]),
    const CategoryData(id: 4, title: "Others", description: "Other grammar topics", progress: 0, total: 5, lessons: [
      Lesson(
          id: 33, title: "Word Families", subTitle: "Words that are related to each other", path: Assets.wordFamiliesWordFamilies),
      Lesson(id: 34, title: "Phrasal Verbs", subTitle: "Verb + preposition or adverb", path: Assets.grammarPhrasalVerbs),
      Lesson(
          id: 35,
          title: "Idioms",
          subTitle: "Expressions that have a meaning different from the meaning of the individual words",
          path: Assets.grammarIdioms),
      Lesson(
          id: 36, title: "Proverbs", subTitle: "Short sayings that give advice or express a belief", path: Assets.grammarProverbs),
      Lesson(id: 37, title: "Quantifiers", subTitle: "Words that describe quantity", path: Assets.grammarQuantifiers),
    ]),
  ];

  GrammarScreen({super.key});

  @override
  State<GrammarScreen> createState() => _GrammarScreenState();
}

class _GrammarScreenState extends State<GrammarScreen> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final queriedCategories = query.isNotEmpty
        ? widget.categories.where((element) {
            return element.title.toLowerCase().contains(query.toLowerCase()) ||
                element.description.toLowerCase().contains(query.toLowerCase());
          }).toList()
        : widget.categories;
    final isPremium = context.watch<IapBloc>().state.boughtNoAdsTime != null;
    return BlocConsumer<LessonBloc, LessonState>(
      listener: (context, state) {
        if (state.message != null) {
          AppSnackBar.showSuccess(context, state.message!);
        }

        if (state.error != null) {
          AppSnackBar.showError(context, state.error!);
        }
      },
      builder: (context, state) {
        final categories = queriedCategories.map((category) {
          final total = category.lessons.length;
          final progress = category.lessons.where((element) => state.markedLessons[element.id] ?? false).length;
          return category.copyWith(progress: progress, total: total);
        }).toList();
        return BasePage(
          title: "Grammar",
          child: ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: HomeItem(
                      category: categories[index],
                    ),
                  ),
                  if (index == 1)
                    BannerAdWidget(
                      isPremium: isPremium,
                      paddingVertical: 16,
                      paddingHorizontal: 16,
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
