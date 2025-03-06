import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:sonic_summit_mobile_app/features/order/domain/entity/order_entity.dart';
import 'package:sonic_summit_mobile_app/features/order/domain/use_case/get_order_by_user_id_use_case.dart';

part 'orders_by_user_event.dart';
part 'orders_by_user_state.dart';

class OrdersByUserBloc extends Bloc<OrdersByUserEvent, OrdersByUserState> {
  final GetOrdersByUserIdUseCase getOrdersByUserIdUseCase;

  OrdersByUserBloc({required this.getOrdersByUserIdUseCase})
      : super(OrdersByUserInitial()) {
    on<GetOrdersByUserId>(_onGetOrdersByUserId);
  }

  Future<void> _onGetOrdersByUserId(
    GetOrdersByUserId event, Emitter<OrdersByUserState> emit) async {
  emit(OrdersByUserLoading());
  try {
    final result = await getOrdersByUserIdUseCase(event.userId);
    result.fold(
      (failure) {
        emit(OrdersByUserFailure(error: failure.message));
      },
      (orders) {
        // Log the API response to check if orders are fetched
        print("Fetched orders: ${orders.length}");  // Log the number of orders

        // You can also log individual orders if you want to inspect them
        for (var order in orders) {
          print("Order ID: ${order.orderId}, Order Status: ${order.status}");
        }

        emit(OrdersByUserFetched(orders: orders));
      },
    );
  } catch (e) {
    emit(OrdersByUserFailure(error: e.toString()));
  }
}

}
