import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../constants/words.dart';
import '../../../data/models/word_status.dart';
import '../../../generated/assets.dart';
import '../../../navigation/app_router.dart';
import '../../commons/rounded_button.dart';
import '../../commons/selection_area_with_search.dart';
import '../vocabulary/widgets/vocabulary_item.dart';
import 'onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController? _pageController;
  bool _isReviewing = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                OnboardingPage(
                  header: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: Image.asset(
                      Assets.pngLauncherPlaystore,
                      width: 200,
                    ),
                  ),
                  label: 'Welcome to English Handbook!',
                  content: 'The best english learning in the world!\nWe\'re glad to have you here.\nLet\'s get started!',
                ),
                OnboardingPage(
                  header: VocabularyItem(
                    word: Words.sampleWord,
                    onMastered: () {},
                    onStar: () {},
                    viewOnly: true,
                  ),
                  label: 'View definitions and start learning!',
                  content: 'You can tap on any word to view its definition and start learning it.',
                ),
                OnboardingPage(
                  header: SelectionAreaWithSearch(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Markdown(
                        data: r'''### 📝 **Adjectives**
      
An **adjective** is a word that describes or modifies a noun or pronoun by providing more information about its quality, size, color, shape, condition, or other attributes.''',
                        shrinkWrap: true,
                      ),
                    ),
                  ),
                  label: 'Grammar lessons',
                  content:
                      'Grammar lessons are available for you to learn. Long press on any text to translate. Try it now!',
                ),
                Stack(
                  children: [
                    OnboardingPage(
                      header: VocabularyItem(
                        word: Words.sampleWord.copyWith(status: _isReviewing ? WordStatus.star : WordStatus.unknown),
                        onMastered: () {},
                        onStar: () {
                          setState(() {
                            _isReviewing = !_isReviewing;
                          });
                        },
                        viewOnly: true,
                      ),
                      label: 'Review and Flashcard',
                      content:
                          'Modify the definition for your own understanding.\nAdd words to your review list and start learning with flashcards.\nNow, try pressing the star button!',
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Opacity(
                        opacity: _isReviewing ? 1 : 0.5,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: RoundedButton(
                            borderRadius: 16,
                            backgroundColor: colorScheme.tertiary,
                            onPressed: _isReviewing
                                ? () {
                                    context.go(RoutePaths.flashcards, extra: {
                                      'words': [Words.sampleWord, Words.helloWord]
                                    });
                                  }
                                : null,
                            child: const Text('Start learning'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          SmoothPageIndicator(
            controller: _pageController!,
            effect: WormEffect(
              dotColor: colorScheme.secondary.withValues(alpha: 0.3),
              activeDotColor: colorScheme.primary,
              dotHeight: 10,
              dotWidth: 10,
            ),
            count: 4,
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: RoundedButton(
                borderRadius: 16,
                onPressed: _onNext,
                child: const Text('Next'),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onNext() {
    if (_pageController?.page?.toInt() == 3) {
      context.go(RoutePaths.vocabulary);
      return;
    }
    _pageController?.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }
}
