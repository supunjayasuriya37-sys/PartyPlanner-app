import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/logic/auth_bloc.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/planner/screens/ai_planner_screen.dart';

class AppRouter {
  final AuthBloc authBloc;

  AppRouter(this.authBloc);

  late final GoRouter router = GoRouter(
    initialLocation: '/',
    refreshListenable: StreamListenable(authBloc.stream),
    redirect: (context, state) {
      final authState = authBloc.state;
      final isOnLogin = state.uri.toString() == '/login';
      final isLoggedIn = authState is AuthAuthenticated;

      // If not logged in (including error state), redirect to login
      if (!isLoggedIn && !isOnLogin) return '/login';
      // If logged in and still on login page, redirect to home
      if (isLoggedIn && isOnLogin) return '/';

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const DashboardScreen(),
        routes: [
          GoRoute(
            path: 'planner',
            builder: (context, state) => const AIPlannerScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
    ],
  );
}

class StreamListenable extends ChangeNotifier {
  final Stream stream;
  StreamListenable(this.stream) {
    stream.listen((_) => notifyListeners());
  }
}
