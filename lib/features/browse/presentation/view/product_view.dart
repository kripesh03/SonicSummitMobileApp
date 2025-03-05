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
            child: BlocListener<CartBloc, CartState>(
          listener: (context, state) {
            if (state.isLoading) {
              // Show loading spinner when the state is loading
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Adding item to cart...'),
                  duration: Duration(seconds: 2),
                ),
              );
            } else if (state.error != null) {
              // Check if the error is "Item is already in the cart"
              if (state.error == 'Item is already in the cart') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Item already in the cart'),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 2),
                  ),
                );
              } else if (state.error != null &&
                  state.error!.contains('Dio error')) {
                // Handle Dio error specifically, without showing the full stack trace
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Item already in the cart'),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 2),
                  ),
                );
              } else {
                // Show other errors (if any)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${state.error}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            } else if (state.cart.isNotEmpty) {
              // Show success feedback when the item is added to the cart
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Item added to cart!'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
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
                          } catch (e) {
                            // Handle the general error here
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'An error occurred while adding the item to the cart'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        )),
      ],
    );
  }
}
