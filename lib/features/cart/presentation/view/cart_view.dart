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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<CartBloc>(context).add(LoadCart());
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator(color: Colors.deepPurple));
                  } else if (state.cart.isEmpty) {
                    return _buildEmptyCart();
                  } else {
                    return _buildCartList(state);
                  }
                },
              ),
            ),
            _buildTotalPrice(context),
            _buildCheckoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.remove_shopping_cart, size: 80, color: Colors.grey),
        SizedBox(height: 16),
        Text(
          'No Items in Cart Currently',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildCartList(CartState state) {
    return ListView.builder(
      itemCount: state.cart.length,
      itemBuilder: (context, index) {
        final cartEntity = state.cart[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: cartEntity.items.map((item) {
              return ListTile(
                title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Price: Rs. ${item.newPrice}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    BlocProvider.of<CartBloc>(context).add(
                        DeleteFromCart(productId: item.itemId));
                  },
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildTotalPrice(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state.cart.isEmpty) {
          return const SizedBox.shrink();
        }
        double totalPrice = state.cart.fold(0, (sum, cartEntity) => sum + cartEntity.totalPrice);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            'Total: Rs. ${totalPrice.toStringAsFixed(2)}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple),
          ),
        );
      },
    );
  }

  Widget _buildCheckoutButton(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state.cart.isEmpty) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () {
              final cartItems = context.read<CartBloc>().state.cart;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return BlocProvider<OrderBloc>(
                      create: (context) => getIt<OrderBloc>(),
                      child: OrderView(cartItems: cartItems),
                    );
                  },
                ),
              );
            },
            child: const Text('Checkout', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        );
      },
    );
  }
}
