import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonic_summit_mobile_app/app/constants/api_endpoints.dart';
import 'package:sonic_summit_mobile_app/app/di/di.dart';
import 'package:sonic_summit_mobile_app/app/shared_prefs/token_shared_prefs.dart';
import 'package:sonic_summit_mobile_app/features/browse/domain/use_case/get_all_product_usecase.dart';
import 'package:sonic_summit_mobile_app/features/browse/domain/use_case/get_product_by_id_usecase.dart';
import 'package:sonic_summit_mobile_app/features/browse/presentation/view/product_detail_page.dart';
import 'package:sonic_summit_mobile_app/features/browse/presentation/view_model/product_bloc.dart';
import 'package:sonic_summit_mobile_app/features/cart/data/data_source/remote_data_source/cart_remote_data_source.dart';
import 'package:sonic_summit_mobile_app/features/cart/domain/use_case/get_cart_usecase.dart';
import 'package:sonic_summit_mobile_app/features/cart/presentation/view_model/cart_bloc.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  String? selectedProductId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            selectedProductId == null ? 'Product View' : 'Product Details'),
        leading: selectedProductId != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    selectedProductId = null;
                  });
                },
              )
            : null,
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ProductBloc(
              getAllProductUseCase: getIt<GetAllProductUseCase>(),
              getProductByIdUseCase: getIt<GetProductByIdUseCase>(),
            )..add(LoadProducts()),
          ),
          BlocProvider(
            create: (context) => CartBloc(
              getCartUseCase: getIt<GetCartUseCase>(),
              cartRemoteDataSource: getIt<CartRemoteDataSource>(),
              tokenSharedPrefs: getIt<TokenSharedPrefs>(),
            ),
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: selectedProductId == null
              ? _buildProductList()
              : ProductDetailPage(productId: selectedProductId!),
        ),
      ),
    );
  }

  Widget _buildProductList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Product List',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, productState) {
              if (productState.isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (productState.error != null) {
                return Center(
                  child: Text(
                    productState.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else if (productState.products.isEmpty) {
                return const Center(child: Text('No Products Available'));
              }

              return ListView.builder(
                itemCount: productState.products.length,
                itemBuilder: (context, index) {
                  final product = productState.products[index];
                  final productImageUrl = product.productImage != null
                      ? '${ApiEndpoints.productimageUrl}${product.productImage}'
                          .replaceFirst(RegExp(r'/?images'), '/images')
                      : null;

                  return ListTile(
                    leading: productImageUrl != null
                        ? Image.network(
                            productImageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image_not_supported);
                            },
                          )
                        : const Icon(Icons.image_not_supported),
                    title: Text(product.title),
                    subtitle: Text(product.description),
                    onTap: () {
                      setState(() {
                        selectedProductId = product.id!;
                      });
                    },
                    trailing: SizedBox(
                      width: 50,
                      child: IconButton(
                        icon: const Icon(Icons.add_shopping_cart),
                        onPressed: () async {
                          if (product.id == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Product ID is missing!'),
                              ),
                            );
                            return;
                          }

                          try {
                            final cartBloc = context.read<CartBloc>();
                            cartBloc.add(AddToCart(productId: product.id!));

                            // Show feedback that the product has been added
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('${product.title} added to cart!'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          } catch (e) {
                            if (e is DioException && e.response != null) {
                              final errorMessage =
                                  e.response?.data['message'] ??
                                      'An error occurred';
                              if (errorMessage == 'Item already in cart') {
                                // Show a snackbar indicating the item is already in the cart
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Item already in cart'),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $errorMessage'),
                                    backgroundColor: Colors.red,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            } else {
                              // General error handling
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'An error occurred while adding the item to the cart'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
