import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
import 'package:sonic_summit_mobile_app/features/browse/data/data_source/local_data_source/product_local_data_source.dart';
import 'package:sonic_summit_mobile_app/features/browse/data/data_source/remote_data_source/product_remote_data_source.dart';
import 'package:sonic_summit_mobile_app/features/browse/data/model/product_hive_model.dart';
import 'package:sonic_summit_mobile_app/features/browse/data/repository/product_remote_repository.dart';
import 'package:sonic_summit_mobile_app/features/browse/domain/repository/product_repository.dart';
import 'package:sonic_summit_mobile_app/features/browse/domain/use_case/get_all_product_usecase.dart';
import 'package:sonic_summit_mobile_app/features/browse/domain/use_case/get_product_by_id_usecase.dart';
import 'package:sonic_summit_mobile_app/features/browse/presentation/view_model/product_bloc.dart';
import 'package:sonic_summit_mobile_app/features/cart/data/data_source/remote_data_source/cart_remote_data_source.dart';
import 'package:sonic_summit_mobile_app/features/cart/data/repository/cart_remote_repository.dart';
import 'package:sonic_summit_mobile_app/features/cart/domain/repository/cart_repository.dart';
import 'package:sonic_summit_mobile_app/features/cart/domain/use_case/delete_cart_item_usecase.dart';
import 'package:sonic_summit_mobile_app/features/cart/domain/use_case/get_cart_usecase.dart';
import 'package:sonic_summit_mobile_app/features/cart/presentation/view_model/cart_bloc.dart';
import 'package:sonic_summit_mobile_app/features/home/presentation/view_model/home_cubit.dart';
import 'package:sonic_summit_mobile_app/features/order/data/data_source/remote_data_source/order_remote_data_source.dart';
import 'package:sonic_summit_mobile_app/features/order/data/repository/order_remote_repository.dart';
import 'package:sonic_summit_mobile_app/features/order/domain/repository/order_repository.dart';
import 'package:sonic_summit_mobile_app/features/order/domain/use_case/create_order_use_case.dart';
import 'package:sonic_summit_mobile_app/features/order/domain/use_case/get_order_by_user_id_use_case.dart';
import 'package:sonic_summit_mobile_app/features/order/presentation/view_model/order_bloc.dart';
import 'package:sonic_summit_mobile_app/features/profile/data/data_source/remote_data_source/user_remote_data_source.dart';
import 'package:sonic_summit_mobile_app/features/profile/data/repository/user_remote_repository.dart';
import 'package:sonic_summit_mobile_app/features/profile/domain/repository/user_repository.dart';
import 'package:sonic_summit_mobile_app/features/profile/domain/use_case/get_user_usecase.dart';
import 'package:sonic_summit_mobile_app/features/profile/presentation/view_model/orders/orders_by_user_bloc.dart';
import 'package:sonic_summit_mobile_app/features/profile/presentation/view_model/profile_bloc.dart';
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

  await _initOrderDependencies();

  await _initProfileDependencies();

  await _initOrdersByUserDependencies();

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
    Hive.registerAdapter(ProductHiveModelAdapter());
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
    () => ProductRemoteDataSource(
      dio: getIt<Dio>(), // Register the Dio instance for API calls
      hiveService: getIt<HiveService>(), // Register the HiveService for local storage
    ),
  );

  getIt.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSource(hiveService: getIt<HiveService>()),
  );



  // =========================== Repository ===========================
  getIt.registerLazySingleton<IProductRepository>(
    () => ProductRemoteRepository(
        remoteDataSource: getIt<ProductRemoteDataSource>()), // Register the IProductRepository interface to the ProductRemoteRepository
  );

  // =========================== Usecases ===========================
  getIt.registerLazySingleton<GetAllProductUseCase>(
    () => GetAllProductUseCase(
      productRepository: getIt<IProductRepository>(),
      productLocalDataSource: getIt<ProductLocalDataSource>(), // Inject the local data source
    ),
  );


  // Register GetProductByIdUseCase
  getIt.registerLazySingleton<GetProductByIdUseCase>(
    () => GetProductByIdUseCase(
        productRepository: getIt<IProductRepository>()), // Usecase for getting product by ID
  );

  // =========================== Bloc ===========================
  getIt.registerFactory<ProductBloc>(
    () => ProductBloc(
      getAllProductUseCase: getIt(),
      getProductByIdUseCase: getIt(),
    ),
  );

  getIt.registerLazySingleton<ProductHiveModelAdapter>(
    () => ProductHiveModelAdapter(), // Initialize and register the product adapter
  );

}
_initCartDependencies() async {
  // =========================== Data Source ===========================
  getIt.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSource(
        dio: getIt<Dio>(),
        tokenSharedPrefs:
            getIt<TokenSharedPrefs>()), // Register Cart Remote Data Source
  );

  // =========================== Repository ===========================
  getIt.registerLazySingleton<ICartRepository>(
    () => CartRemoteRepository(
      remoteDataSource: getIt<CartRemoteDataSource>(),
      tokenSharedPrefs:
          getIt<TokenSharedPrefs>(), // Register TokenSharedPrefs as well
    ),
  );

  // =========================== Usecases ===========================
  getIt.registerLazySingleton<GetCartUseCase>(
    () => GetCartUseCase(
        cartRepository:
            getIt<ICartRepository>()), // Usecase for getting the cart
  );

  // Register DeleteCartItemUseCase
  getIt.registerLazySingleton<DeleteCartItemUseCase>(
    () => DeleteCartItemUseCase(
        cartRepository:
            getIt<ICartRepository>()), // Usecase for deleting cart items
  );

  // =========================== Bloc ===========================
  getIt.registerFactory<CartBloc>(
    () => CartBloc(
      getCartUseCase: getIt<GetCartUseCase>(), // Register GetCartUseCase
      cartRemoteDataSource:
          getIt<CartRemoteDataSource>(), // Register CartRemoteDataSource
      tokenSharedPrefs: getIt<TokenSharedPrefs>(), // Register TokenSharedPrefs
    ),
  );
}

