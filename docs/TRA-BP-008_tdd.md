# TRA-BP-008: Test-Driven Development (TDD)

## Technical Sheet

| Field | Value |
|-------|-------|
| **Code** | TRA-BP-008 |
| **Type** | Best Practice |
| **Description** | Test-Driven Development |
| **Associated Quality Attribute** | Quality |
| **Technology** | FrontEnd, BackEnd, Mobile |
| **Responsible** | FrontEnd, BackEnd, Mobile |
| **Capability** | Cross-functional |

---

## 1. Why (Business Justification)

### Business Rationale

> - Reduces errors and improves user experience.
> - Problems are identified in early stages, allowing faster and more economical solutions.
> - Accelerates the implementation process, reducing time and costs.
> - Reduces maintenance, updates, and adaptation costs as the business evolves.

### Business Impact

| Metric | Without TDD | With TDD |
|--------|-------------|----------|
| Bug rate in production | High | 40-80% lower |
| Regression rate | High | Minimal |
| Refactoring confidence | Low | High |
| Documentation accuracy | Often outdated | Always current (tests) |
| Long-term velocity | Decreasing | Sustained |

---

## 2. What (Technical Objective)

### Technical Goal

> Improve code quality by creating tests before writing the implementation code.

### TDD Cycle: Red-Green-Refactor

```
┌─────────────────────────────────────────────────────────────┐
│                                                              │
│    ┌─────────┐         ┌─────────┐         ┌──────────┐    │
│    │  RED    │ ──────▶ │  GREEN  │ ──────▶ │ REFACTOR │    │
│    │         │         │         │         │          │    │
│    │ Write   │         │ Write   │         │ Improve  │    │
│    │ failing │         │ minimal │         │ code     │    │
│    │ test    │         │ code to │         │ quality  │    │
│    │         │         │ pass    │         │          │    │
│    └─────────┘         └─────────┘         └──────────┘    │
│         ▲                                        │          │
│         │                                        │          │
│         └────────────────────────────────────────┘          │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. How (Implementation Strategy)

### Approach

```
- Follow TDD cycle: Red-Green-Refactor
- Write test BEFORE implementing functionality
```

### TDD in Flutter

#### 1. RED: Write Failing Test First
```dart
// test/features/cart/domain/usecases/add_to_cart_usecase_test.dart

