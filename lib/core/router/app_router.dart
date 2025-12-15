import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/splash/splash_screen.dart';
import '../../presentation/login/login_screen.dart';
import '../../presentation/home/home_screen.dart';
import '../../presentation/prayer/prayer_detail_screen.dart';
import '../../presentation/prayer/prayer_form_screen.dart';
import '../../presentation/people/people_list_screen.dart';
import '../../presentation/settings/settings_screen.dart';
import '../../presentation/settings/webview_screen.dart';

/// 라우트 경로 상수
abstract class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String prayerDetail = '/prayer/:id';
  static const String prayerForm = '/prayer/form';
  static const String people = '/people';
  static const String personPrayers = '/people/:id/prayers';
  static const String settings = '/settings';
  static const String webview = '/webview';
}

/// GoRouter Provider
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.prayerForm,
        builder: (context, state) {
          final prayerId = state.extra as String?;
          return PrayerFormScreen(prayerId: prayerId);
        },
      ),
      GoRoute(
        path: '/prayer/:id',
        builder: (context, state) {
          final prayerId = state.pathParameters['id']!;
          return PrayerDetailScreen(prayerId: prayerId);
        },
      ),
      GoRoute(
        path: AppRoutes.people,
        builder: (context, state) => const PeopleListScreen(),
      ),
      GoRoute(
        path: '/people/:id/prayers',
        builder: (context, state) {
          final requesterId = state.pathParameters['id']!;
          final requesterName = state.extra as String? ?? '';
          return HomeScreen(
            requesterId: requesterId,
            requesterName: requesterName,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.webview,
        builder: (context, state) {
          final extra = state.extra as Map<String, String>?;
          return WebViewScreen(
            title: extra?['title'] ?? '',
            url: extra?['url'] ?? '',
          );
        },
      ),
    ],
  );
});
