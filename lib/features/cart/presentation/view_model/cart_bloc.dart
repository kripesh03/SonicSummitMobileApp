import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:sonic_summit_mobile_app/app/shared_prefs/token_shared_prefs.dart';
import 'package:sonic_summit_mobile_app/features/cart/data/data_source/remote_data_source/cart_remote_data_source.dart';
import 'package:sonic_summit_mobile_app/features/cart/domain/entity/cart_entity.dart';
import 'package:sonic_summit_mobile_app/features/cart/domain/use_case/get_cart_usecase.dart';

part 'cart_event.dart';
part 'cart_state.dart';
// cart_bloc.dart


class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartUseCase _getCartUseCase;
  final CartRemoteDataSource _cartRemoteDataSource;
  final TokenSharedPrefs _tokenSharedPrefs;

  CartBloc({
    required GetCartUseCase getCartUseCase,
    required CartRemoteDataSource cartRemoteDataSource,
    required TokenSharedPrefs tokenSharedPrefs,
  })  : _getCartUseCase = getCartUseCase,
        _cartRemoteDataSource = cartRemoteDataSource,
        _tokenSharedPrefs = tokenSharedPrefs,
        super(CartState.initial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<DeleteFromCart>(_onDeleteFromCart);  // New event handler for deleting items
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
      (cartList) {
        debugPrint('Cart fetched with ${cartList.length} items');
        emit(state.copyWith(isLoading: false, cart: cartList));
      },
    );
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    try {
      final userIdResult = await _tokenSharedPrefs.getUserId();
      final userId = userIdResult.fold(
        (failure) => throw Exception('Failed to retrieve userId: ${failure.message}'),
        (userId) => userId,
      );

      if (userId.isEmpty) {
        throw Exception('User ID is empty');
      }

      await _cartRemoteDataSource.addToCart(userId, event.productId);

      // Reload the cart after adding an item
      add(LoadCart());
    } catch (e) {
      debugPrint('Error adding to cart: $e');
    }
  }

Future<void> _onDeleteFromCart(DeleteFromCart event, Emitter<CartState> emit) async {
  try {
    debugPrint("Delete event received: ${event.productId}");

    final userIdResult = await _tokenSharedPrefs.getUserId();
    final userId = userIdResult.fold(
      (failure) => throw Exception('Failed to retrieve userId: ${failure.message}'),
      (userId) => userId,
    );

    if (userId.isEmpty) {
      throw Exception('User ID is empty');
    }

    await _cartRemoteDataSource.removeItemFromCart(userId, event.productId);

    // Reload the cart after removing an item
    add(LoadCart());
  } catch (e) {
    debugPrint('Error removing item from cart: $e');
  }
}

}
