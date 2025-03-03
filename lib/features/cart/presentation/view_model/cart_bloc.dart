import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:sonic_summit_mobile_app/features/cart/domain/entity/cart_entity.dart';
import 'package:sonic_summit_mobile_app/features/cart/domain/use_case/get_cart_usecase.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartUseCase _getCartUseCase;

  CartBloc({
    required GetCartUseCase getCartUseCase,
  })  : _getCartUseCase = getCartUseCase,
        super(CartState.initial()) {
    on<LoadCart>(_onLoadCart);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
  debugPrint('Loading cart...');
  emit(state.copyWith(isLoading: true));

  final result = await _getCartUseCase.call();
  result.fold(
    (failure) {
      debugPrint('Error fetching cart: ${failure.message}');
      emit(state.copyWith(isLoading: false, error: failure.message));
    },
    (cartList) {  // Updated to reflect list of CartEntity
      debugPrint('Cart fetched with ${cartList.length} items');
      emit(state.copyWith(isLoading: false, cart: cartList));
    },
  );
}

}
