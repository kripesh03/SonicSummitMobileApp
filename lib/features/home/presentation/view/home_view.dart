import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:sonic_summit_mobile_app/core/common/snackbar/snackbar.dart';
import 'package:sonic_summit_mobile_app/features/home/presentation/view_model/home_cubit.dart';
import 'package:sonic_summit_mobile_app/features/home/presentation/view_model/home_state.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  static const double tiltThreshold = 5.0; // Adjusted for sensitivity
  bool _isTiltActionAllowed = true;

  @override
  void initState() {
    super.initState();
    _listenToTilt();
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  void _listenToTilt() {
    _accelerometerSubscription = accelerometerEventStream().listen((event) {
      if (_isTiltActionAllowed) {
        if (event.x < -tiltThreshold) {
          _logout("left");
        } else if (event.x > tiltThreshold) {
          _logout("right");
        }
      }
    });
  }

  void _logout(String direction) {
    _isTiltActionAllowed = false;

    showMySnackBar(
      context: context,
      message: "Tilt detected ($direction)! Logging out...",
      color: Colors.red,
    );

    context.read<HomeCubit>().logout(context);

    // Prevent multiple logouts in a short time
    Future.delayed(const Duration(seconds: 2), () {
      _isTiltActionAllowed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
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
          return state.views.elementAt(state.selectedIndex);
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
                icon: Icon(Icons.group),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: 'Account',
              ),
            ],
            currentIndex: state.selectedIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
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
