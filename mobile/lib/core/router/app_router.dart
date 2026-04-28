import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) {
          return const Scaffold(body: SizedBox());
        },
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) {
          return const RegisterScreen();
        },
      ),
      GoRoute(
        path: '/join',
        name: 'join',
        builder: (context, state) {
          return const Scaffold(body: SizedBox());
        },
      ),
      GoRoute(
        path: '/manager-dashboard',
        name: 'manager_dashboard',
        builder: (context, state) {
          return const Scaffold(body: SizedBox());
        },
      ),
      GoRoute(
        path: '/resident-dashboard',
        name: 'resident_dashboard',
        builder: (context, state) {
          return const Scaffold(body: SizedBox());
        },
      ),
    ],
  );
}
