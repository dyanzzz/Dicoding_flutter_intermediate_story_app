import 'package:dicoding_story_flutter/screens/error_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../screens/home_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/story/story_detail_screen.dart';
import '../screens/story/story_form_screen.dart';
import './provider/auth_provider.dart';
import './screens/auth/login_screen.dart';
import './screens/auth/register_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/splash',
    redirect: (BuildContext context, GoRouterState state) async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final isLoggedIn = await authProvider.isLoggedIn();

      // Jika sedang di halaman splash, biarkan proses terus berjalan
      if (state.matchedLocation == '/splash') return null;

      // Logika redirect berdasarkan status login
      if (isLoggedIn) {
        // Jika sudah login tapi mencoba akses halaman auth, redirect ke home
        if (state.matchedLocation == '/login' ||
            state.matchedLocation == '/register') {
          return '/';
        }
      } else {
        // Jika belum login dan bukan di halaman auth, redirect ke login
        if (state.matchedLocation != '/login' &&
            state.matchedLocation != '/register') {
          return '/login';
        }
      }

      return null; // Tidak ada redirect
    },
    routes: [
      GoRoute(
        path: '/splash',
        pageBuilder:
            (context, state) =>
                MaterialPage(key: state.pageKey, child: const SplashPage()),
      ),
      GoRoute(
        path: '/login',
        pageBuilder:
            (context, state) =>
                MaterialPage(key: state.pageKey, child: const LoginPage()),
      ),
      GoRoute(
        path: '/register',
        pageBuilder:
            (context, state) =>
                MaterialPage(key: state.pageKey, child: const RegisterPage()),
      ),

      GoRoute(
        path: '/',
        pageBuilder:
            (context, state) =>
                MaterialPage(key: state.pageKey, child: const HomePage()),
        routes: [
          GoRoute(
            path: 'detail/:id',
            pageBuilder:
                (context, state) => MaterialPage(
                  key: state.pageKey,
                  child: StoryDetailPage(storyId: state.pathParameters['id']!),
                ),
          ),
          GoRoute(
            path: 'add',
            pageBuilder:
                (context, state) => MaterialPage(
                  key: state.pageKey,
                  child: const StoryFormPage(),
                ),
          ),
        ],
      ),
    ],
    errorPageBuilder:
        (context, state) => MaterialPage(
          key: state.pageKey,
          child: ErrorPage(error: state.error),
        ),
  );
}
