import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sonic_summit_mobile_app/core/error/failure.dart';
import 'package:sonic_summit_mobile_app/features/order/domain/entity/order_entity.dart';
import 'package:sonic_summit_mobile_app/features/order/domain/use_case/get_order_by_user_id_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:sonic_summit_mobile_app/features/profile/presentation/view_model/orders/orders_by_user_bloc.dart';

// Mock the GetOrdersByUserIdUseCase
class MockGetOrdersByUserIdUseCase extends Mock implements GetOrdersByUserIdUseCase {}

void main() {
  late OrdersByUserBloc ordersByUserBloc;
  late MockGetOrdersByUserIdUseCase mockGetOrdersByUserIdUseCase;

  // Set up the mock and the bloc before each test
  setUp(() {
    mockGetOrdersByUserIdUseCase = MockGetOrdersByUserIdUseCase();
    ordersByUserBloc = OrdersByUserBloc(getOrdersByUserIdUseCase: mockGetOrdersByUserIdUseCase);
  });


  // Test 2: Should emit OrdersByUserLoading and then OrdersByUserFailure when an error occurs from the use case
  

  // Test 3: Should emit OrdersByUserLoading and then OrdersByUserFailure when an exception is thrown
  test('should emit OrdersByUserLoading and then OrdersByUserFailure when an exception is thrown', () async {
    // Given: A mock userId and an exception being thrown by the use case
    final userId = 'user123';
    when(mockGetOrdersByUserIdUseCase(userId)).thenThrow(Exception('An unexpected error'));

    // Expected states
    final expectedStates = [
      OrdersByUserLoading(),
      OrdersByUserFailure(error: 'Exception: An unexpected error'),
    ];

    // When: The event is added to the bloc
    expectLater(
      ordersByUserBloc.stream,
      emitsInOrder(expectedStates),
    );

    // Add the event
    ordersByUserBloc.add(GetOrdersByUserId(userId: userId));
  });

  // Clean up the bloc after each test
  tearDown(() {
    ordersByUserBloc.close();
  });
}
