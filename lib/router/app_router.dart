import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:social_app/presentation/screens/home_page.dart';
import 'package:social_app/presentation/screens/splash_screen.dart';

enum AppRoutes { home, splashScreen }

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      name: AppRoutes.splashScreen.name,
      pageBuilder: (context, state) {
        return MaterialPage(
          child: SplashScreenWrapper(),
        );
      },
    ),
    GoRoute(
      path: '/home',
      name: AppRoutes.home.name,
      pageBuilder: (context, state) {
        return MaterialPage(
          child: HomeScreen(),
        );
      },
    ),
  ],
);