_initOrderDependencies() async {
  // =========================== Data Source ===========================
  getIt.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSource(
      dio: getIt<Dio>(),
      tokenSharedPrefs: getIt<TokenSharedPrefs>(), // Inject TokenSharedPrefs
    ),
  );

  // =========================== Repository ===========================
  getIt.registerLazySingleton<IOrderRepository>(
    () => OrderRemoteRepository(
      remoteDataSource:
          getIt<OrderRemoteDataSource>(), // Inject OrderRemoteDataSource
      tokenSharedPrefs: getIt<TokenSharedPrefs>(), // Inject TokenSharedPrefs
    ),
  );

  // =========================== Usecases ===========================
  getIt.registerLazySingleton<CreateOrderUseCase>(
    () => CreateOrderUseCase(
        orderRepository:
            getIt<IOrderRepository>()), // Usecase for placing an order
  );

  // =========================== Bloc ===========================
  getIt.registerFactory<OrderBloc>(
    () => OrderBloc(
        createOrderUseCase: getIt<
            CreateOrderUseCase>()), // Register OrderBloc with CreateOrderUseCase
  );
}


_initProfileDependencies() async {
  // =========================== Data Source ===========================
  getIt.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSource(
      dio: getIt<Dio>(),
      tokenSharedPrefs: getIt<TokenSharedPrefs>(),
    ),
  );

  // =========================== Repository ===========================
  getIt.registerLazySingleton<IUserRepository>(
    () => UserRemoteRepository(
      remoteDataSource: getIt<UserRemoteDataSource>(),
      tokenSharedPrefs: getIt<TokenSharedPrefs>(),
    ),
  );

  // =========================== Usecases ===========================
  getIt.registerLazySingleton<GetUserUseCase>(
    () => GetUserUseCase(
      userRepository: getIt<IUserRepository>(),
    ),
  );

  // =========================== Bloc ===========================
  getIt.registerFactory<ProfileBloc>(
    () => ProfileBloc(getUserUseCase: getIt<GetUserUseCase>()),
  );
}


_initOrdersByUserDependencies() async {

  // =========================== Usecases ===========================
  getIt.registerLazySingleton<GetOrdersByUserIdUseCase>(
    () => GetOrdersByUserIdUseCase(
      orderRepository: getIt<IOrderRepository>(),
    ),
  );

  // =========================== Bloc ===========================
  getIt.registerFactory<OrdersByUserBloc>(
    () => OrdersByUserBloc(getOrdersByUserIdUseCase: getIt<GetOrdersByUserIdUseCase>()),
  );
}


