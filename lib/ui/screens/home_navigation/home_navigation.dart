import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../core/failure.dart';
import '../../../generated/assets.dart';
import '../../../utils/app_snack_bar.dart';
import '../../../utils/extensions/go_router_extension.dart';
import '../../../navigation/app_router.dart';
import '../../blocs/iap/iap_bloc.dart';
import '../../commons/dialogs/paywall_dialog.dart';
import '../../commons/purchase_success_dialog.dart';
import '../notifications/bloc/notifications_bloc.dart';
import '../streak/bloc/streak_bloc.dart';
import '../vocabulary/bloc/vocabulary_bloc.dart';
import 'widget/streak_button.dart';

class HomeNavigation extends StatefulWidget {
  final StatefulNavigationShell child;

  const HomeNavigation({super.key, required this.child});

  static const routes = [
    RoutePaths.vocabulary,
    RoutePaths.review,
    RoutePaths.grammar,
    RoutePaths.streak,
    RoutePaths.settings,
  ];

  static const icons = [
    Assets.svgVocabulary,
    Assets.svgStar,
    Assets.svgGrammar,
    Assets.svgStreak,
    Assets.svgSettings,
  ];

  static const labels = [
    "Vocabulary",
    "Studying",
    "Grammar",
    "Streak",
    "Settings",
  ];

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  late final AppLifecycleListener _appLifecycleListener;

  @override
  Widget build(BuildContext context) {
    final iapState = context.watch<IapBloc>().state;

    final isLoading = iapState.isLoading;

    final colorScheme = Theme.of(context).colorScheme;

    final currentRoute = GoRouter.of(context).currentRoute;
    var selectedIndex = HomeNavigation.routes.indexOf(currentRoute);
    if (selectedIndex == -1 && currentRoute == RoutePaths.flashcards) {
      selectedIndex = 2;
    }
    final selectedColor = colorScheme.primary;
    final unselectedColor = Colors.grey[600]!;

    return MultiBlocListener(
      listeners: [
        BlocListener<NotificationsBloc, NotificationsState>(
          listener: (context, state) {
            _handleError(context, state.failure);
            if (state.wordIdFromNotification != null) {
              context.go(RoutePaths.vocabulary, extra: {'wordId': state.wordIdFromNotification});
            }
            if (state.message != null) {
              AppSnackBar.showSuccess(context, state.message!);
            }
          },
        ),
        BlocListener<IapBloc, IapState>(
          listener: (context, state) {
            _handleError(context, state.failure);
          },
        ),
        BlocListener<IapBloc, IapState>(
          listenWhen: (previous, current) {
            return previous.boughtNoAdsTime != current.boughtNoAdsTime;
          },
          listener: (context, state) {
            if (state.boughtNoAdsTime == -1) {
              showDialog(context: context, builder: (_) => PurchaseSuccessDialog());
            }
          },
        ),
        BlocListener<IapBloc, IapState>(
          listenWhen: (previous, current) {
            return previous.products != current.products;
          },
          listener: (context, state) {
            final isPremium = state.boughtNoAdsTime == -1;
            if (!isPremium) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showDialog(context: context, builder: (_) => PaywallDialog());
              });
            }
          },
        ),
      ],
      child: Scaffold(
        floatingActionButton: [0, 2].contains(widget.child.currentIndex) &&
                HomeNavigation.routes.contains(widget.child.shellRouteContext.routerState.uri.path)
            ? StreakButton(
                onPressed: () {
                  widget.child.goBranch(HomeNavigation.routes.indexOf(RoutePaths.streak));
                },
              )
            : null,
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(child: widget.child),
              ],
            ),
            if (isLoading)
              Container(
                color: Colors.white.withAlpha(100),
                alignment: Alignment.center,
                child: LoadingAnimationWidget.threeArchedCircle(
                  color: colorScheme.primary,
                  size: 48,
                ),
              )
          ],
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ), //
          child: BottomNavigationBar(
            showUnselectedLabels: true,
            currentIndex: selectedIndex == -1 ? 0 : selectedIndex,
            selectedFontSize: 12,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: selectedColor,
            unselectedItemColor: unselectedColor,
            onTap: _onSelect,
            items: List.generate(
              HomeNavigation.labels.length,
              (index) => BottomNavigationBarItem(
                icon: Container(
                  decoration: BoxDecoration(
                    color: index == selectedIndex ? colorScheme.primaryContainer : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(2),
                  child: SvgPicture.asset(
                    HomeNavigation.icons[index],
                    colorFilter: ColorFilter.mode(
                      index == selectedIndex ? selectedColor : unselectedColor,
                      BlendMode.srcIn,
                    ),
                    height: 24,
                  ),
                ),
                label: HomeNavigation.labels[index],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final notificationsBloc = context.read<NotificationsBloc>();
    notificationsBloc.add(const NotificationsEvent.requestPermissions());
    notificationsBloc.add(const NotificationsEvent.handleOpenAppFromNotification());
    context.read<StreakBloc>().add(const StreakEvent.watchStreak());
    context.read<VocabularyBloc>().add(const VocabularyEvent.getAllOxfordWords());
    _appLifecycleListener = AppLifecycleListener(
      onShow: () {
        debugPrint('NotificationsScreen: onShow');
        // this is needed to update the permissions status when the user returns to the app after changing the notification settings
        notificationsBloc.add(const NotificationsEvent.requestPermissions());
      },
    );
  }

  @override
  void dispose() {
    _appLifecycleListener.dispose();
    super.dispose();
  }

  void _onSelect(int value) {
    if (value == HomeNavigation.routes.indexOf(RoutePaths.streak)) {
      context.read<NotificationsBloc>().add(const NotificationsEvent.getScheduledNotifications());
    }
    widget.child.goBranch(value);
  }

  _handleError(BuildContext context, Failure? failure) {
    if (failure != null) {
      AppSnackBar.showError(context, failure.message);
    }
  }
}
