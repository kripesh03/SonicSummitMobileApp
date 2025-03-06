part of 'orders_by_user_bloc.dart';

@immutable
abstract class OrdersByUserState extends Equatable {
  const OrdersByUserState();

  @override
  List<Object> get props => [];
}

class OrdersByUserInitial extends OrdersByUserState {}

class OrdersByUserLoading extends OrdersByUserState {}

class OrdersByUserFetched extends OrdersByUserState {
  final List<OrderEntity> orders;

  const OrdersByUserFetched({required this.orders});

  @override
  List<Object> get props => [orders];
}

class OrdersByUserFailure extends OrdersByUserState {
  final String error;

  const OrdersByUserFailure({required this.error});

  @override
  List<Object> get props => [error];
}
