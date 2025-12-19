# TRA-MIN-002: Architecture Validation

## Technical Sheet

| Field | Value |
|-------|-------|
| **Code** | TRA-MIN-002 |
| **Type** | Minimum (Mandatory) |
| **Description** | Architecture Validation |
| **Associated Quality Attribute** | Maintainability |
| **Technology** | Flutter |
| **Responsible** | BackEnd, Mobile |
| **Capability** | Cross-functional |

---

## 1. Why (Business Justification)

### Business Rationale

> Reduce maintenance, updates, and adaptation costs as the business or technology evolves.

### Business Impact

#### Direct Costs
- **40-60% reduction in long-term maintenance costs** according to industry studies
- **Decreased onboarding time** for new developers from weeks to days
- **Lower accumulated technical debt** which can represent up to 40% of development budget in poorly structured projects

#### Indirect Costs
- **Accelerated time-to-market**: New features are implemented faster
- **Lower staff turnover**: Developers prefer working on well-structured projects
- **Reduced bugs in production**: Separation of concerns facilitates testing

#### Impact Metrics
| Metric | Without Clear Architecture | With Clean Architecture |
|--------|---------------------------|-------------------------|
| New feature implementation time | 2-3 weeks | 3-5 days |
| Bugs per release | 15-25 | 3-5 |
| Test coverage | < 30% | > 70% |
| Onboarding time | 4-6 weeks | 1-2 weeks |

---

## 2. What (Technical Objective)

### Technical Goal

> Separate responsibilities, facilitate maintenance, scalability, and testing, creating a modular system easily adaptable to technological and/or functional changes.

### Fundamental Principles

1. **Separation of Concerns (SoC)**: Each layer has a single reason to change
2. **Framework Independence**: Business logic doesn't depend on Flutter
3. **UI Independence**: Business logic works without graphical interface
4. **Database Independence**: Storage can be changed without affecting business
5. **Testability**: Each component is testable in isolation

---

## 3. How (Implementation Strategy)

### Implementation Approach

```
- Use clean architecture patterns that allow separation of responsibilities
- Organize code by layers independent of frameworks, databases, and external interfaces
- Centralize business logic without generating direct dependency on other layers
- Establish dependency rules from outer layers to inner layers
- Inner layers must not know about outer layers
- Maintain high cohesion and low coupling between layers
- Depend on abstractions (interfaces or abstract classes) not concrete implementations
- Use dependency injection strategies to favor code testing
- Avoid unnecessary dependencies
```

### Layer Diagram

```
+--------------------------------------------------+
|                   PRESENTATION                    |
|  (Pages, Widgets, BLoC/Cubit, ViewModels)        |
+--------------------------------------------------+
                        |
                        | depends on
                        v
+--------------------------------------------------+
|                     DOMAIN                        |
|  (Entities, Use Cases, Repository Interfaces)    |
|  ** PURE DART - NO FLUTTER DEPENDENCIES **       |
+--------------------------------------------------+
                        ^
                        | implements
                        |
+--------------------------------------------------+
|                      DATA                         |
|  (Models, Repository Impl, DataSources)          |
+--------------------------------------------------+
```

### Dependency Rule

```
PRESENTATION --> DOMAIN <-- DATA

- Presentation KNOWS Domain (can import it)
- Data KNOWS Domain (can import it)
- Domain DOES NOT KNOW Presentation or Data (Pure Dart)
```

---

## 4. Way to do it (Flutter Instructions)

### 4.1 Folder Structure

```
lib/
├── core/
│   ├── di/                    # Dependency injection (get_it)
│   ├── error/                 # Custom Failures and Exceptions
│   ├── network/               # HTTP client, interceptors
│   ├── utils/                 # Extensions, helpers
│   └── constants/             # Global constants
│
├── features/
│   └── [feature_name]/
│       ├── data/
│       │   ├── datasources/   # Remote and Local data sources
│       │   ├── models/        # DTOs with fromJson/toJson
│       │   └── repositories/  # Repository implementation
│       │
│       ├── domain/
│       │   ├── entities/      # Business entities (immutable)
│       │   ├── repositories/  # Interfaces/contracts
│       │   └── usecases/      # Use cases
│       │
│       └── presentation/
│           ├── bloc/          # BLoC/Cubit + Events + States
│           ├── pages/         # Screens
│           └── widgets/       # Feature-specific widgets
│
└── shared/
    └── widgets/               # Reusable widgets
```

