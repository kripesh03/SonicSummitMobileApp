import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonic_summit_mobile_app/core/common/snackbar/snackbar.dart';
import 'package:sonic_summit_mobile_app/features/cart/domain/entity/cart_entity.dart';
import 'package:sonic_summit_mobile_app/features/order/presentation/view_model/order_bloc.dart';

class OrderView extends StatefulWidget {
  final List<CartEntity> cartItems;

  const OrderView({super.key, required this.cartItems});

  @override
  _OrderViewState createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Place Order')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter your details:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Display cart items
            ...widget.cartItems.map((cartItem) {
              return Text('Item: ${cartItem.items.join(", ")}');
            }),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            BlocConsumer<OrderBloc, OrderState>(
              listener: (context, state) {
                if (state is OrderPlaced) {
                  showMySnackBar(
                    context: context,
                    message: 'Order placed successfully!',
                    color: Colors.green,
                  );
                  Navigator.pop(context); // Go back after successful order placement
                } else if (state is OrderFailure) {
                  showMySnackBar(
                    context: context,
                    message: 'Order placed successfully!',
                    color: Colors.green,
                  );
                  Navigator.pop(context); // Go back after successful order placement
                }
              },
              builder: (context, state) {
                if (state is OrderLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ElevatedButton(
                  onPressed: () {
                    String name = _nameController.text.trim();
                    String phone = _phoneController.text.trim();

                    // Debugging - log values to the console
                    print("Name: $name");
                    print("Phone: $phone");

                    // Validate
                    if (name.isEmpty || phone.isEmpty) {
                      showMySnackBar(
                        context: context,
                        message: 'Please fill all required fields',
                        color: Colors.orange,
                      );
                      return;
                    }

                    // Create the order data map
                    Map<String, dynamic> orderData = {
                      'name': name,
                      'phone': phone,
                      // Add other necessary fields here
                    };

                    // Debugging - log the orderData map
                    print("Order Data: $orderData");

                    context.read<OrderBloc>().add(CreateOrder(orderData: orderData));
                  },
                  child: const Text('Place Order'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
