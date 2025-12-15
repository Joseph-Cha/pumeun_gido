import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/app_config.dart';
import 'core/config/theme/app_theme.dart';
import 'core/di/providers.dart';
import 'core/router/app_router.dart';
import 'data/services/ad_service.dart';
import 'data/services/supabase_service.dart';
import 'firebase_options.dart';

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // 환경변수 로드 (기본: 리얼 환경)
    await AppConfig.loadEnv();

    // 상태바 스타일 설정
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    // 세로 모드 고정
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Firebase 초기화
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Crashlytics 설정
    // 디버그 모드에서는 Crashlytics 비활성화
    if (kDebugMode) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    } else {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    }

    // Flutter 프레임워크 에러 핸들링
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    // Supabase 초기화
    await SupabaseService.initialize();

    // SupabaseService 인스턴스 생성 및 초기화
    final supabaseService = await SupabaseService().init();

    // AdMob 초기화
    await AdService().initialize();

    runApp(
      ProviderScope(
        overrides: [
          supabaseServiceProvider.overrideWithValue(supabaseService),
        ],
        child: const PumeunGidoApp(),
      ),
    );
  }, (error, stack) {
    // 비동기 에러 핸들링
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  });
}

/// 품은기도 앱
class PumeunGidoApp extends ConsumerWidget {
  const PumeunGidoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: '품은기도',
      debugShowCheckedModeBanner: false,

      // 테마
      theme: AppTheme.lightTheme,

      // GoRouter 설정
      routerConfig: router,

      // 로케일 설정
      locale: const Locale('ko', 'KR'),
    );
  }
}
