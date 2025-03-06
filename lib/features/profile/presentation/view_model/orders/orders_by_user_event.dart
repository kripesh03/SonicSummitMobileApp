part of 'orders_by_user_bloc.dart';

@immutable
abstract class OrdersByUserEvent extends Equatable {
  const OrdersByUserEvent();

  @override
  List<Object> get props => [];
}

class GetOrdersByUserId extends OrdersByUserEvent {
  final String userId;

  const GetOrdersByUserId({required this.userId});

  @override
  List<Object> get props => [userId];
}
