import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../data/models/lesson.dart';
import '../../blocs/iap/iap_bloc.dart';
import '../../commons/ads/banner_ad_widget.dart';
import '../../commons/ads/interstitial_ad_mixin.dart';
import '../../commons/base_page.dart';
import '../../commons/dialogs/translation_dialog.dart';
import '../../commons/selection_area_with_search.dart';
import 'bloc/lesson_bloc.dart';

class LessonScreen extends StatefulWidget {
  final Lesson lesson;

  const LessonScreen({super.key, required this.lesson});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> with InterstitialAdMixin {
  String? data;
  late ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    final title = widget.lesson.title;
    final isPremium = context.watch<IapBloc>().state.boughtNoAdsTime != null;
    final colorScheme = Theme.of(context).colorScheme;
    return BlocBuilder<LessonBloc, LessonState>(
      builder: (context, state) {
        return PopScope(
          onPopInvokedWithResult: (canPop, result) {
            if (_scrollController.offset >= _scrollController.position.maxScrollExtent - 100) {
              showInterstitialAd();
            }
          },
          child: Column(
            children: [
              Expanded(
                child: BasePage(
                  title: title,
                  actions: [
                    Checkbox(
                      value: state.markedLessons[widget.lesson.id] ?? false,
                      onChanged: (value) {
                        _onMarkAsRead(value);
                      },
                    )
                  ],
                  child: data == null
                      ? Center(child: LoadingAnimationWidget.fourRotatingDots(color: colorScheme.primary, size: 40))
                      : SelectionAreaWithSearch(
                          child: Markdown(data: data!, controller: _scrollController, softLineBreak: true),
                        ),
                ),
              ),
              BannerAdWidget(isPremium: isPremium),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadJson();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadJson() async {
    final data = await rootBundle.loadString(widget.lesson.path);
    setState(() {
      this.data = data;
    });
  }

  void _onMarkAsRead(bool? value) {
    if (value == null) return;
    context.read<LessonBloc>().add(LessonEvent.markLesson(id: widget.lesson.id, isMarked: value));
  }

  @override
  bool get isPremium => context.read<IapBloc>().state.boughtNoAdsTime != null;
}
