import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/configuration.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/data_sources/assets_data.dart';
import '../data/data_sources/local_data.dart';
import '../data/data_sources/pair_storage.dart';
import '../data/data_sources/translation_data.dart';
import '../data/repositories/global_repository.dart';
import '../data/repositories/iap_repository.dart';
import '../data/repositories/lesson_repository.dart';
import '../data/repositories/notifications_repository.dart';
import '../data/repositories/oxford_words_repository.dart';
import '../data/repositories/settings_repository.dart';
import '../data/repositories/streak_repository.dart';
import '../ui/blocs/iap/iap_bloc.dart';
import '../ui/blocs/translate/translate_cubit.dart';
import '../ui/screens/grammar/bloc/lesson_bloc.dart';
import '../ui/screens/settings/bloc/settings_bloc.dart';
import '../ui/screens/streak/bloc/streak_bloc.dart';
import '../ui/screens/vocabulary/bloc/vocabulary_bloc.dart';
import '../ui/screens/notifications/bloc/notifications_bloc.dart';
import '../utils/local_notifications_tools.dart';
import 'dio/app_dio.dart';
import 'hive/app_hive.dart';

class DI {
  static DI? _instance;

  DI._();

  factory DI() {
    _instance ??= DI._();
    return _instance!;
  }

  final sl = GetIt.instance;

  Future<void> init() async {
    // Blocs

    sl.registerLazySingleton<VocabularyBloc>(
      () => VocabularyBloc(
        oxfordWordsRepository: sl(),
      ),
    );

    sl.registerLazySingleton<IapBloc>(
      () => IapBloc(
        iapRepository: sl(),
      ),
    );

    sl.registerFactory(
      () => NotificationsBloc(
        localNotificationsTools: sl(),
        notificationsRepository: sl(),
      ),
    );

    sl.registerFactory(
      () => SettingsBloc(
        settingsRepository: sl(),
      ),
    );

    sl.registerFactory(
      () => LessonBloc(
        lessonRepository: sl(),
      ),
    );

    sl.registerFactory(
      () => StreakBloc(
        streakRepository: sl(),
      ),
    );

    sl.registerFactory(
      () => TranslateCubit(
        globalRepository: sl(),
      ),
    );

    sl.registerLazySingleton<IapRepository>(
      () => IapRepositoryImpl(),
    );

    sl.registerLazySingleton<OxfordWordsRepository>(
      () => OxfordWordsRepositoryImpl(
        assetsData: sl(),
        localData: sl(),
      ),
    );

    sl.registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(
        localData: sl(),
      ),
    );

    sl.registerLazySingleton<NotificationsRepository>(
      () => NotificationsRepositoryImpl(
        localData: sl(),
      ),
    );

    sl.registerLazySingleton<LessonRepository>(
      () => LessonRepositoryImpl(
        pairStorage: sl(),
      ),
    );

    sl.registerLazySingleton<GlobalRepository>(
      () => GlobalRepositoryImpl(
        translationData: sl(),
      ),
    );

    sl.registerLazySingleton<StreakRepository>(
      () => StreakRepositoryImpl(
        pairStorage: sl(),
      ),
    );

    sl.registerLazySingleton<AssetsData>(
      () => AssetsDataImpl(),
    );

    sl.registerLazySingleton<LocalData>(
      () => HiveDatabase(
        appHive: sl(),
      ),
    );

    sl.registerLazySingleton<TranslationData>(
      () => GoogleTranslateData(
        dio: sl(),
      ),
    );

    sl.registerLazySingleton<PairStorage>(
      () => SharedPreferencesStorage(
        sharedPreferences: sl(),
      ),
    );

    // Tools
    sl.registerLazySingleton<Dio>(
      () => TranslationDio(
        connectivity: Connectivity(),
      ).dio,
    );

    sl.registerLazySingleton<LocalNotificationsTools>(
      () => LocalNotificationsTools(),
    );

    final appHive = AppHive();
    await appHive.init();
    sl.registerLazySingleton<AppHive>(
      () => appHive,
    );

    sl.registerLazySingleton<AudioPlayer>(
      () => AudioPlayer(),
    );

    const apiKey = String.fromEnvironment('AMPLITUDE_API_KEY');
    final amplitude = Amplitude(Configuration(
      apiKey: apiKey,
    ));
    sl.registerLazySingleton<Amplitude>(
      () => amplitude,
    );

    final prefs = await SharedPreferences.getInstance();
    sl.registerLazySingleton<SharedPreferences>(
      () => prefs,
    );
  }
}
