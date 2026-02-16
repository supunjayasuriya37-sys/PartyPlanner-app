import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/auth/data/auth_repository.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // External
  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => FirebaseFirestore.instance);

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(firebaseAuth: getIt()),
  );
  
  // Blocs - Typically registered as factories if they hold state per screen, 
  // or singletons if global. AuthBloc is usually global.
  // We'll see how we construct it later.
}