### 4.2 Implementation Rules

#### Domain Layer (PURE DART)
```dart
// CORRECT: Immutable entity without Flutter dependencies
class Product {
  final String id;
  final String name;
  final double price;

  const Product({
    required this.id,
    required this.name,
    required this.price,
  });
}

// CORRECT: Repository interface
abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts();
  Future<Either<Failure, Product>> getProductById(String id);
}

// CORRECT: Use case with single responsibility
class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase({required this.repository});

  Future<Either<Failure, List<Product>>> call() {
    return repository.getProducts();
  }
}
```

#### Data Layer
```dart
// CORRECT: Model with serialization methods
class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.price,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
  };

  ProductModel copyWith({String? id, String? name, double? price}) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
    );
  }
}

// CORRECT: DataSource with abstraction
abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final HttpClient client;

  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductModel>> getProducts() async {
    final response = await client.get('/products');
    return (response.data as List)
        .map((json) => ProductModel.fromJson(json))
        .toList();
  }
}
```

#### Presentation Layer
```dart
// CORRECT: BLoC depends on UseCase, not Repository
class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetProductsUseCase getProductsUseCase;

  ProductsBloc({required this.getProductsUseCase})
      : super(ProductsInitial()) {
    on<ProductsLoadRequested>(_onLoadRequested);
  }

  Future<void> _onLoadRequested(
    ProductsLoadRequested event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());

    final result = await getProductsUseCase();

    result.fold(
      (failure) => emit(ProductsError(failure.message)),
      (products) => emit(ProductsLoaded(products)),
    );
  }
}
```

### 4.3 Dependency Injection with get_it

```dart
// lib/core/di/injection_container.dart
final sl = GetIt.instance;

Future<void> init() async {
  // BLoCs
  sl.registerFactory(
    () => ProductsBloc(getProductsUseCase: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(
    () => GetProductsUseCase(repository: sl()),
  );

  // Repositories
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(client: sl()),
  );

  // External
  sl.registerLazySingleton(() => HttpClient());
}
```

### 4.4 Flavors/Schemes Configuration

```yaml
# pubspec.yaml
flutter:
  assets:
    - assets/config/

# Configuration files per environment
# assets/config/dev.json
# assets/config/qa.json
# assets/config/prod.json
```

```dart
// lib/core/config/environment.dart
enum Environment { dev, qa, prod }

class EnvironmentConfig {
  static late Environment current;
  static late String apiBaseUrl;

  static Future<void> initialize(Environment env) async {
    current = env;
    final config = await _loadConfig(env);
    apiBaseUrl = config['apiBaseUrl'];
  }
}
```

### 4.5 Package Versioning

```yaml
# pubspec.yaml - CORRECT: Fixed versions
dependencies:
  flutter_bloc: 8.1.6
  get_it: 8.3.0
  dartz: 0.10.1
  equatable: 2.0.5

# INCORRECT: Open ranges (avoid)
dependencies:
  flutter_bloc: ^8.0.0  # May bring breaking changes
```

### 4.6 AAA Test Pattern

```dart
void main() {
  late GetProductsUseCase useCase;
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
    useCase = GetProductsUseCase(repository: mockRepository);
  });

  test('should return list of products from repository', () async {
    // Arrange
    final products = [
      Product(id: '1', name: 'Test', price: 10.0),
    ];
    when(() => mockRepository.getProducts())
        .thenAnswer((_) async => Right(products));

    // Act
    final result = await useCase();

    // Assert
    expect(result, Right(products));
    verify(() => mockRepository.getProducts()).called(1);
  });
}
```

---

## 5. Verification Checklist

### Structure
- [ ] Project organized in layers: `data`, `domain`, `presentation`
- [ ] Each feature has its own layer structure
- [ ] `core` folder exists for cross-cutting components
- [ ] `shared` folder exists for reusable widgets

### Domain Layer
- [ ] Entities are immutable (all properties `final`)
- [ ] Domain is pure Dart (no imports from `package:flutter`)
- [ ] Repositories defined as abstract interfaces
- [ ] One UseCase per business operation
- [ ] UseCases use `call()` method for invocation

### Data Layer
- [ ] Models include `fromJson`, `toJson`, `copyWith`
- [ ] Models define default values for nullable fields
- [ ] Repositories implement Domain interfaces
- [ ] DataSources are abstracted with interfaces
- [ ] Repository is the only source of data access

