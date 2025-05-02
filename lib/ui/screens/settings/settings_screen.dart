import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/words.dart';
import '../../../data/models/word_status.dart';
import '../../../generated/assets.dart';
import '../../blocs/iap/iap_bloc.dart';
import '../../commons/ads/banner_ad_widget.dart';
import '../../commons/base_page.dart';
import '../../commons/rounded_button.dart';
import '../notifications/bloc/notifications_bloc.dart';
import '../vocabulary/widgets/vocabulary_item.dart';
import 'bloc/settings_bloc.dart';
import 'widgets/profile_field.dart';
import 'widgets/theme_item.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  static const seeks = [
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.teal,
    Colors.indigo,
    Colors.cyan,
    Colors.amber,
    Colors.red,
  ];

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  WordStatus _status = WordStatus.unknown;
  bool _isSelectingTheme = false;
  bool _interacted = false;
  late final ScrollController _scrollController;
  static const int _timerPeriod = 8000;
  static const int _duration = 7000;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isGrantedNotificationsPermission = context.watch<NotificationsBloc>().state.isNotificationsGranted;
    final isPremium = context.watch<IapBloc>().state.boughtNoAdsTime != null;
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final settingsSnapshot = state.settingsSnapshot;
        return BasePage(
          title: "Settings",
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VocabularyItem(
                              word: Words.sampleWord,
                              onMastered: _onMastered,
                              onStar: _onStar,
                              viewOnly: true,
                            ),
                            Text(
                              "Color",
                              style: textTheme.titleMedium?.copyWith(
                                color: colorScheme.secondary.withValues(alpha: 0.6),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 72,
                        child: GestureDetector(
                          onPanDown: (_) {
                            setState(() {
                              _interacted = true;
                            });
                          },
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: SettingsScreen.seeks.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () => _onChangeColor(context, SettingsScreen.seeks[index].value),
                                child: Container(
                                  width: 60,
                                  margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                                  decoration: BoxDecoration(
                                    color:
                                    ColorScheme.fromSeed(
                                      seedColor: SettingsScreen.seeks[index],
                                      brightness: brightness,
                                    ).primaryContainer,
                                    boxShadow: [
                                      BoxShadow(
                                        color: colorScheme.primary.withValues(alpha: 0.2),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            Text(
                              "Theme",
                              style: textTheme.titleMedium?.copyWith(
                                color: colorScheme.secondary.withValues(alpha: 0.6),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: _isSelectingTheme ? 160 : 65,
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(color: colorScheme.secondary.withValues(alpha: 0.2), width: 1.5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: !_isSelectingTheme
                                  ? ThemeItem(
                                      themeMode: ThemeMode.values[settingsSnapshot.themeMode],
                                      onPress: () {
                                        setState(() {
                                          _isSelectingTheme = true;
                                        });
                                      },
                                    )
                                  : SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        spacing: 8,
                                        children: ThemeMode.values.map((themeMode) {
                                          return Column(
                                            children: [
                                              ThemeItem(
                                                themeMode: themeMode,
                                                onPress: () => _onChangeTheme(context, themeMode.index),
                                                hasDivider: themeMode != ThemeMode.values.last,
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 16),
                            ProfileField(
                              onPressed: _openContactMail,
                              title: "Contact us",
                              value:
                                  "If you have any questions or suggestions, please contact us for support. We will respond as soon as possible.",
                            ),
                            Divider(),
                            ProfileField(
                              onPressed: _openTermsOfUse,
                              title: "Terms of Use",
                            ),
                            Divider(),
                            ProfileField(
                              onPressed: _openPrivacyPolicy,
                              title: "Privacy Policy",
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              if (!isGrantedNotificationsPermission)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RoundedButton(
                    onPressed: _openNotificationsSettings,
                    borderRadius: 16,
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          Assets.svgNotifications,
                          height: 20,
                          colorFilter: ColorFilter.mode(
                            colorScheme.onPrimary,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text("Enable Notifications"),
                      ],
                    ),
                  ),
                ),
              BannerAdWidget(
                isPremium: isPremium,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: _duration),
        curve: Curves.easeInOut,
      );
      Timer.periodic(const Duration(milliseconds: _timerPeriod), (timer) {
        if (_interacted) {
          timer.cancel();
        } else {
          if (_scrollController.position.pixels > 0) {
            _scrollController.animateTo(0, duration: const Duration(milliseconds: _duration), curve: Curves.easeInOut);
          } else {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: _duration),
              curve: Curves.easeInOut,
            );
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onChangeTheme(BuildContext context, int? value) {
    if (value == null) {
      return;
    }
    setState(() {
      _isSelectingTheme = false;
    });
    context.read<SettingsBloc>().add(
          SettingsEvent.saveSettings(
            themeMode: value,
          ),
        );
  }

  void _onChangeColor(BuildContext context, int value) {
    context.read<SettingsBloc>().add(
          SettingsEvent.saveSettings(
            seek: value,
          ),
        );
  }

  void _openNotificationsSettings() {
    AppSettings.openAppSettings(type: AppSettingsType.notification);
  }

  void _onMastered() {
    if (_status == WordStatus.mastered) {
      setState(() {
        _status = WordStatus.unknown;
      });
    } else {
      setState(() {
        _status = WordStatus.mastered;
      });
    }
  }

  void _onStar() {
    if (_status == WordStatus.star) {
      setState(() {
        _status = WordStatus.unknown;
      });
    } else {
      setState(() {
        _status = WordStatus.star;
      });
    }
  }

  void _openContactMail() async {
    final contactEmail = const String.fromEnvironment("CONTACT_EMAIL");
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: contactEmail,
      query: 'subject=Feedback For English Handbook',
    );
    await launchUrl(emailLaunchUri);
  }

  void _openTermsOfUse() async {
    final termsOfUseUrl = const String.fromEnvironment("TERMS_OF_USE_URL");
    await launchUrl(Uri.parse(termsOfUseUrl));
  }

  void _openPrivacyPolicy() async {
    final privacyPolicyUrl = const String.fromEnvironment("PRIVACY_POLICY_URL");
    await launchUrl(Uri.parse(privacyPolicyUrl));
  }
}