void main() {
  late AddToCartUseCase useCase;
  late MockCartRepository mockRepository;

  setUp(() {
    mockRepository = MockCartRepository();
    useCase = AddToCartUseCase(repository: mockRepository);
  });

  group('AddToCartUseCase', () {
    final tProduct = Product(id: '1', name: 'Test', price: 10.0);

    test('should add product to cart via repository', () async {
      // Arrange
      when(() => mockRepository.addToCart(tProduct, 1))
          .thenAnswer((_) async => const Right(unit));

      // Act
      final result = await useCase(tProduct, quantity: 1);

      // Assert
      expect(result, const Right(unit));
      verify(() => mockRepository.addToCart(tProduct, 1)).called(1);
    });

    test('should return failure when repository fails', () async {
      // Arrange
      when(() => mockRepository.addToCart(tProduct, 1))
          .thenAnswer((_) async => Left(CacheFailure()));

      // Act
      final result = await useCase(tProduct, quantity: 1);

      // Assert
      expect(result, Left(CacheFailure()));
    });

    test('should throw when quantity is zero or negative', () async {
      // Assert
      expect(
        () => useCase(tProduct, quantity: 0),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
```

#### 2. GREEN: Minimal Implementation
```dart
// lib/features/cart/domain/usecases/add_to_cart_usecase.dart

class AddToCartUseCase {
  final CartRepository repository;

  AddToCartUseCase({required this.repository});

  Future<Either<Failure, void>> call(
    Product product, {
    required int quantity,
  }) async {
    if (quantity <= 0) {
      throw ArgumentError('Quantity must be positive');
    }
    return repository.addToCart(product, quantity);
  }
}
```

#### 3. REFACTOR: Improve Without Changing Behavior
```dart
// After tests pass, refactor for better design
class AddToCartUseCase {
  final CartRepository repository;

  AddToCartUseCase({required this.repository});

  Future<Either<Failure, void>> call(
    Product product, {
    required int quantity,
  }) async {
    _validateQuantity(quantity);
    return repository.addToCart(product, quantity);
  }

  void _validateQuantity(int quantity) {
    if (quantity <= 0) {
      throw ArgumentError('Quantity must be positive');
    }
  }
}
```

### Testing Pyramid in Flutter

```
                    ┌─────────────┐
                    │   E2E/UI    │  Few, Slow, Expensive
                    │  Integration │
                    └─────────────┘
               ┌─────────────────────┐
               │   Widget Tests      │  Some, Medium Speed
               │   (Component)       │
               └─────────────────────┘
          ┌───────────────────────────────┐
          │       Unit Tests              │  Many, Fast, Cheap
          │  (UseCase, BLoC, Repository)  │
          └───────────────────────────────┘
```

#### Unit Tests (BLoC)
```dart
// test/features/products/presentation/bloc/products_bloc_test.dart

void main() {
  late ProductsBloc bloc;
  late MockGetProductsUseCase mockGetProducts;

  setUp(() {
    mockGetProducts = MockGetProductsUseCase();
    bloc = ProductsBloc(getProductsUseCase: mockGetProducts);
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state should be ProductsInitial', () {
    expect(bloc.state, ProductsInitial());
  });

  blocTest<ProductsBloc, ProductsState>(
    'should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(() => mockGetProducts())
          .thenAnswer((_) async => Right([tProduct]));
      return bloc;
    },
    act: (bloc) => bloc.add(ProductsLoadRequested()),
    expect: () => [
      ProductsLoading(),
      ProductsLoaded(products: [tProduct]),
    ],
    verify: (_) {
      verify(() => mockGetProducts()).called(1);
    },
  );

  blocTest<ProductsBloc, ProductsState>(
    'should emit [Loading, Error] when getting data fails',
    build: () {
      when(() => mockGetProducts())
          .thenAnswer((_) async => Left(ServerFailure()));
      return bloc;
    },
    act: (bloc) => bloc.add(ProductsLoadRequested()),
    expect: () => [
      ProductsLoading(),
      const ProductsError(message: 'Server error'),
    ],
  );
}
```

#### Widget Tests
```dart
// test/features/products/presentation/widgets/product_card_test.dart

void main() {
  testWidgets('ProductCard displays product information', (tester) async {
    // Arrange
    final product = Product(id: '1', name: 'Test Product', price: 29.99);

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProductCard(product: product),
        ),
      ),
    );

    // Assert
    expect(find.text('Test Product'), findsOneWidget);
    expect(find.text('\$29.99'), findsOneWidget);
  });

  testWidgets('ProductCard triggers onTap callback', (tester) async {
    // Arrange
    var tapped = false;
    final product = Product(id: '1', name: 'Test', price: 10.0);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProductCard(
            product: product,
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    // Act
    await tester.tap(find.byType(ProductCard));

    // Assert
    expect(tapped, isTrue);
  });
}
```

#### Integration Tests
```dart
// integration_test/checkout_flow_test.dart

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Complete checkout flow', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Navigate to products
    await tester.tap(find.text('Products'));
    await tester.pumpAndSettle();

    // Add product to cart
    await tester.tap(find.byType(ProductCard).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add to Cart'));
    await tester.pumpAndSettle();

    // Go to cart
    await tester.tap(find.byIcon(Icons.shopping_cart));
    await tester.pumpAndSettle();

    // Verify cart has item
    expect(find.byType(CartItem), findsOneWidget);

    // Proceed to checkout
    await tester.tap(find.text('Checkout'));
    await tester.pumpAndSettle();

    // Complete checkout
    await tester.tap(find.text('Place Order'));
    await tester.pumpAndSettle();

    // Verify success
    expect(find.text('Order Placed!'), findsOneWidget);
  });
}
```

### Test Coverage Requirements

```yaml
# Configure coverage thresholds
# Run: flutter test --coverage
# Generate report: genhtml coverage/lcov.info -o coverage/html

# Target coverage by layer:
# Domain (UseCases, Entities): 90%+
# Data (Repositories, Models): 80%+
# Presentation (BLoC): 80%+
# Widgets: 70%+
```

---

## 4. Verification Checklist

- [ ] Tests written before implementation (TDD cycle)
- [ ] Unit tests for all use cases
- [ ] Unit tests for all BLoCs
- [ ] Widget tests for key components
- [ ] Integration tests for critical flows
- [ ] Mocks used for external dependencies
- [ ] Test coverage meets thresholds
- [ ] Tests run in CI/CD pipeline

---

## 5. Interview Questions

### Question: Explain TDD and its benefits
**Answer:**
```
TDD (Test-Driven Development) is writing tests before implementation:

Cycle:
1. RED: Write a failing test for desired behavior
2. GREEN: Write minimum code to make test pass
3. REFACTOR: Improve code while keeping tests green

Benefits:
1. Better design: Forces thinking about API before implementation
2. Documentation: Tests describe expected behavior
3. Confidence: Refactor freely with safety net
4. Fewer bugs: Catch issues immediately
5. Faster debugging: Know exactly what broke

Example:
Instead of writing AddToCartUseCase then testing it, I:
1. Write test: "should add product to cart"
2. Test fails (class doesn't exist)
3. Create class with minimum implementation
4. Test passes
5. Refactor for clean code
```

### Question: What's the difference between unit, widget, and integration tests?
**Answer:**
```
Unit Tests:
- Test single unit (function, class) in isolation
- Dependencies mocked
- Fast, many of these
- Example: UseCase test with mocked repository

Widget Tests:
- Test single widget or small widget tree
- Pump widget in test environment
- Medium speed
- Example: ProductCard displays name and price

Integration Tests:
- Test complete flows across multiple components
- Run on real device/emulator
- Slow, few of these
- Example: Complete checkout flow from product to order

Testing pyramid:
- Many unit tests (base): Fast, cheap, isolated
- Some widget tests (middle): UI components work
- Few integration tests (top): Critical flows work end-to-end
```

### Question: How do you test a BLoC?
**Answer:**
```
I use bloc_test package for BLoC testing:

1. Setup: Create BLoC with mocked dependencies
2. Define initial state expectation
3. Use blocTest for event -> state transitions

blocTest<ProductsBloc, ProductsState>(
  'emits [Loading, Loaded] when load succeeds',
  build: () {
    when(() => mockUseCase()).thenAnswer(
      (_) async => Right([product])
    );
    return ProductsBloc(useCase: mockUseCase);
  },
  act: (bloc) => bloc.add(LoadProducts()),
  expect: () => [
    ProductsLoading(),
    ProductsLoaded([product]),
  ],
);

Key practices:
- Mock all use cases
- Test all event handlers
- Test error states
- Verify use case calls
- Close BLoC in tearDown
```

---

## 6. Additional Resources

- [Flutter Testing](https://docs.flutter.dev/testing)
- [bloc_test Package](https://pub.dev/packages/bloc_test)
- [mocktail Package](https://pub.dev/packages/mocktail)
- "Test-Driven Development" - Kent Beck

---

**Last update:** December 2024
**Version:** 1.0.0
