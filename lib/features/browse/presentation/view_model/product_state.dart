part of 'product_bloc.dart';

class ProductState extends Equatable {
  final List<ProductEntity> products;
  final bool isLoading;
  final String? error;
  final ProductEntity? selectedProduct;

  const ProductState({
    required this.products,
    required this.isLoading,
    this.error,
    this.selectedProduct,
  });

  factory ProductState.initial() {
    return ProductState(
      products: [],
      isLoading: false,
      selectedProduct: null,
      error: null,
    );
  }

  ProductState copyWith({
    List<ProductEntity>? products,
    bool? isLoading,
    String? error,
    ProductEntity? selectedProduct,
  }) {
    return ProductState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedProduct: selectedProduct ?? this.selectedProduct,
    );
  }

  @override
  List<Object?> get props => [products, isLoading, error ?? '', selectedProduct ?? ''];
}
