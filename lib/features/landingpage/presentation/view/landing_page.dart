import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonic_summit_mobile_app/app/constants/api_endpoints.dart';
import 'package:sonic_summit_mobile_app/app/di/di.dart';
import 'package:sonic_summit_mobile_app/features/browse/domain/use_case/get_all_product_usecase.dart';
import 'package:sonic_summit_mobile_app/features/browse/domain/use_case/get_product_by_id_usecase.dart';
import 'package:sonic_summit_mobile_app/features/browse/presentation/view/product_detail_page.dart';
import 'package:sonic_summit_mobile_app/features/browse/presentation/view_model/product_bloc.dart';
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

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  String? selectedProductId; // Variable to hold selected product ID
  bool isConnected = true;

  // Static image URLs for the slider
  final List<String> sliderImages = [
    '',
    'https://via.placeholder.com/800x400?text=Slider+2',
    'https://via.placeholder.com/800x400?text=Slider+3',
  ];

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
        selectedProductId == null ? 'Welcome to Sonic Summit' : 'Product Details',
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // White and bold text
      ),
      backgroundColor: const Color.fromARGB(255, 186, 105, 201), // Purple app bar
      leading: selectedProductId != null
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                setState(() {
                  selectedProductId = null;
                });
              },
            )
          : null,
    ),
    body: isConnected
        ? BlocProvider(
            create: (context) => ProductBloc(
              getAllProductUseCase: getIt<GetAllProductUseCase>(),
              getProductByIdUseCase: getIt<GetProductByIdUseCase>(),
            )..add(LoadProducts()),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Search Bar (just for design)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onChanged: (value) {
                        // Do nothing, just for design
                      },
                    ),
                  ),
                  Expanded(
                    child: selectedProductId == null
                        ? _buildProductList()
                        : ProductDetailPage(productId: selectedProductId!),
                  ),
                ],
              ),
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

  Widget _buildProductList() {
    return BlocBuilder<ProductBloc, ProductState>(
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

        // Filter products to show trending products
        final trendingProducts = productState.products.where((product) => product.trending == true).toList();
        final otherProducts = productState.products.where((product) => product.trending != true).toList();

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Slider
              SizedBox(
                height: 200,
                child: PageView.builder(
                  itemCount: sliderImages.length,
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        sliderImages[index],
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Trending Products Section
              if (trendingProducts.isNotEmpty) ...[
                const Text(
                  'Trending Products',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.purple),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: trendingProducts.length,
                    itemBuilder: (context, index) {
                      final product = trendingProducts[index];
                      final productImageUrl = product.productImage != null
                          ? '${ApiEndpoints.productimageUrl}${product.productImage}'
                              .replaceFirst(RegExp(r'/?images'), '/images')
                          : null;

                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            setState(() {
                              selectedProductId = product.id!;
                            });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: productImageUrl != null
                                    ? Image.network(
                                        productImageUrl,
                                        width: 150,
                                        height: 120,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Icon(Icons.image_not_supported, size: 50);
                                        },
                                      )
                                    : const Icon(Icons.image_not_supported, size: 50),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.title,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      product.description,
                                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Products You Might Like Section
              const Text(
                'Products You Might Like',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.purple),
              ),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemCount: otherProducts.length,
                itemBuilder: (context, index) {
                  final product = otherProducts[index];
                  final productImageUrl = product.productImage != null
                      ? '${ApiEndpoints.productimageUrl}${product.productImage}'
                          .replaceFirst(RegExp(r'/?images'), '/images')
                      : null;

                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        setState(() {
                          selectedProductId = product.id!;
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: productImageUrl != null
                                ? Image.network(
                                    productImageUrl,
                                    width: double.infinity,
                                    height: 120,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.image_not_supported, size: 50);
                                    },
                                  )
                                : const Icon(Icons.image_not_supported, size: 50),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.title,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  product.description,
                                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}