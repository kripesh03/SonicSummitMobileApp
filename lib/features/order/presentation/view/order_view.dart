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
      appBar: AppBar(
        title: const Text('Place Order'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header section
              Text(
                'Enter your details to complete the order',
                style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
              ),
              const SizedBox(height: 16),

              // Cart details section
              Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cart Items:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ...widget.cartItems.map((cartItem) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Item: ${cartItem.items.join(", ")}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),

              // Name input field
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),

              // Phone number input field
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.phone,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),

              // Order Button
              BlocConsumer<OrderBloc, OrderState>(
                listener: (context, state) {
                  if (state is OrderPlaced) {
                    showMySnackBar(
                      context: context,
                      message: 'Order placed successfully!',
                      color: Colors.green,
                    );
                    Navigator.pop(context);
                  } else if (state is OrderFailure) {
                    showMySnackBar(
                      context: context,
                      message: 'Order placed successfullyy!',
                      color: Colors.green,
                    );
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

                      context.read<OrderBloc>().add(CreateOrder(orderData: orderData));
                    },
                    child: const Text('Place Order'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
    
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
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