### Presentation Layer
- [ ] BLoC/Cubit per use case (not per screen)
- [ ] BLoC depends only on UseCase abstractions
- [ ] BLoC does not access repositories directly
- [ ] Events in past tense: `ProductsLoadRequested`, `CartItemAdded`
- [ ] States as nouns/adjectives: `ProductsLoading`, `ProductsLoaded`

### Dependency Injection
- [ ] `get_it` configured in `injection_container.dart`
- [ ] BLoCs registered as `Factory`
- [ ] UseCases registered as `LazySingleton`
- [ ] DataSources and Repositories as `LazySingleton`

### Configuration
- [ ] Flavors configured (Android) and Schemes (iOS)
- [ ] Environment variables per environment (dev, qa, prod)
- [ ] README documents dependency rules
- [ ] Labels centralization for i18n

### Versioning
- [ ] Fixed versions in `pubspec.yaml`
- [ ] Ranges only for well-maintained packages

---

## 6. Importance of Defining at Project Start

### Why It Cannot Wait

1. **Exponential Refactoring Cost**: Changing architecture after 6 months of development can cost 10x more than defining it correctly from the start.

2. **Cumulative Technical Debt**: Every line of code written without clear architecture is debt that will be paid with interest.

3. **Team Consistency**: If each developer uses their own style, code becomes an impossible-to-maintain chaos.

4. **Facilitates Code Reviews**: With clear rules, reviews are objective and fast.

5. **Team Scalability**: New members can contribute from day 1 following established conventions.

### Consequences of Not Doing It

| Problem | Consequence |
|---------|-------------|
| No layer separation | Business logic mixed with UI, impossible to test |
| BLoC accessing DataSource | Changing data source requires modifying presentation |
| Domain with Flutter dependencies | Cannot be reused in other Dart projects |
| No dependency injection | Tests require complex mocks or are impossible |

---

## 7. Technical Interview Questions - Senior Flutter

### Question 1: Clean Architecture
**Interviewer:** "Explain how you would implement Clean Architecture in a Flutter project. What are the layers and how do they communicate?"

**Expected Answer:**
```
Clean Architecture in Flutter is organized in 3 main layers:

1. **Domain** (core): Contains business entities, repository interfaces,
   and use cases. This layer is pure Dart, without Flutter dependencies.
   Entities are immutable and represent business concepts.

2. **Data** (infrastructure): Implements interfaces defined in Domain.
   Contains models (DTOs) with serialization methods, repository
   implementations, and datasources (remote and local).

3. **Presentation** (UI): Contains BLoCs/Cubits, pages, and widgets.
   BLoCs only know about use cases, never access repositories directly.

The dependency rule is: Presentation -> Domain <- Data. Domain doesn't
know about outer layers, which allows testability and flexibility to
change implementations without affecting business logic.
```

### Question 2: Dependency Rule
**Interviewer:** "Why is it important that the Domain layer has no Flutter dependencies?"

**Expected Answer:**
```
Domain independence from Flutter is crucial for several reasons:

1. **Testability**: I can write unit tests that run in any Dart
   environment, without needing a Flutter context.

2. **Reusability**: Business logic can be shared between Flutter
   projects, Dart server applications, or CLIs.

3. **Longevity**: If Flutter evolves or we decide to migrate to another
   technology, 30-40% of code (business logic) remains intact.

4. **Conceptual Clarity**: Forces separation of "what the app does"
   (Domain) from "how it displays" (Presentation) and "where it gets
   data" (Data).

In practice, I verify that no file in domain/ imports 'package:flutter'.
```

### Question 3: Dependency Injection
**Interviewer:** "How do you handle dependency injection in Flutter? Why do you use get_it?"

**Expected Answer:**
```
I use get_it as Service Locator for dependency injection. Configuration
is centralized in injection_container.dart where I register:

- **Factory**: For BLoCs (a new instance per use)
- **LazySingleton**: For UseCases, Repositories, and DataSources (single instance)

Benefits:
1. **Testability**: I can easily replace implementations with mocks
2. **Decoupling**: Components don't instantiate their dependencies
3. **Centralized configuration**: Single place to see all dependencies
4. **Lazy loading**: Instances are created only when needed

Practical example:
sl.registerFactory(() => ProductsBloc(getProductsUseCase: sl()));
sl.registerLazySingleton(() => GetProductsUseCase(repository: sl()));
sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(...));
```

### Question 4: BLoC and Use Cases
**Interviewer:** "What is the relationship between BLoC and UseCases? Why shouldn't a BLoC access the repository directly?"

