import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sonic_summit_mobile_app/app/shared_prefs/token_shared_prefs.dart';
import 'package:sonic_summit_mobile_app/core/network/api_service.dart';
import 'package:sonic_summit_mobile_app/core/network/hive_service.dart';
import 'package:sonic_summit_mobile_app/features/auth/data/data_source/auth_local_datasource/auth_local_datasource.dart';
import 'package:sonic_summit_mobile_app/features/auth/data/data_source/remote_data_source/auth_remote_data_source.dart';
import 'package:sonic_summit_mobile_app/features/auth/data/repository/auth_local_repository/auth_local_repository.dart';
import 'package:sonic_summit_mobile_app/features/auth/data/repository/auth_remote_repository/auth_remote_repository.dart';
import 'package:sonic_summit_mobile_app/features/auth/domain/use_case/login_usecase.dart';
import 'package:sonic_summit_mobile_app/features/auth/domain/use_case/register_user_usecase.dart';
import 'package:sonic_summit_mobile_app/features/auth/domain/use_case/upload_iamge_usecase.dart';
import 'package:sonic_summit_mobile_app/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:sonic_summit_mobile_app/features/auth/presentation/view_model/signup/register_bloc.dart';
import 'package:sonic_summit_mobile_app/features/browse/data/data_source/remote_data_source/product_remote_data_source.dart';
import 'package:sonic_summit_mobile_app/features/browse/data/repository/product_remote_repository.dart';
import 'package:sonic_summit_mobile_app/features/browse/domain/repository/product_repository.dart';
import 'package:sonic_summit_mobile_app/features/browse/domain/use_case/get_all_product_usecase.dart';
import 'package:sonic_summit_mobile_app/features/browse/presentation/view_model/product_bloc.dart';
import 'package:sonic_summit_mobile_app/features/cart/data/data_source/remote_data_source/cart_remote_data_source.dart';
import 'package:sonic_summit_mobile_app/features/cart/data/repository/cart_remote_repository.dart';
import 'package:sonic_summit_mobile_app/features/cart/domain/repository/cart_repository.dart';
import 'package:sonic_summit_mobile_app/features/cart/domain/use_case/get_cart_usecase.dart';
import 'package:sonic_summit_mobile_app/features/cart/presentation/view_model/cart_bloc.dart';
import 'package:sonic_summit_mobile_app/features/home/presentation/view_model/home_cubit.dart';
import 'package:sonic_summit_mobile_app/features/splash/presentation/view_model/splash_cubit.dart';



final getIt = GetIt.instance;

Future<void> initDependencies() async {
  // First initialize hive service
  await _initHiveService();
  await _initApiService();
  await _initSharedPreferences();
  
  // Initialize Home-related dependencies
  await _initHomeDependencies();

  // Initialize Register-related dependencies
  await _initRegisterDependencies();

  // Initialize Login-related dependencies
  await _initLoginDependencies();

  // Initialize Splash Screen-related dependencies
  await _initSplashScreenDependencies();

  // Initialize Product-related dependencies
  await _initProductDependencies();
  
  await _initCartDependencies();

}

Future<void> _initSharedPreferences() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
}

_initApiService() {
  // Register the API service (Dio)
  getIt.registerLazySingleton<Dio>(
    () => ApiService(Dio()).dio,
  );
}

_initHiveService() {
  // Register Hive service
  getIt.registerLazySingleton<HiveService>(() => HiveService());
}

_initRegisterDependencies() async {
  // =========================== Data Source ===========================
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSource(getIt<HiveService>()),
  );

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(getIt<Dio>()),
  );

  // =========================== Repository ===========================
  getIt.registerLazySingleton<AuthLocalRepository>(
    () => AuthLocalRepository(getIt<AuthLocalDataSource>()),
  );
  
  getIt.registerLazySingleton<AuthRemoteRepository>(
    () => AuthRemoteRepository(getIt<AuthRemoteDataSource>()),
  );

  // =========================== Usecases ===========================
  getIt.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(getIt<AuthRemoteRepository>()),
  );

  getIt.registerLazySingleton<UploadImageUsecase>(
    () => UploadImageUsecase(getIt<AuthRemoteRepository>()),
  );

  // =========================== Bloc ===========================
  getIt.registerFactory<RegisterBloc>(
    () => RegisterBloc(registerUseCase: getIt(), uploadImageUsecase: getIt()),
  );
}

_initHomeDependencies() async {
  // Register Home-related Cubits/Bloc
  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(),
  );
}

_initLoginDependencies() async {
  getIt.registerLazySingleton<TokenSharedPrefs>(
    () => TokenSharedPrefs(getIt<SharedPreferences>()),
  );

  // =========================== Usecases ===========================
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(
      getIt<AuthRemoteRepository>(),
      getIt<TokenSharedPrefs>(),
    ),
  );

  // =========================== Bloc ===========================
  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(
      registerBloc: getIt<RegisterBloc>(),
      homeCubit: getIt<HomeCubit>(),
      loginUseCase: getIt<LoginUseCase>(),
    ),
  );
}

_initSplashScreenDependencies() async {
  // Register Splash-related Cubits
  getIt.registerFactory<SplashCubit>(
    () => SplashCubit(getIt<LoginBloc>()),
  );
}

// Product-related initialization

_initProductDependencies() async {
  // =========================== Data Source ===========================
  getIt.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSource(dio: getIt<Dio>()), // Register the remote data source for products
  );

  // =========================== Repository ===========================
  getIt.registerLazySingleton<IProductRepository>(
    () => ProductRemoteRepository(remoteDataSource: getIt<ProductRemoteDataSource>()), // Register the IProductRepository interface to the ProductRemoteRepository
  );

  // =========================== Usecases ===========================
  getIt.registerLazySingleton<GetAllProductUseCase>(
    () => GetAllProductUseCase(productRepository: getIt<IProductRepository>()), // Usecase for getting all products
  );

  // =========================== Bloc ===========================
  getIt.registerFactory<ProductBloc>(
    () => ProductBloc(getAllProductUseCase: getIt<GetAllProductUseCase>()), 
  );
}

_initCartDependencies() async {
  // =========================== Data Source ===========================
  getIt.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSource(dio: getIt<Dio>(), tokenSharedPrefs: getIt<TokenSharedPrefs>()),  // Register Cart Remote Data Source
  );

  // =========================== Repository ===========================
  getIt.registerLazySingleton<ICartRepository>(
    () => CartRemoteRepository(remoteDataSource: getIt<CartRemoteDataSource>()), // Register Cart Repository
  );

  // =========================== Usecases ===========================
  getIt.registerLazySingleton<GetCartUseCase>(
    () => GetCartUseCase(cartRepository: getIt<ICartRepository>()), // Usecase for getting the cart
  );

  // =========================== Bloc ===========================
  getIt.registerFactory<CartBloc>(
    () => CartBloc(getCartUseCase: getIt<GetCartUseCase>()), // CartBloc to manage Cart State
  );
}
