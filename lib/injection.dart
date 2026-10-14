import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'data/datasources/auth_remote_data_source.dart';
import 'data/datasources/firestore_post_datasource.dart';
import 'data/datasources/local_post_datasource.dart';

import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/post_repository_impl.dart';

import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/post_repository.dart';

import 'presentation/blocs/auth_cubit.dart';
import 'presentation/blocs/post_cubit.dart';
import 'presentation/blocs/profile_cubit.dart';

import 'services/biometric_service.dart';
import 'services/device_info_service.dart';
import 'services/storage_service.dart';

final sl = GetIt.instance;

Future<void> setupInjection() async {
  // External
  sl.registerLazySingleton(() => FirebaseAuth.instance);

  // Requirement: Apply the Singleton Pattern to the Firestore service — only one instance must exist throughout the app lifecycle.
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  // Services
  sl.registerLazySingleton(() => BiometricService());
  sl.registerLazySingleton(() => DeviceInfoService());
  sl.registerLazySingleton(() => StorageService());

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(firebaseAuth: sl(), firestore: sl()),
  );

  sl.registerLazySingleton<FirestorePostDataSource>(
    () => FirestorePostDataSourceImpl(firestore: sl()),
  );

  sl.registerLazySingleton<LocalPostDataSource>(
    () => LocalPostDataSourceImpl(),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Applies Factory Pattern internally to choose data source
  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // Blocs/Cubits
  sl.registerFactory(() => AuthCubit(authRepository: sl()));
  sl.registerFactory(() => PostCubit(postRepository: sl()));

  sl.registerFactory(
    () => ProfileCubit(
      biometricService: sl(),
      deviceInfoService: sl(),
      storageService: sl(),
      firestore: sl(),
    ),
  );
}
