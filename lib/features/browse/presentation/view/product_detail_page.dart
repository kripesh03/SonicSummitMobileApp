import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonic_summit_mobile_app/app/constants/api_endpoints.dart';
import 'package:sonic_summit_mobile_app/features/browse/presentation/view_model/product_bloc.dart';
import 'package:sonic_summit_mobile_app/features/cart/presentation/view_model/cart_bloc.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:flutter/foundation.dart' as foundation;

class ProductDetailPage extends StatefulWidget {
  final String productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool _isNear = false;
  late StreamSubscription<dynamic> _streamSubscription;
  bool _isProximityActionAllowed = true;

  @override
  void initState() {
    super.initState();
    _listenToProximitySensor();
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
  }

  Future<void> _listenToProximitySensor() async {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (foundation.kDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      }
    };

    // Turn off the screen on proximity (Android only)
    await ProximitySensor.setProximityScreenOff(true).onError((error, stackTrace) {
      if (foundation.kDebugMode) {
        debugPrint("Could not enable screen off functionality");
      }
      return null;
    });

    // Listen to proximity sensor events
    _streamSubscription = ProximitySensor.events.listen((int event) {
      setState(() {
        _isNear = (event > 0) ? true : false;
      });

      if (_isProximityActionAllowed && _isNear) {
        // Trigger the add to cart action when proximity is detected
        _addToCart();
      }
    });
  }

  void _addToCart() {
    _isProximityActionAllowed = false;

    // Trigger the "Add to Cart" action
    final cartBloc = context.read<CartBloc>();
    final productBloc = context.read<ProductBloc>();
    final product = productBloc.state.products.firstWhere(
      (p) => p.id == widget.productId,
    );

    cartBloc.add(AddToCart(productId: product.id!));

    // Show a snackbar with the action feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Proximity detected'),
        duration: Duration(seconds: 1),
      ),
    );

    // Prevent multiple actions within 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      _isProximityActionAllowed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
      listener: (context, state) {
        if (state.isLoading) {
          // Show loading spinner when the state is loading
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Adding item to cart...'),
              duration: Duration(milliseconds: 200),
            ),
          );
        } else if (state.error != null) {
          // Check if the error is "Item is already in the cart"
          if (state.error == 'Item already in the cart') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Item already in the cart'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 2),
              ),
            );
          } else {
            // Handle other errors (e.g., Dio errors)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Item already in Cart'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 1),
              ),
            );
          }
        } else if (state.cart.isNotEmpty) {
          // Show success feedback when the item is added to the cart
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Item added to cart!'),
              duration: Duration(milliseconds: 500),
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
            (p) => p.id == widget.productId,
          );

          if (product.id == "_empty.productID") {
            return const Center(child: Text("Product not found"));
          }

          final productImageUrl = product.productImage != null
              ? '${ApiEndpoints.productimageUrl}${product.productImage}'.replaceFirst(RegExp(r'/?images'), '/images')
              : null;

          return Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image with Shadow and Rounded Corners
                  if (productImageUrl != null)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          productImageUrl,
                          height: 300,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 300,
                              color: Colors.grey[200],
                              child: const Icon(Icons.image_not_supported, size: 100, color: Colors.grey),
                            );
                          },
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                  // Product Title
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Artist Name
                  Text(
                    "Artist: ${product.artistName}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Product Description
                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.purple,// Darker text color
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Price Section
                  Row(
                    children: [
                      Text(
                        "\$${product.oldPrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.lineThrough,
                          color: Colors.purple,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "\$${product.newPrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Category and Trending Badge
                  Row(
                    children: [
                      Text(
                        "${product.category}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.purple,
                        ),
                      ),
                      if (product.trending)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "🔥 Trending",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                      ),
                      onPressed: () {
                        final cartBloc = context.read<CartBloc>();
                        cartBloc.add(AddToCart(productId: product.id!));
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_shopping_cart, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            "Add to Cart",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}