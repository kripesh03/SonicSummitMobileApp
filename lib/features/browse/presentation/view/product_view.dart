import 'dart:io';
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
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityListener {
  final Connectivity _connectivity = Connectivity();

  Future<bool> get isConnected async {
    final connectivityResult = await _connectivity.checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      return false; // No Wi-Fi or Mobile Data
    }

    // Check if there's actual internet access
    try {
      final lookup = await InternetAddress.lookup('google.com');
      return lookup.isNotEmpty && lookup.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false; // No internet access
    }
  }
}

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  String? selectedProductId;
  String searchQuery = '';
  String? selectedCategory;
  double priceFilter = 0.0;
  bool isConnected = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  // Method to check the connectivity
  Future<void> _checkConnectivity() async {
    final connectivityListener = ConnectivityListener();
    final connected = await connectivityListener.isConnected;
    setState(() {
      isConnected = connected;
    });
  }

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
        actions: [
          IconButton(
            icon: const Icon(Icons.remove_circle),
            onPressed: _clearFilters, // Clear filters on button press
          ),
        ],
      ),
      body: isConnected
          ? MultiBlocProvider(
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
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.signal_wifi_off, size: 50, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No internet connection. Please check your Wi-Fi or mobile data.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                ],
              ),
            ),
    );
  }

  // Function to clear all filters
  void _clearFilters() {
    setState(() {
      searchQuery = '';
      selectedCategory = null;
      priceFilter = 0.0;
    });
  }

  Widget _buildProductList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSearchBar(),
        const SizedBox(height: 16),
        _buildCategoryFilter(),
        const SizedBox(height: 16),
        _buildPriceFilter(),
        const SizedBox(height: 16),
        const Text(
          'Product List',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: BlocListener<CartBloc, CartState>(
            listener: (context, state) {
              if (state.isLoading) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Adding item to cart...'),
                    duration: Duration(milliseconds: 500),
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
                  // Handle Dio error specifically
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
                  // Show custom error message
                  return Center(
                    child: Text(
                      productState.error!,
                      style: const TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  );
                } else if (productState.products.isEmpty) {
                  return const Center(child: Text('No Products Available'));
                }

                // Filter products based on search, category, and price
                final filteredProducts = productState.products.where((product) {
                  final matchesSearchQuery = product.title
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase());
                  final matchesCategory =
                      selectedCategory == null ||
                          product.category == selectedCategory;
                  final matchesPrice = product.newPrice != null &&
                      product.newPrice! >= priceFilter;
                  return matchesSearchQuery && matchesCategory && matchesPrice;
                }).toList();

                return ListView.builder(
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    final productImageUrl = product.productImage != null
                        ? '${ApiEndpoints.productimageUrl}${product.productImage}'
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
          ),
        ),
      ],
    );
  }

  // Search Bar Widget
  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Search Products',
        border: OutlineInputBorder(),
        prefixIcon: const Icon(Icons.search),
      ),
      onChanged: (value) {
        setState(() {
          searchQuery = value;
        });
      },
    );
  }

  // Category Filter Widget
  Widget _buildCategoryFilter() {
    return DropdownButton<String>(
      hint: const Text('Select Category'),
      value: selectedCategory,
      onChanged: (value) {
        setState(() {
          selectedCategory = value;
        });
      },
      items: <String>['Album', 'EPs', 'Concert Tickets', 'Mixtape', 'Single']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  // Price Filter Widget (Low to High)
  Widget _buildPriceFilter() {
    return Row(
      children: [
        const Text('Price: '),
        Expanded(
          child: Slider(
            min: 0,
            max: 1000,
            divisions: 100,
            label: priceFilter.toStringAsFixed(0),
            value: priceFilter,
            onChanged: (value) {
              setState(() {
                priceFilter = value;
              });
            },
          ),
        ),
        Text('\$${priceFilter.toStringAsFixed(0)}'),
      ],
    );
  }
}
