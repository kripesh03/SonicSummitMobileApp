import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sonic_summit_mobile_app/features/order/presentation/view/order_view.dart';
import 'package:sonic_summit_mobile_app/features/order/presentation/view_model/order_bloc.dart';
import 'package:sonic_summit_mobile_app/features/order/domain/entity/order_entity.dart';
import 'package:sonic_summit_mobile_app/core/common/snackbar/snackbar.dart';

class MockOrderBloc extends MockCubit<OrderState> implements OrderBloc {}

void main() {
  late MockOrderBloc mockOrderBloc;

  setUp(() {
    mockOrderBloc = MockOrderBloc();
  });

  testWidgets('displays loading state when placing order', (WidgetTester tester) async {
    final orderData = {'name': 'John Doe', 'phone': '1234567890'};
    when(() => mockOrderBloc.state).thenReturn(OrderLoading());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<OrderBloc>(
          create: (context) => mockOrderBloc,
          child: OrderView(cartItems: []),
        ),
      ),
    );

    // Verify loading indicator is shown
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('displays success message when order is placed', (WidgetTester tester) async {
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
    when(() => mockOrderBloc.state).thenReturn(OrderPlaced(order: orderEntity));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<OrderBloc>(
          create: (context) => mockOrderBloc,
          child: OrderView(cartItems: []),
        ),
      ),
    );

    // Verify order placed success message
    expect(find.text('Order placed successfully!'), findsOneWidget);
  });

  testWidgets('displays error message when order placement fails', (WidgetTester tester) async {
    final orderData = {'name': 'John Doe', 'phone': '1234567890'};
    when(() => mockOrderBloc.state).thenReturn(OrderFailure(error: 'Failed to place order'));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<OrderBloc>(
          create: (context) => mockOrderBloc,
          child: OrderView(cartItems: []),
        ),
      ),
    );

    // Verify error message is shown
    expect(find.text('Failed to place order'), findsOneWidget);
  });

}
