import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonic_summit_mobile_app/app/di/di.dart';
import 'package:sonic_summit_mobile_app/app/shared_prefs/token_shared_prefs.dart';
import 'package:sonic_summit_mobile_app/features/profile/presentation/view_model/orders/orders_by_user_bloc.dart';
import 'package:sonic_summit_mobile_app/features/profile/presentation/view_model/profile_bloc.dart';
import 'package:sonic_summit_mobile_app/features/profile/presentation/view_model/profile_state.dart';

import 'package:sonic_summit_mobile_app/features/order/domain/entity/order_entity.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger the event to load the user profile after fetching the userId
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Fetch userId from SharedPreferences
      final tokenSharedPrefs = getIt<TokenSharedPrefs>();
      final result = await tokenSharedPrefs.getUserId();

      result.fold(
        (failure) {
          // Handle failure (e.g., show an error message)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load userId: ${failure.message}')),
          );
        },
        (userId) {
          if (userId.isNotEmpty) {
            // If userId is retrieved successfully, trigger the event to load the profile
            BlocProvider.of<ProfileBloc>(context).add(LoadProfile(userId: userId));
          } else {
            // Handle case where userId is not found
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No userId found')),
            );
          }
        },
      );
    });

    return SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Your Profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.error.isNotEmpty) {
                    return Center(child: Text('Error: ${state.error}'));
                  } else if (state.user == null) {
                    return const Center(child: Text('No Profile Found'));
                  } else {
                    final user = state.user!;
                    final profileImageUrl = user.profilePicture != null &&
                            user.profilePicture!.isNotEmpty
                        ? 'http://10.0.2.2:3000/images/${user.profilePicture}'
                        : null;

                    return Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: profileImageUrl != null
                              ? NetworkImage(profileImageUrl)
                              : null,
                          child: profileImageUrl == null
                              ? const Icon(Icons.person, size: 50)
                              : null,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user.username ?? 'Username not available',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text('Email: ${user.email ?? 'Email not available'}'),
                        const SizedBox(height: 8),
                        Text('Bio: ${user.bio ?? 'Bio not available'}'),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Fetch userId and trigger the GetOrdersByUserId event
                  final tokenSharedPrefs = getIt<TokenSharedPrefs>();
                  tokenSharedPrefs.getUserId().then((result) {
                    result.fold(
                      (failure) {},
                      (userId) {
                        if (userId.isNotEmpty) {
                          BlocProvider.of<OrdersByUserBloc>(context)
                              .add(GetOrdersByUserId(userId: userId));
                        }
                      },
                    );
                  });
                },
                child: const Text('My Orders'),
              ),
              const SizedBox(height: 20),
              BlocBuilder<OrdersByUserBloc, OrdersByUserState>(
  builder: (context, state) {
    if (state is OrdersByUserLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is OrdersByUserFailure) {
      return Center(child: Text('Error: ${state.error}'));
    } else if (state is OrdersByUserFetched) {
      final orders = state.orders;
      if (orders.isEmpty) {
        return const Center(child: Text('No orders found.'));
      }
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          OrderEntity order = orders[index];
          final totalAmount = order.totalAmount; // Assuming this is a double field
          final items = order.items; // Assuming this is a List of items

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order ID: ${order.orderId}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Total Amount: \$${totalAmount.toStringAsFixed(2)}'), // Display total amount
                  const SizedBox(height: 8),
                  Text('Items:'),
                  // Display list of items
                  for (var item in items) 
                    Text('- ${item.productName ?? "Item name not available"}'), // Assuming each item has a 'name' field
                ],
              ),
            ),
          );
        },
      );
    }
    return const SizedBox.shrink();
  },
)

            ],
          ),
        ),
      ),
    );
  }
}
