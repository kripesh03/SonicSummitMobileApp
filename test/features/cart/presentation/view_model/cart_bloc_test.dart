import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sonic_summit_mobile_app/features/cart/data/data_source/remote_data_source/cart_remote_data_source.dart';
import 'package:sonic_summit_mobile_app/features/cart/domain/entity/cart_entity.dart';
import 'package:sonic_summit_mobile_app/features/cart/domain/entity/cart_item_entity.dart'; // Import CartItemEntity
import 'package:sonic_summit_mobile_app/features/cart/domain/use_case/get_cart_usecase.dart';
import 'package:sonic_summit_mobile_app/features/cart/presentation/view_model/cart_bloc.dart';
import 'package:sonic_summit_mobile_app/core/error/failure.dart';
import 'package:sonic_summit_mobile_app/app/shared_prefs/token_shared_prefs.dart';

// Mock the necessary classes
class MockGetCartUseCase extends Mock implements GetCartUseCase {}

class MockCartRemoteDataSource extends Mock implements CartRemoteDataSource {}

class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}

class MockFailure extends Mock implements Failure {}

void main() {
  late CartBloc cartBloc;
  late MockGetCartUseCase mockGetCartUseCase;
  late MockCartRemoteDataSource mockCartRemoteDataSource;
  late MockTokenSharedPrefs mockTokenSharedPrefs;

  setUp(() {
    mockGetCartUseCase = MockGetCartUseCase();
    mockCartRemoteDataSource = MockCartRemoteDataSource();
    mockTokenSharedPrefs = MockTokenSharedPrefs();

    cartBloc = CartBloc(
      getCartUseCase: mockGetCartUseCase,
      cartRemoteDataSource: mockCartRemoteDataSource,
      tokenSharedPrefs: mockTokenSharedPrefs,
    );
  });

  tearDown(() {
    cartBloc.close();
  });

  group('CartBloc', () {
    test('initial state should be CartState.initial()', () {
      expect(cartBloc.state, CartState.initial());
    });

    

    blocTest<CartBloc, CartState>(
      'emits [CartState(isLoading: false, cart: [CartEntity()])] when LoadCart is successful',
      build: () {
        // Create a sample list of CartItemEntity
        List<CartItemEntity> cartItems = [
          CartItemEntity(itemId: '1', title: 'Item 1', newPrice: 100.0),
          CartItemEntity(itemId: '2', title: 'Item 2', newPrice: 150.0),
        ];

        // Update the CartEntity to pass the items
        when(() => mockGetCartUseCase.call()).thenAnswer(
          (_) async => Right([CartEntity(items: cartItems)]),
        );
        return cartBloc;
      },
      act: (bloc) => bloc.add(LoadCart()),
      expect: () => [
        CartState(isLoading: true, cart: [], error: null),
        CartState(isLoading: false, cart: [
          CartEntity(items: [
            CartItemEntity(itemId: '1', title: 'Item 1', newPrice: 100.0),
            CartItemEntity(itemId: '2', title: 'Item 2', newPrice: 150.0),
          ])
        ], error: null),
      ],
    );

    

    
    blocTest<CartBloc, CartState>(
      'emits [CartState(isLoading: false, error: "Item is already in the cart")] when AddToCart fails because the item is already in the cart',
      build: () {
        when(() => mockCartRemoteDataSource.isItemInCart(any(), any())).thenAnswer(
          (_) async => true,
        );
        return cartBloc;
      },
      act: (bloc) => bloc.add(AddToCart(productId: 'product123')),
      expect: () => [
        CartState(isLoading: true, cart: [], error: null),
        CartState(isLoading: false, cart: [], error: 'Item is already in the cart'),
      ],
    );

  

    
  });
}
