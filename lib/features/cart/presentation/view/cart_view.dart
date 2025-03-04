import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonic_summit_mobile_app/features/cart/presentation/view_model/cart_bloc.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    // Add this to trigger the event to load the cart
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<CartBloc>(context).add(LoadCart());
    });

    return SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Your Cart',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            BlocBuilder<CartBloc, CartState>(
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
                } else if (state.cart.isEmpty) {
                  return const Center(child: Text('No Items in Cart'));
                } else {
                  // Assuming CartEntity has a list of CartItemEntity
                  return Expanded(
                    child: ListView.builder(
                      itemCount:
                          state.cart.length, // state.cart is a List<CartEntity>
                      itemBuilder: (BuildContext context, index) {
                        final cartItem = state.cart[index];
                        // Now access the CartItemEntity properties correctly
                        return Column(
                          children: cartItem.items.map((item) {
                            return ListTile(
                              title: Text(item
                                  .title), // Assuming CartItemEntity has productId
                              subtitle: Text(
                                'Price: ${item.newPrice}', // Assuming CartItemEntity has quantity
                              ),
                              trailing: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  // Trigger the delete event with the item ID
                                  BlocProvider.of<CartBloc>(context).add(
                                      DeleteFromCart(productId: item.itemId));
                                },
                              ),
                            );
                          }).toList(),
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
