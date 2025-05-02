import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/category_data.dart';
import '../../../data/models/lesson.dart';
import '../../../navigation/app_router.dart';
import '../../blocs/iap/iap_bloc.dart';
import '../../commons/ads/banner_ad_widget.dart';
import '../../commons/ads/rewarded_ad_mixin.dart';
import '../../commons/base_page.dart';
import '../../commons/dialogs/paywall_dialog.dart';
import 'bloc/lesson_bloc.dart';
import 'widget/category_item.dart';

class CategoryScreen extends StatefulWidget {
  final CategoryData category;

  const CategoryScreen({super.key, required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> with RewardedAdMixin {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final queriedLesson = query.isNotEmpty
        ? widget.category.lessons.where((element) {
            return element.title.toLowerCase().contains(query.toLowerCase()) ||
                (element.subTitle?.toLowerCase() ?? "").contains(query.toLowerCase());
          }).toList()
        : widget.category.lessons;
    final isPremium = context.watch<IapBloc>().state.boughtNoAdsTime != null;
    return BasePage(
      title: widget.category.title,
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: 'Search',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: _onSearch,
            onSubmitted: _onSearch,
            onTapOutside: (_) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: queriedLesson.length,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: CategoryItem(
                        isBeta: widget.category.isBeta,
                        onMark: (value) {
                          _onMark(queriedLesson[index], value);
                        },
                        lesson: queriedLesson[index],
                        hasAds: !isPremium && index >= 3,
                        onTap: () {
                          _onTap(index, queriedLesson[index]);
                        },
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
          ),
        ],
      ),
    );
  }

  void _onSearch(String value) {
    setState(() {
      query = value;
    });
  }

  void _onMark(Lesson queriedLesson, bool? value) {
    context.read<LessonBloc>().add(LessonEvent.markLesson(id: queriedLesson.id, isMarked: value ?? false));
  }

  _onTap(int index, Lesson lesson) {
    final isPremium = context.read<IapBloc>().state.boughtNoAdsTime != null;
    if (!isPremium && index >= 3) {
      showRewardedAd((_, __) {
        context.push(RoutePaths.lesson, extra: {'lesson': lesson});
      });
    } else {
      context.push(RoutePaths.lesson, extra: {'lesson': lesson});
    }
  }

  @override
  bool get isPremium => context.read<IapBloc>().state.boughtNoAdsTime != null;
}
