part of 'cart_bloc.dart';

// cart_state.dart

class CartState extends Equatable {
  final List<CartEntity> cart;
  final bool isLoading;
  final String? error;

  const CartState({
    required this.cart,
    required this.isLoading,
    this.error,
  });

  factory CartState.initial() {
    return CartState(
      cart: [], // Initialize as an empty list
      isLoading: false,
    );
  }

  CartState copyWith({
    List<CartEntity>? cart,
    bool? isLoading,
    String? error,
  }) {
    return CartState(
      cart: cart ?? this.cart,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [cart, isLoading, error ?? ''];
}
