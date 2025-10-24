// /// This file sets up the service locator using the GetIt package.
// /// It registers all the dependencies required for the application.

// import 'package:dio/dio.dart';
// import 'package:get/get.dart';
// import 'package:get_it/get_it.dart';

// /// Global service locator instance
// GetIt locator = GetIt.instance;

// /// Sets up the service locator with all the necessary dependencies.
// setupLocator() async {
//   /// **************** Auth ******************
//   locator.registerLazySingleton<AuthRemoteDatasource>(
//       () => AuthRemoteDatasourceImpl(locator()));
//   locator.registerLazySingleton<AuthLocalDatasource>(
//       () => AuthLocalDatasourceImpl(locator<LocalStorageService>()));
//   locator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
//       locator<AuthRemoteDatasource>(), locator<AuthLocalDatasource>()));
//  }
