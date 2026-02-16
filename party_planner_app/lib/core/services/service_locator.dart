import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/dashboard/data/event_repository.dart';
import '../../features/planner/services/ai_service.dart';
import '../../features/planner/logic/planner_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // External
  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => FirebaseFirestore.instance);

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(firebaseAuth: getIt()),
  );

  getIt.registerLazySingleton<EventRepository>(
    () => EventRepository(firestore: getIt()),
  );
  
  // Blocs - Typically registered as factories if they hold state per screen, 
  // or singletons if global. AuthBloc is usually global.
  // We'll see how we construct it later.
  
  // Services
  getIt.registerLazySingleton<AIService>(() => AIService());

  // Blocs
  getIt.registerFactory<PlannerBloc>(() => PlannerBloc(aiService: getIt()));
}