**Expected Answer:**
```
BLoC is the bridge between UI and business logic. It should only know
UseCases, not repositories directly, because:

1. **Single Responsibility**: BLoC handles UI states, UseCase
   encapsulates a specific business operation.

2. **Reusability**: A UseCase can be used by multiple BLoCs.
   For example, GetUserUseCase can be used in LoginBloc, ProfileBloc, etc.

3. **Testability**: I can test the UseCase isolated from BLoC, and mock
   the UseCase when testing BLoC.

4. **Avoids God Classes**: Without UseCases, BLoC would end up with all
   business logic, becoming unmanageable.

Ideal pattern:
- One BLoC per UI flow (not per screen)
- Multiple UseCases per BLoC if the flow requires it
- BLoC orchestrates, UseCase executes
```

### Question 5: Error Handling in Architecture
**Interviewer:** "How do you handle errors across layers?"

**Expected Answer:**
```
I implement the Either pattern with Failure for explicit error handling:

1. **Data Layer**: Catches exceptions and converts them to typed Failures
   try {
     return Right(await dataSource.getData());
   } on ServerException catch (e) {
     return Left(ServerFailure(e.message));
   }

2. **Domain Layer**: Defines Failures as sealed classes
   sealed class Failure {
     final String message;
   }
   class ServerFailure extends Failure {}
   class CacheFailure extends Failure {}

3. **Presentation Layer**: BLoC transforms Failures into error states
   result.fold(
     (failure) => emit(ProductsError(failure.message)),
     (products) => emit(ProductsLoaded(products)),
   );

This ensures no unhandled error reaches the user and each layer
processes errors appropriately.
```

### Question 6: Real Challenge Solved
**Interviewer:** "Tell me about an architectural challenge you've solved in a Flutter project"

**Expected Answer:**
```
In an inherited e-commerce project, I found that:
- BLoCs accessed APIs directly
- No layer separation existed
- Non-existent tests (0% coverage)
- Changing payment provider required modifying 15+ files

Implemented solution:
1. Defined clean architecture with 3 layers
2. Created interfaces for repositories (PaymentRepository, ProductRepository)
3. Extracted business logic to UseCases
4. Implemented dependency injection with get_it
5. Wrote unit tests for UseCases (80% coverage)

Result:
- Changing payment provider required modifying 1 file (DataSource)
- New feature time-to-market reduced 60%
- New dev onboarding went from 3 weeks to 3 days
- Production bugs reduced 70%
```

---

## 8. Anti-Patterns to Avoid

### 8.1 BLoC Accessing DataSource
```dart
// INCORRECT
class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductRemoteDataSource dataSource; // BAD: Skipping layers

  Future<void> _onLoad(...) async {
    final products = await dataSource.getProducts(); // BAD
  }
}

// CORRECT
class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetProductsUseCase getProductsUseCase;

  Future<void> _onLoad(...) async {
    final result = await getProductsUseCase();
  }
}
```

### 8.2 Domain with Flutter Dependencies
```dart
// INCORRECT: domain/entities/user.dart
import 'package:flutter/material.dart'; // BAD

class User {
  final Color favoriteColor; // BAD: Flutter dependency
}

// CORRECT
class User {
  final int favoriteColorValue; // OK: Primitive Dart type
}
```

### 8.3 Mutable Entities
```dart
// INCORRECT
class Product {
  String name; // BAD: Mutable
  double price; // BAD: Mutable
}

// CORRECT
class Product {
  final String name;
  final double price;

  const Product({required this.name, required this.price});
}
```

---

## 9. Additional Resources

### Official Documentation
- [Flutter Architecture Samples](https://fluttersamples.com)
- [BLoC Library Documentation](https://bloclibrary.dev)
- [get_it Package](https://pub.dev/packages/get_it)

### Recommended Books
- "Clean Architecture" - Robert C. Martin
- "Domain-Driven Design" - Eric Evans

### Project References
- Alexandria: Clean Architecture Mobile
- LearnWorlds: Clean Architecture Mobile

---

## 10. Compliance Evidence

To validate compliance with this requirement, document:

| Evidence | Description |
|----------|-------------|
| Structure screenshot | Capture of folder structure |
| Dependency diagram | Visualization of imports between layers |
| Coverage report | Unit tests per layer |
| Code review checklist | Verification in PRs |

---

**Last update:** December 2024
**Author:** Architecture Team
**Version:** 1.0.0
