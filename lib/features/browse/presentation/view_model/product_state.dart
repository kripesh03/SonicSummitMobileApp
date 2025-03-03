part of 'product_bloc.dart';

class ProductState extends Equatable {
  final List<ProductEntity> products;
  final bool isLoading;
  final String? error;

  const ProductState({
    required this.products,
    required this.isLoading,
    this.error,
  });

  factory ProductState.initial() {
    return ProductState(
      products: [],
      isLoading: false,
    );
  }

  ProductState copyWith({
    List<ProductEntity>? products,
    bool? isLoading,
    String? error,
  }) {
    return ProductState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [products, isLoading, error ?? ''];
}
