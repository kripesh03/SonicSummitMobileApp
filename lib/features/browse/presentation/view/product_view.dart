import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonic_summit_mobile_app/features/browse/presentation/view_model/product_bloc.dart';

class ProductView extends StatelessWidget {
  const ProductView({super.key});

  @override
Widget build(BuildContext context) {
  // Add this to trigger the event to load products
  WidgetsBinding.instance.addPostFrameCallback((_) {
    BlocProvider.of<ProductBloc>(context).add(LoadProducts());
  });

  return SizedBox.expand(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Product View',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.error != null) {
                return Center(
                  child: Text(
                    state.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else if (state.products.isEmpty) {
                return const Center(child: Text('No Products Available'));
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: state.products.length,
                    itemBuilder: (BuildContext context, index) {
                      return ListTile(
                        title: Text(state.products[index].title),
                        subtitle: Text(state.products[index].artistName),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    ),
  );
}
}