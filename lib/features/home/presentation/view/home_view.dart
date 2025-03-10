import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:sonic_summit_mobile_app/app/di/di.dart';
import 'package:sonic_summit_mobile_app/core/common/snackbar/snackbar.dart';
import 'package:sonic_summit_mobile_app/features/browse/presentation/view_model/product_bloc.dart';
import 'package:sonic_summit_mobile_app/features/cart/presentation/view_model/cart_bloc.dart';
import 'package:sonic_summit_mobile_app/features/home/presentation/view_model/home_cubit.dart';
import 'package:sonic_summit_mobile_app/features/home/presentation/view_model/home_state.dart';
import 'package:sonic_summit_mobile_app/features/profile/presentation/view_model/profile_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  static const double shakeThreshold = 15.0; // Adjust sensitivity
  bool _isShakeActionAllowed = true;

  @override
  void initState() {
    super.initState();
    _listenToShake();
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  void _listenToShake() {
    _accelerometerSubscription = accelerometerEvents.listen((event) {
      double acceleration =
          sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

      if (_isShakeActionAllowed && acceleration > shakeThreshold) {
        _logout();
      }
    });
  }

  void _logout() {
    _isShakeActionAllowed = false;

    showMySnackBar(
      context: context,
      message: "Shake detected! Logging out...",
      color: Colors.red,
    );

    context.read<HomeCubit>().logout(context);

    // Prevent multiple logouts within 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      _isShakeActionAllowed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/logos/logo_without_background.png', // Path to your logo image
          height: 60, // Adjust the height as needed
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.deepPurpleAccent,),
            onPressed: () {
              showMySnackBar(
                context: context,
                message: 'Logging out...',
                color: Colors.red,
              );
              context.read<HomeCubit>().logout(context);
            },
          ),
        ],
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<ProductBloc>(
                create: (context) => getIt<ProductBloc>(),
              ),
              BlocProvider<CartBloc>(
                create: (context) => getIt<CartBloc>(),
              ),
              BlocProvider<ProfileBloc>(
                create: (context) => getIt<ProfileBloc>(),
              ),
            ],
            child: state.views.elementAt(state.selectedIndex),
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_shopping_cart),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: 'Account',
              ),
            ],
            currentIndex: state.selectedIndex,
            selectedItemColor: Colors.purple,
            unselectedItemColor: Colors.blueGrey,
            backgroundColor: Colors.purple,
            onTap: (index) {
              context.read<HomeCubit>().onTabTapped(index);
            },
          );
        },
      ),
    );
  }
}