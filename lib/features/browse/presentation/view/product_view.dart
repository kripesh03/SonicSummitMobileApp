import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonic_summit_mobile_app/features/browse/presentation/view_model/product_bloc.dart';
import 'package:sonic_summit_mobile_app/features/cart/presentation/view_model/cart_bloc.dart';

class ProductView extends StatelessWidget {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure products are loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductBloc>().add(LoadProducts());
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Product View')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
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

                      return ListTile(
                        title: Text(product.title),
                        subtitle: Text(product.artistName),
                        trailing: SizedBox(
                          width: 50, // Constrain trailing widget width
                          child: IconButton(
                            icon: const Icon(Icons.add_shopping_cart),
                            onPressed: () {
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
                                debugPrint('Added to cart: ${product.id}');
                              } catch (e) {
                                debugPrint('Error: CartBloc not found in context');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('CartBloc not found!'),
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
            ),
          ],
        ),
      ),
    );
  }
}
