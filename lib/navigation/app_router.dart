import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grammar_polisher/utils/global_values.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

import '../configs/di.dart';
import '../data/models/category_data.dart';
import '../data/models/lesson.dart';
import '../data/models/word.dart';
import '../ui/screens/grammar/bloc/lesson_bloc.dart';
import '../ui/screens/grammar/category_screen.dart';
import '../ui/screens/grammar/lesson_screen.dart';
import '../ui/screens/grammar/grammar_screen.dart';
import '../ui/screens/home_navigation/home_navigation.dart';
import '../ui/screens/notifications/bloc/notifications_bloc.dart';
import '../ui/screens/onboaring/onboarding_screen.dart';
import '../ui/screens/review/flash_card_screen.dart';
import '../ui/screens/review/review_screen.dart';
import '../ui/screens/settings/settings_screen.dart';
import '../ui/screens/streak/bloc/streak_bloc.dart';
import '../ui/screens/streak/streak_screen.dart';
import '../ui/screens/vocabulary/bloc/vocabulary_bloc.dart';
import '../ui/screens/vocabulary/vocabulary_screen.dart';
import '../ui/screens/vocabulary/word_details_screen.dart';

part 'route_paths.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

  static Amplitude amplitude = DI().sl<Amplitude>();

  static final router = GoRouter(
    initialLocation: RoutePaths.vocabulary,
    navigatorKey: rootNavigatorKey,
    redirect: (context, state) {
      amplitude.track(BaseEvent(state.uri.path));
      if (!GlobalValues.isShowOnboarding) {
        GlobalValues.isShowOnboarding = true;
        return RoutePaths.onboarding;
      }
      return null;
    },
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shellRoutes) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => DI().sl<VocabularyBloc>(),
              ),
              BlocProvider(
                create: (context) => DI().sl<NotificationsBloc>(),
              ),
              BlocProvider(
                create: (context) => DI().sl<LessonBloc>(),
              ),
              BlocProvider(
                create: (context) => DI().sl<StreakBloc>(),
              ),
            ],
            child: HomeNavigation(
              child: shellRoutes,
            ),
          );
        },
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePaths.vocabulary,
              pageBuilder: (context, state) {
                final extra = state.extra as Map<String, dynamic>?;
                final wordId = extra?['wordId'] as int?;
                return NoTransitionPage(
                  key: state.pageKey,
                  child: VocabularyScreen(wordId: wordId),
                );
              },
            ),
            GoRoute(
              path: RoutePaths.wordDetails,
              pageBuilder: (context, state) {
                final extra = state.extra as Map<String, dynamic>?;
                final word = extra?['word'] as Word;
                return SwipeablePage(
                  key: state.pageKey,
                  builder: (context) => WordDetailsScreen(word: word),
                );
              },
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePaths.review,
              pageBuilder: (context, state) {
                return NoTransitionPage(
                  key: state.pageKey,
                  child: ReviewScreen(),
                );
              },
            ),
            GoRoute(
              path: RoutePaths.flashcards,
              pageBuilder: (context, state) {
                final extra = state.extra as Map<String, dynamic>?;
                final words = extra?['words'] as List<Word>;
                return SwipeablePage(
                  key: state.pageKey,
                  builder: (context) => FlashCardScreen(
                    words: words,
                  ),
                );
              },
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePaths.grammar,
              pageBuilder: (context, state) {
                return NoTransitionPage(
                  key: state.pageKey,
                  child: GrammarScreen(),
                );
              },
            ),
            GoRoute(
              path: RoutePaths.category,
              pageBuilder: (context, state) {
                final extra = state.extra as Map<String, dynamic>?;
                final category = extra?['category'] as CategoryData;
                return SwipeablePage(
                  key: state.pageKey,
                  builder: (context) => CategoryScreen(
                    category: category,
                  ),
                );
              },
            ),
            GoRoute(
              path: RoutePaths.lesson,
              pageBuilder: (context, state) {
                final extra = state.extra as Map<String, dynamic>?;
                final lesson = extra?['lesson'] as Lesson;
                return SwipeablePage(
                  key: state.pageKey,
                  builder: (context) => LessonScreen(
                    lesson: lesson,
                  ),
                );
              },
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePaths.streak,
              pageBuilder: (context, state) {
                return NoTransitionPage(
                  key: state.pageKey,
                  child: const StreakScreen(),
                );
              },
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePaths.settings,
              pageBuilder: (context, state) {
                return NoTransitionPage(
                  key: state.pageKey,
                  child: const SettingsScreen(),
                );
              },
            )
          ]),
        ],
      ),
      GoRoute(
        path: RoutePaths.onboarding,
        pageBuilder: (context, state) {
          return NoTransitionPage(
            key: state.pageKey,
            child: const OnboardingScreen(),
          );
        },
      ),
    ],
  );
}
