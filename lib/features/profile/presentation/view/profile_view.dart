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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final tokenSharedPrefs = getIt<TokenSharedPrefs>();
      final result = await tokenSharedPrefs.getUserId();

      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load userId: ${failure.message}')),
          );
        },
        (userId) {
          if (userId.isNotEmpty) {
            BlocProvider.of<ProfileBloc>(context).add(LoadProfile(userId: userId));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No userId found')),
            );
          }
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              const _UserProfileSection(),
              const SizedBox(height: 24),
              const _MyOrdersSection(),
            ],
          ),
        ),
      ),
    );
  }
}

// --------------------------------------
// User Profile Section
// --------------------------------------
class _UserProfileSection extends StatelessWidget {
  const _UserProfileSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
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
                    ? const Icon(Icons.person, size: 50, color: Colors.deepPurple)
                    : null,
              ),
              const SizedBox(height: 16),
              Text(
                user.username ?? 'Username not available',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Email: ${user.email ?? 'Email not available'}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Bio: ${user.bio ?? 'Bio not available'}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          );
        }
      },
    );
  }
}

// --------------------------------------
// My Orders Section
// --------------------------------------
class _MyOrdersSection extends StatefulWidget {
  const _MyOrdersSection();

  @override
  State<_MyOrdersSection> createState() => _MyOrdersSectionState();
}

class _MyOrdersSectionState extends State<_MyOrdersSection> {
  bool _showOrders = false;

  void _loadOrders() async {
    final tokenSharedPrefs = getIt<TokenSharedPrefs>();
    final result = await tokenSharedPrefs.getUserId();

    result.fold(
      (failure) {},
      (userId) {
        if (userId.isNotEmpty) {
          BlocProvider.of<OrdersByUserBloc>(context).add(GetOrdersByUserId(userId: userId));
          setState(() {
            _showOrders = true;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8, // Increased button width
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: _loadOrders,
            child: const Text(
              'My Orders',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (_showOrders) ...[
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
                return _OrdersList(orders: orders);
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ],
    );
  }
}

// --------------------------------------
// Orders List
// --------------------------------------
class _OrdersList extends StatelessWidget {
  final List<OrderEntity> orders;
  const _OrdersList({required this.orders});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];

        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            title: Text(
              'Order ID: ${order.orderId}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  'Total Amount: \$${order.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.deepPurple, fontSize: 16),
                ),
                const SizedBox(height: 8),
                const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...order.items.map((item) => Text('- ${item.productName ?? "Item name not available"}')),
              ],
            ),
          ),
        );
      },
    );
  }
}
