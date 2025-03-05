import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonic_summit_mobile_app/app/di/di.dart';
import 'package:sonic_summit_mobile_app/core/common/snackbar/snackbar.dart';
import 'package:sonic_summit_mobile_app/features/browse/presentation/view/product_view.dart';
import 'package:sonic_summit_mobile_app/features/cart/presentation/view/cart_view.dart';
import 'package:sonic_summit_mobile_app/features/browse/presentation/view_model/product_bloc.dart';
import 'package:sonic_summit_mobile_app/features/cart/presentation/view_model/cart_bloc.dart';
import 'package:sonic_summit_mobile_app/features/home/presentation/view_model/home_cubit.dart';
import 'package:sonic_summit_mobile_app/features/home/presentation/view_model/home_state.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
          return MultiBlocProvider(
            providers: [
              BlocProvider<ProductBloc>(
                create: (context) => getIt<ProductBloc>(),
              ),
              BlocProvider<CartBloc>(
                create: (context) => getIt<CartBloc>(),
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
