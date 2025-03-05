import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:sonic_summit_mobile_app/features/browse/domain/entity/product_entity.dart';
import 'package:sonic_summit_mobile_app/features/browse/domain/use_case/get_all_product_usecase.dart';
import 'package:sonic_summit_mobile_app/features/browse/domain/use_case/get_product_by_id_usecase.dart';  // Import the use case

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
    on<LoadProductById>(_onLoadProductById); // Ensure the handler is registered here
  }

  Future<void> _onLoadProducts(LoadProducts event, Emitter<ProductState> emit) async {
  try {
    emit(state.copyWith(isLoading: true)); // Indicate loading state

    final result = await _getAllProductUseCase.call(); // Call the use case

    result.fold(
      (failure) {
        debugPrint('Error fetching products: ${failure.message}');
        emit(state.copyWith(isLoading: false, error: failure.message)); // Emit error state
      },
      (products) {
        debugPrint('Fetched ${products.length} products');
        emit(state.copyWith(isLoading: false, products: products)); // Emit state with products
      },
    );
  } catch (e) {
    debugPrint('Error: $e');
    emit(state.copyWith(isLoading: false, error: e.toString())); // Emit error state
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
