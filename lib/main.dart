import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/app_config.dart';
import 'core/config/theme/app_theme.dart';
import 'core/di/providers.dart';
import 'core/router/app_router.dart';
import 'data/services/supabase_service.dart';

void main() async {
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

  // Supabase 초기화
  await SupabaseService.initialize();

  // SupabaseService 인스턴스 생성 및 초기화
  final supabaseService = await SupabaseService().init();

  runApp(
    ProviderScope(
      overrides: [
        supabaseServiceProvider.overrideWithValue(supabaseService),
      ],
      child: const PumeunGidoApp(),
    ),
  );
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
