import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sonic_summit_mobile_app/features/browse/domain/entity/product_entity.dart';
import 'package:sonic_summit_mobile_app/features/browse/domain/use_case/get_all_product_usecase.dart';
import 'package:sonic_summit_mobile_app/features/browse/domain/use_case/get_product_by_id_usecase.dart';
import 'package:sonic_summit_mobile_app/features/browse/presentation/view_model/product_bloc.dart';
import 'package:sonic_summit_mobile_app/core/error/failure.dart';

// Mock classes for GetAllProductUseCase and GetProductByIdUseCase
class MockGetAllProductUseCase extends Mock implements GetAllProductUseCase {}

class MockGetProductByIdUseCase extends Mock implements GetProductByIdUseCase {}

void main() {
  late MockGetAllProductUseCase mockGetAllProductUseCase;
  late MockGetProductByIdUseCase mockGetProductByIdUseCase;
  late ProductBloc productBloc;

  setUp(() {
    mockGetAllProductUseCase = MockGetAllProductUseCase();
    mockGetProductByIdUseCase = MockGetProductByIdUseCase();
    productBloc = ProductBloc(
      getAllProductUseCase: mockGetAllProductUseCase,
      getProductByIdUseCase: mockGetProductByIdUseCase,
    );
  });

  tearDown(() {
    productBloc.close();
  });

  group('ProductBloc Tests', () {
    test('should emit ProductState with products when LoadProducts is added and successful', () async {
      // Arrange: Mocking the GetAllProductUseCase to return a list of products on success
      when(mockGetAllProductUseCase.call()).thenAnswer(
        (_) async => Right([
          ProductEntity(
            id: '1',
            title: 'Product 1',
            artistName: 'Artist 1',
            description: 'Description 1',
            oldPrice: 10.0,
            newPrice: 5.0,
            category: 'Category 1',
          ),
        ]),
      );

      // Act: Add the LoadProducts event to the ProductBloc
      productBloc.add(LoadProducts());

      // Assert: Check if the state changes as expected
      await expectLater(
        productBloc.stream,
        emitsInOrder([
          ProductState.initial(),
          ProductState(
            isLoading: false,
            products: [
              ProductEntity(
                id: '1',
                title: 'Product 1',
                artistName: 'Artist 1',
                description: 'Description 1',
                oldPrice: 10.0,
                newPrice: 5.0,
                category: 'Category 1',
              ),
            ],
            error: null,
            selectedProduct: null,
          ),
        ]),
      );
    });

    test('should emit ProductState with error when LoadProducts is added and fails', () async {
      // Arrange: Mocking the GetAllProductUseCase to return a failure
      when(mockGetAllProductUseCase.call()).thenAnswer(
        (_) async => Left(ApiFailure(message: 'Error fetching products')),
      );

      // Act: Add the LoadProducts event to the ProductBloc
      productBloc.add(LoadProducts());

      // Assert: Check if the state changes to error state
      await expectLater(
        productBloc.stream,
        emitsInOrder([
          ProductState.initial(),
          ProductState(
            isLoading: false,
            products: [],
            error: 'Error fetching products',
            selectedProduct: null,
          ),
        ]),
      );
    });

    
  });
}
