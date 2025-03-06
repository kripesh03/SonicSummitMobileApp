import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart'; // For network connectivity
import 'package:sonic_summit_mobile_app/features/browse/domain/entity/product_entity.dart';
import 'package:sonic_summit_mobile_app/features/browse/domain/use_case/get_all_product_usecase.dart';
import 'package:sonic_summit_mobile_app/features/browse/domain/use_case/get_product_by_id_usecase.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetAllProductUseCase _getAllProductUseCase;
  final GetProductByIdUseCase _getProductByIdUseCase;

  ProductBloc({
    required GetAllProductUseCase getAllProductUseCase,
    required GetProductByIdUseCase getProductByIdUseCase,
  })  : _getAllProductUseCase = getAllProductUseCase,
        _getProductByIdUseCase = getProductByIdUseCase,
        super(ProductState.initial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadProductById>(_onLoadProductById);
  }

  Future<void> _onLoadProducts(LoadProducts event, Emitter<ProductState> emit) async {
    try {
      emit(state.copyWith(isLoading: true)); // Indicate loading state

      // Check for network connectivity
      bool isOnline = await _isConnectedToNetwork();

      if (isOnline) {
        // Fetch products from the API
        final result = await _getAllProductUseCase.call();
        result.fold(
          (failure) {
            debugPrint('Error fetching products from API: ${failure.message}');
            emit(state.copyWith(isLoading: false, error: failure.message));
          },
          (products) {
            debugPrint('Fetched ${products.length} products from API');
            emit(state.copyWith(isLoading: false, products: products));
          },
        );
      } else {
        // If offline, load products from local Hive database
        final products = await _getAllProductUseCase.getProductsFromLocal();
        emit(state.copyWith(isLoading: false, products: products));
        debugPrint('Loaded products from local storage');

        // Show custom no internet message
        emit(state.copyWith(
          isLoading: false,
          error: "No Internet Connection. Please connect to the Wi-Fi.",
        ));
      }
    } catch (e) {
      debugPrint('Error: $e');
      emit(state.copyWith(isLoading: false, error: "Something went wrong. Please try again."));
    }
  }

  Future<bool> _isConnectedToNetwork() async {
    try {
      final result = await Connectivity().checkConnectivity();
      return result != ConnectivityResult.none;
    } on PlatformException catch (_) {
      return false;
    }
  }

  Future<void> _onLoadProductById(LoadProductById event, Emitter<ProductState> emit) async {
    debugPrint('Loading product with ID: ${event.productId}');
    emit(state.copyWith(isLoading: true));

    final result = await _getProductByIdUseCase.call(event.productId);
    result.fold(
      (failure) {
        debugPrint('Error fetching product: ${failure.message}');
        emit(state.copyWith(isLoading: false, error: failure.message));
      },
      (product) {
        debugPrint('Product fetched: ${product.title}');
        emit(state.copyWith(isLoading: false, selectedProduct: product));
      },
    );
  }
}
