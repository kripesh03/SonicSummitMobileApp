part of 'product_bloc.dart';

@immutable
sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

final class LoadProducts extends ProductEvent {}

final class LoadProductById extends ProductEvent {
  final String productId;

  const LoadProductById(this.productId);

  @override
  List<Object> get props => [productId];
}
