import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:social_app/presentation/screens/home_page.dart';
import 'package:social_app/presentation/screens/splash_screen.dart';
import 'package:social_app/presentation/screens/login_page.dart';
import 'package:social_app/presentation/screens/registration_page.dart';
import 'package:social_app/presentation/screens/account_page.dart';
import 'package:social_app/presentation/screens/profile_page.dart';

enum AppRoutes { home, splashScreen, login, register, account, profile }

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
    GoRoute(
      path: '/login',
      name: AppRoutes.login.name,
      pageBuilder: (context, state) {
        return MaterialPage(
          child: LoginPage(),
        );
      },
    ),
    GoRoute(
      path: '/register',
      name: AppRoutes.register.name,
      pageBuilder: (context, state) {
        return MaterialPage(
          child: RegistrationPage(),
        );
      },
    ),
    GoRoute(
      path: '/account',
      name: AppRoutes.account.name,
      pageBuilder: (context, state) {
        return MaterialPage(
          child: AccountPage(),
        );
      },
    ),
    GoRoute(
      path: '/profile',
      name: AppRoutes.profile.name,
      pageBuilder: (context, state) {
        return MaterialPage(
          child: ProfilePage(),
        );
      },
    ),
  ],
);
