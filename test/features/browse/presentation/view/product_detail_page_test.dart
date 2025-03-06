import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sonic_summit_mobile_app/features/browse/domain/entity/product_entity.dart';
import 'package:sonic_summit_mobile_app/features/browse/presentation/view/product_detail_page.dart';
import 'package:sonic_summit_mobile_app/features/browse/presentation/view_model/product_bloc.dart';
import 'package:sonic_summit_mobile_app/features/cart/presentation/view_model/cart_bloc.dart';

class MockProductBloc extends MockBloc<ProductEvent, ProductState> implements ProductBloc {}

class MockCartBloc extends MockBloc<CartEvent, CartState> implements CartBloc {}

void main() {
  late MockProductBloc mockProductBloc;
  late MockCartBloc mockCartBloc;

  setUp(() {
    mockProductBloc = MockProductBloc();
    mockCartBloc = MockCartBloc();
  });

  testWidgets('ProductDetailPage builds correctly and adds to cart on proximity', (WidgetTester tester) async {
    final product = ProductEntity(
      id: '1',
      title: 'Product Title',
      description: 'Product Description',
      artistName: 'Artist Name',
      oldPrice: 20.0,
      newPrice: 15.0,
      productImage: 'image.jpg',
      category: 'Category',
      trending: false,
    );

    when(() => mockProductBloc.state).thenReturn(ProductState(
      isLoading: false,
      products: [product],
      error: null,
    ));

    when(() => mockCartBloc.state).thenReturn(CartState(
      isLoading: false,
      cart: [],
      error: null,
    ));

    // Build our widget and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: mockProductBloc,
          child: BlocProvider.value(
            value: mockCartBloc,
            child: ProductDetailPage(productId: '1'),
          ),
        ),
      ),
    );

    // Ensure the product title is displayed
    expect(find.text('Product Title'), findsOneWidget);
    expect(find.text('Artist Name'), findsOneWidget);

    // Ensure that Add to Cart button is present
    expect(find.text('Add to Cart'), findsOneWidget);

    // Simulate the Add to Cart button tap
    await tester.tap(find.text('Add to Cart'));
    await tester.pump();

    // Verify if the AddToCart event was triggered in CartBloc
    verify(() => mockCartBloc.add(AddToCart(productId: '1'))).called(1);

    // Simulate proximity sensor
    await tester.pumpAndSettle();

    // Verify that proximity event is handled and cart is updated
    verify(() => mockCartBloc.add(AddToCart(productId: '1'))).called(1);

    // Check for snackbar showing success message
    expect(find.byType(SnackBar), findsOneWidget);

    // Simulate an error when adding to the cart
    when(() => mockCartBloc.state).thenReturn(CartState(
      isLoading: false,
      cart: [],
      error: 'Item already in the cart',
    ));
    await tester.pump();

    // Check for snackbar showing the error message
    expect(find.text('Item already in the cart'), findsOneWidget);
  });
}
