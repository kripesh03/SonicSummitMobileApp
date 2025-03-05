import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonic_summit_mobile_app/app/di/di.dart';
import 'package:sonic_summit_mobile_app/features/browse/presentation/view/product_view.dart';
import 'package:sonic_summit_mobile_app/features/browse/presentation/view_model/product_bloc.dart';
import 'package:sonic_summit_mobile_app/features/cart/presentation/view/cart_view.dart';
import 'package:sonic_summit_mobile_app/features/cart/presentation/view_model/cart_bloc.dart';
import 'package:sonic_summit_mobile_app/features/landingpage/presentation/view/landing_page.dart';

class HomeState extends Equatable {
  final int selectedIndex;
  final List<Widget> views;

  const HomeState({
    required this.selectedIndex,
    required this.views,
  });

  // Initial state with LandingPage as the first screen
  static HomeState initial() {
    return HomeState(
      selectedIndex: 0,
      views: [
        const LandingPage(),
        BlocProvider<ProductBloc>(
          create: (context) => getIt<ProductBloc>(),
          child: BlocProvider<CartBloc>(
            create: (context) => getIt<CartBloc>(),
            child: ProductView(),
          ),
        ),
        BlocProvider<ProductBloc>(
          create: (context) => getIt<ProductBloc>(),
          child: BlocProvider<CartBloc>(
            create: (context) => getIt<CartBloc>(),
            child: CartView(),
          ),
        ),
        const Center(
          child: Text('Cart'),
        ),
        const Center(
          child: Text('Account'),
        ),
      ],
    );
  }

  HomeState copyWith({
    int? selectedIndex,
    List<Widget>? views,
  }) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      views: views ?? this.views,
    );
  }

  @override
  List<Object?> get props => [selectedIndex, views];
}
