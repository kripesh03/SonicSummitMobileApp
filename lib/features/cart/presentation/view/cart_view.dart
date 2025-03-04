import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonic_summit_mobile_app/app/di/di.dart';
import 'package:sonic_summit_mobile_app/features/cart/presentation/view_model/cart_bloc.dart';
import 'package:sonic_summit_mobile_app/features/order/presentation/view/order_view.dart';
import 'package:sonic_summit_mobile_app/features/order/presentation/view_model/order_bloc.dart';

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
                  return Expanded(
                    child: ListView.builder(
                      itemCount: state.cart.length,
                      itemBuilder: (BuildContext context, index) {
                        final cartItem = state.cart[index];
                        return Column(
                          children: cartItem.items.map((item) {
                            return ListTile(
                              title: Text(item.title),
                              subtitle: Text('Price: ${item.newPrice}'),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final cartItems = context.read<CartBloc>().state.cart;
                // Pass the cartItems to the OrderView
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return BlocProvider<OrderBloc>(
                        create: (context) => getIt<OrderBloc>(),
                        child: OrderView(cartItems: cartItems), // Pass cartItems here
                      );
                    },
                  ),
                );
              },
              child: const Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}
