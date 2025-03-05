import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonic_summit_mobile_app/app/constants/api_endpoints.dart';
import 'package:sonic_summit_mobile_app/features/browse/presentation/view_model/product_bloc.dart';
import 'package:sonic_summit_mobile_app/features/cart/presentation/view_model/cart_bloc.dart';

class ProductDetailPage extends StatelessWidget {
  final String productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
      listener: (context, state) {
        if (state.isLoading) {
          // Show loading spinner when the state is loading
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Adding item to cart...'),
              duration: Duration(seconds: 1),
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
          } else if (state.error!.contains('Dio error')) {
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
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.error != null) {
            return Center(child: Text(state.error!, style: const TextStyle(color: Colors.red)));
          }

          final product = state.products.firstWhere(
            (p) => p.id == productId,
          );

          if (product.id == "_empty.productID") {
            return const Center(child: Text("Product not found"));
          }

          final productImageUrl = product.productImage != null
              ? '${ApiEndpoints.productimageUrl}${product.productImage}'.replaceFirst(RegExp(r'/?images'), '/images')
              : null;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (productImageUrl != null)
                  Center(
                    child: Image.network(
                      productImageUrl,
                      height: 250,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image_not_supported, size: 100);
                      },
                    ),
                  ),
                const SizedBox(height: 16),
                Text(product.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text("Artist: ${product.artistName}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Text(product.description, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text("\$${product.oldPrice.toStringAsFixed(2)}", style: const TextStyle(fontSize: 16, decoration: TextDecoration.lineThrough, color: Colors.grey)),
                    const SizedBox(width: 8),
                    Text("\$${product.newPrice.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                  ],
                ),
                const SizedBox(height: 8),
                Text("Category: ${product.category}", style: const TextStyle(fontSize: 16)),
                if (product.trending)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text("🔥 Trending", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
                  ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text("Add to Cart"),
                    onPressed: () {
                      final cartBloc = context.read<CartBloc>();
                      cartBloc.add(AddToCart(productId: product.id!));
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
