import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sonic_summit_mobile_app/features/cart/presentation/view/cart_view.dart';
import 'package:sonic_summit_mobile_app/features/cart/presentation/view_model/cart_bloc.dart';

// Mock class for CartBloc
class MockCartBloc extends Mock implements CartBloc {}

void main() {
  late MockCartBloc mockCartBloc;

  setUp(() {
    mockCartBloc = MockCartBloc();
  });

  testWidgets('CartView shows empty message when cart is empty', (WidgetTester tester) async {
    // Arrange: Mocking CartBloc's state for an empty cart
    when(mockCartBloc.state).thenReturn(CartState(
      isLoading: false,
      cart: [],
      error: '', // Add any other fields that your CartState might have
    ));

    // Act: Build the CartView widget
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<CartBloc>(
          create: (_) => mockCartBloc,
          child: const CartView(),
        ),
      ),
    );

    // Assert: Check if "No Items in Cart Currently" message is displayed
    expect(find.text('No Items in Cart Currently'), findsOneWidget);
    expect(find.byIcon(Icons.remove_shopping_cart), findsOneWidget);
  });

  // Other tests...
}
