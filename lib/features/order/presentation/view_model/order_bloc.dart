import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart'; // Import the required classes
import 'package:sonic_summit_mobile_app/features/order/domain/use_case/create_order_use_case.dart'; // Assuming this exists
import 'package:sonic_summit_mobile_app/features/order/domain/entity/order_entity.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final CreateOrderUseCase createOrderUseCase; // Use CreateOrderUseCase

  OrderBloc({required this.createOrderUseCase}) : super(OrderInitial()) {
    on<CreateOrder>(_onCreateOrder);
  }

  Future<void> _onCreateOrder(
      CreateOrder event, Emitter<OrderState> emit) async {
    emit(OrderLoading());

    // Debugging - log the order data coming from the event
    print("Received Order Data: ${event.orderData}");

    try {
      // Use the CreateOrderUseCase to create the order
      final result = await createOrderUseCase(event.orderData);

      // Debugging - log the result of the order creation
      print("Order creation result: $result");

      result.fold(
        (failure) {
          emit(OrderFailure(error: failure.message));
          // Debugging - log the failure message
          print("Order creation failed: ${failure.message}");
        },
        (order) {
          emit(OrderPlaced(order: order)); // Assuming you have an OrderPlaced state
          // Debugging - log the order placed message
          print("Order placed successfully: ${order.toString()}");
        },
      );
    } catch (e) {
      emit(OrderFailure(error: e.toString()));
      // Debugging - log the exception message
      print("Error occurred during order creation: $e");
    }
  }
}
