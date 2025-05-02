import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/custom_colors.dart';
import '../../../data/models/word.dart';
import '../../../data/models/word_status.dart';
import '../../../generated/assets.dart';
import '../../../navigation/app_router.dart';
import '../../../utils/app_snack_bar.dart';
import '../../../utils/global_values.dart';
import '../../blocs/iap/iap_bloc.dart';
import '../../commons/ads/banner_ad_widget.dart';
import '../../commons/ads/interstitial_ad_mixin.dart';
import '../../commons/base_page.dart';
import '../../commons/rounded_button.dart';
import '../vocabulary/bloc/vocabulary_bloc.dart';
import 'widgets/flashcard_app_dialog.dart';
import 'widgets/positioned_flash_card.dart';

class FlashCardScreen extends StatefulWidget {
  final List<Word> words;

  const FlashCardScreen({super.key, required this.words});

  @override
  State<FlashCardScreen> createState() => _FlashCardScreenState();
}

class _FlashCardScreenState extends State<FlashCardScreen> with InterstitialAdMixin {
  final List<Word> _words = [];
  final List<PositionedFlashCardController> _controllers = [];
  bool _animating = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final isPremium = context.watch<IapBloc>().state.boughtNoAdsTime != null;
    return PopScope(
      onPopInvokedWithResult: (_, __) {
        debugPrint('PopScope invoked');
        if (!GlobalValues.isShowInAppReview) {
          debugPrint('Requesting review');
          InAppReview.instance.requestReview();
          GlobalValues.isShowInAppReview = true;
        } else if (!GlobalValues.isShowFlashCardAppDialog) {
          debugPrint('Showing dialog');
          GlobalValues.isShowFlashCardAppDialog = true;
          showDialog(context: context, builder: (_) => FlashcardAppDialog());
        } else {
          debugPrint('Showing interstitial');
          showInterstitialAd();
        }
      },
      child: BasePage(
        title: 'Flashcards',
        padding: const EdgeInsets.all(0),
        child: Stack(
          children: [
            BannerAdWidget(
              isPremium: isPremium,
            ),
            Column(
              children: [
                const Spacer(),
                SizedBox(
                  height: size.height * 0.4,
                  child: Stack(
                    alignment: Alignment.center,
                    children: List.generate(
                      _words.length,
                      (index) {
                        final word = _words[index];
                        return PositionedFlashCard(
                          key: ValueKey(word.index),
                          controller: _controllers[index],
                          word: word,
                        );
                      },
                    ),
                  ),
                ),
                const Spacer(),
                GlobalValues.isShowFlashCardAppDialog
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: _openFlashcardApp,
                            child: Text(
                              "Try advance flashcard",
                              style: textTheme.titleSmall?.copyWith(
                                color: colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: RoundedButton(
                          backgroundColor: CustomColors.red,
                          onPressed: _onCheckBack,
                          borderRadius: 16,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                Assets.svgUndo,
                                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                height: 16,
                                width: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Check back",
                                style: textTheme.titleSmall?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: RoundedButton(
                          backgroundColor: CustomColors.green,
                          onPressed: _onMastered,
                          borderRadius: 16,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                Assets.svgCheck,
                                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                height: 16,
                                width: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Mastered",
                                style: textTheme.titleSmall?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _words.addAll(widget.words);
    _controllers.addAll(List.generate(widget.words.length, (index) => PositionedFlashCardController()));
  }

  void _onCheckBack() async {
    if (_animating) {
      return;
    }
    if (_words.length == 1) {
      AppSnackBar.showError(context, "You can't check back the last word");
      return;
    }
    _animating = true;
    await _controllers.last.checkBack();
    setState(() {
      _words.insert(0, _words.removeLast());
      _controllers.insert(0, _controllers.removeLast());
    });
    _animating = false;
  }

  void _onMastered() async {
    if (_animating) {
      return;
    }
    _animating = true;
    await _controllers.last.mastered();
    late Word masteredWord;
    setState(() {
      masteredWord = _words.removeLast();
      _controllers.removeLast();
    });
    if (mounted) {
      context.read<VocabularyBloc>().add(VocabularyEvent.changeStatus(masteredWord, WordStatus.mastered));
      if (_words.isEmpty) {
        if (!context.canPop()) {
          context.go(RoutePaths.vocabulary);
          return;
        }
        Navigator.of(context).pop();
      }
    }
    _animating = false;
  }

  _openFlashcardApp() {
    final url = Platform.isIOS ? const String.fromEnvironment('IOS_FLASHCARD_APP_URL') : const String.fromEnvironment('ANDROID_FLASHCARD_APP_URL');
    launchUrl(Uri.parse(url));
  }

  @override
  bool get isPremium => context.read<IapBloc>().state.boughtNoAdsTime != null;
}
