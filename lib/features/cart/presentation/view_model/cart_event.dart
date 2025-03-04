// cart_event.dart

part of 'cart_bloc.dart';

@immutable
sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

final class LoadCart extends CartEvent {}

final class AddToCart extends CartEvent {
  final String productId;

  const AddToCart({required this.productId});

  @override
  List<Object> get props => [productId];
}

final class DeleteFromCart extends CartEvent {
  final String productId;

  const DeleteFromCart({required this.productId});

  @override
  List<Object> get props => [productId];
}
