part of 'order_bloc.dart';

@immutable
abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderPlaced extends OrderState {
  final OrderEntity order;

  const OrderPlaced({required this.order});

  @override
  List<Object> get props => [order];
}

class OrderFailure extends OrderState {
  final String error;

  const OrderFailure({required this.error});

  @override
  List<Object> get props => [error];
}
