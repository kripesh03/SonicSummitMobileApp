import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sonic_summit_mobile_app/core/error/failure.dart';
import 'package:sonic_summit_mobile_app/features/order/presentation/view_model/order_bloc.dart';
import 'package:sonic_summit_mobile_app/features/order/domain/use_case/create_order_use_case.dart';
import 'package:sonic_summit_mobile_app/features/order/domain/entity/order_entity.dart';
import 'package:dartz/dartz.dart';

class MockCreateOrderUseCase extends Mock implements CreateOrderUseCase {}

void main() {
  late MockCreateOrderUseCase mockCreateOrderUseCase;
  late OrderBloc orderBloc;

  setUp(() {
    mockCreateOrderUseCase = MockCreateOrderUseCase();
    orderBloc = OrderBloc(createOrderUseCase: mockCreateOrderUseCase);
  });

  group('OrderBloc', () {
    test('initial state is OrderInitial', () {
      expect(orderBloc.state, OrderInitial());
    });

    test('emits [OrderLoading, OrderPlaced] when CreateOrder succeeds', () async {
      final orderData = {'name': 'John Doe', 'phone': '1234567890'};
      final orderEntity = OrderEntity(
        orderId: '12345',
        userId: 'user1',
        items: [],
        totalAmount: 100.0,
        status: 'placed',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      when(() => mockCreateOrderUseCase(orderData)).thenAnswer(
        (_) async => Right(orderEntity),
      );

      orderBloc.add(CreateOrder(orderData: orderData));

      await expectLater(
        orderBloc.stream,
        emitsInOrder([OrderLoading(), OrderPlaced(order: orderEntity)]),
      );
    });


    
  });
}
