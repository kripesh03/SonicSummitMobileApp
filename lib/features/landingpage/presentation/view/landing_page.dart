import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonic_summit_mobile_app/app/constants/api_endpoints.dart';
import 'package:sonic_summit_mobile_app/app/di/di.dart';
import 'package:sonic_summit_mobile_app/features/browse/domain/use_case/get_all_product_usecase.dart';
import 'package:sonic_summit_mobile_app/features/browse/domain/use_case/get_product_by_id_usecase.dart';
import 'package:sonic_summit_mobile_app/features/browse/presentation/view/product_detail_page.dart';
import 'package:sonic_summit_mobile_app/features/browse/presentation/view_model/product_bloc.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  String? selectedProductId; // Variable to hold selected product ID

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            selectedProductId == null ? 'Landing Page' : 'Product Details'),
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
      body: BlocProvider(
        create: (context) => ProductBloc(
          getAllProductUseCase: getIt<GetAllProductUseCase>(),
          getProductByIdUseCase: getIt<GetProductByIdUseCase>(),
        )..add(LoadProducts()),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: selectedProductId == null
              ? _buildProductList()
              : ProductDetailPage(productId: selectedProductId!),
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

        return Column(
          children: [
            // Trending Products Section
            if (trendingProducts.isNotEmpty) ...[
              const Text(
                'Trending Products',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: trendingProducts.length,
                itemBuilder: (context, index) {
                  final product = trendingProducts[index];
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
                        selectedProductId = product.id!; // Set the selected product ID
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 20), // Add space between sections
            ],

            // Other Products Section
            const Text(
              'Other Products',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: otherProducts.length,
              itemBuilder: (context, index) {
                final product = otherProducts[index];
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
                      selectedProductId = product.id!; // Set the selected product ID
                    });
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
