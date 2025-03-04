part of 'order_bloc.dart';

@immutable
sealed class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

final class CreateOrder extends OrderEvent {
  final Map<String, dynamic> orderData; // Store order data

  const CreateOrder({required this.orderData});

  @override
  List<Object> get props => [orderData];
}
