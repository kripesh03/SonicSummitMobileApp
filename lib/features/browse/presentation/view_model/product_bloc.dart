import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:sonic_summit_mobile_app/features/browse/domain/entity/product_entity.dart';
import 'package:sonic_summit_mobile_app/features/browse/domain/use_case/get_all_product_usecase.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetAllProductUseCase _getAllProductUseCase;

  ProductBloc({
    required GetAllProductUseCase getAllProductUseCase,
  })  : _getAllProductUseCase = getAllProductUseCase,
        super(ProductState.initial()) {
    on<LoadProducts>(_onLoadProducts);
  }

  Future<void> _onLoadProducts(LoadProducts event, Emitter<ProductState> emit) async {
  debugPrint('Loading products...');
  emit(state.copyWith(isLoading: true));

  final result = await _getAllProductUseCase.call();
  result.fold(
    (failure) {
      debugPrint('Error fetching products: ${failure.message}');
      emit(state.copyWith(isLoading: false, error: failure.message));
    },
    (products) {
      debugPrint('Products fetched: ${products.length}');
      debugPrint('Loading products...');
      emit(state.copyWith(isLoading: false, products: products));
    },
  );
}
}
