import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/services/service_locator.dart';
import 'features/auth/logic/auth_bloc.dart';
import 'router/app_router.dart';
import 'features/auth/data/auth_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase (uses google-services.json / GoogleService-Info.plist)
  await Firebase.initializeApp();
  
  // Initialize dependency injection
  await setupServiceLocator();

  runApp(const PartyPlannerApp());
}

class PartyPlannerApp extends StatefulWidget {
  const PartyPlannerApp({super.key});

  @override
  State<PartyPlannerApp> createState() => _PartyPlannerAppState();
}

class _PartyPlannerAppState extends State<PartyPlannerApp> {
  late final AuthBloc _authBloc;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc(authRepository: getIt<AuthRepository>())
      ..add(AppStarted());
    _appRouter = AppRouter(_authBloc);
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _authBloc,
      child: MaterialApp.router(
        title: 'PartyPlanner',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: _appRouter.router,
      ),
    );
  }
}
