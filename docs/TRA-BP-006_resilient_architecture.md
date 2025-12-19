# TRA-BP-006: Resilient Architecture

## Technical Sheet

| Field | Value |
|-------|-------|
| **Code** | TRA-BP-006 |
| **Type** | Best Practice |
| **Description** | Resilient Architecture |
| **Associated Quality Attribute** | Architecture |
| **Technology** | BackEnd, Mobile, FrontEnd |
| **Responsible** | BackEnd, Mobile, FrontEnd |
| **Capability** | Backend |

---

## 1. Why (Business Justification)

### Business Rationale

> - Changes in client needs or market can be implemented more quickly and efficiently
> - Ensures stability, translating to greater customer satisfaction and better brand reputation
> - Guarantees greater customer satisfaction and better brand reputation

### Business Impact

| Metric | Without Resilience | With Resilient Architecture |
|--------|-------------------|----------------------------|
| System uptime | 95-98% | 99.9%+ |
| Recovery time | Hours | Minutes |
| Feature implementation | Risky, slow | Safe, fast |
| User trust | Fragile | Strong |

---

## 2. What (Technical Objective)

### Technical Goals

> - Centralize data access operations, simplify code, and improve maintainability by decoupling persistence from the rest of the application
> - Increase code flexibility and reuse, facilitate system extension by adding new strategies without modifying existing code
> - Protect the system by detecting failures anywhere in the application
> - Ensure processing of all transactions

---

## 3. How (Implementation Strategy)

### Design Patterns for Resilience

#### Repository Pattern
Provides abstraction between business logic and data access layer.

```dart
// Abstract repository
abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts();
  Future<Either<Failure, Product>> getProductById(String id);
  Future<Either<Failure, void>> saveProduct(Product product);
}

// Implementation with multiple data sources
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    if (await networkInfo.isConnected) {
      try {
        final products = await remoteDataSource.getProducts();
        await localDataSource.cacheProducts(products);
        return Right(products);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      // Fallback to cache
      try {
        return Right(await localDataSource.getCachedProducts());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
```

#### Strategy Pattern
Enables changing system behavior at runtime.

```dart
// Strategy interface
abstract class PaymentStrategy {
  Future<PaymentResult> processPayment(Order order);
}

// Concrete strategies
class CreditCardStrategy implements PaymentStrategy {
  @override
  Future<PaymentResult> processPayment(Order order) async {
    // Credit card processing logic
  }
}

class PayPalStrategy implements PaymentStrategy {
  @override
  Future<PaymentResult> processPayment(Order order) async {
    // PayPal processing logic
  }
}

// Context
class PaymentService {
  PaymentStrategy _strategy;

  PaymentService(this._strategy);

  void setStrategy(PaymentStrategy strategy) {
    _strategy = strategy;
  }

  Future<PaymentResult> checkout(Order order) {
    return _strategy.processPayment(order);
  }
}
```

#### Circuit Breaker Pattern
Prevents cascading failures by temporarily stopping requests to failing services.

```dart
enum CircuitState { closed, open, halfOpen }

class CircuitBreaker {
  final int failureThreshold;
  final Duration resetTimeout;

  int _failureCount = 0;
  CircuitState _state = CircuitState.closed;
  DateTime? _lastFailureTime;

  CircuitBreaker({
    this.failureThreshold = 5,
    this.resetTimeout = const Duration(seconds: 30),
  });

  Future<T> execute<T>(Future<T> Function() operation) async {
    if (_state == CircuitState.open) {
      if (_shouldReset()) {
        _state = CircuitState.halfOpen;
      } else {
        throw CircuitBreakerOpenException();
      }
    }

    try {
      final result = await operation();
      _onSuccess();
      return result;
    } catch (e) {
      _onFailure();
      rethrow;
    }
  }

  void _onSuccess() {
    _failureCount = 0;
    _state = CircuitState.closed;
  }

  void _onFailure() {
    _failureCount++;
    _lastFailureTime = DateTime.now();
    if (_failureCount >= failureThreshold) {
      _state = CircuitState.open;
    }
  }

  bool _shouldReset() {
    if (_lastFailureTime == null) return true;
    return DateTime.now().difference(_lastFailureTime!) > resetTimeout;
  }
}
```

#### Retry Pattern
Automatically retries failed operations.

```dart
class RetryPolicy {
  final int maxAttempts;
  final Duration initialDelay;
  final double backoffMultiplier;

  RetryPolicy({
    this.maxAttempts = 3,
    this.initialDelay = const Duration(milliseconds: 500),
    this.backoffMultiplier = 2.0,
  });

  Future<T> execute<T>(Future<T> Function() operation) async {
    int attempts = 0;
    Duration delay = initialDelay;

    while (true) {
      try {
        attempts++;
        return await operation();
      } catch (e) {
        if (attempts >= maxAttempts || !_isRetryable(e)) {
          rethrow;
        }
        await Future.delayed(delay);
        delay = Duration(
          milliseconds: (delay.inMilliseconds * backoffMultiplier).round(),
        );
      }
    }
  }

  bool _isRetryable(Object error) {
    return error is SocketException ||
           error is TimeoutException ||
           (error is HttpException && error.statusCode >= 500);
  }
}
```

---

## 4. Verification Checklist

- [ ] Repository pattern implemented for all data access
- [ ] Strategy pattern used for interchangeable behaviors
- [ ] Retry logic implemented for network operations
- [ ] Circuit breaker for external service calls
- [ ] Graceful degradation when services unavailable
- [ ] Local cache as fallback mechanism

---

## 5. Interview Questions

### Question: Explain the Repository Pattern
**Answer:**
```
Repository provides a single source of truth for data access. It:
1. Abstracts data sources (API, cache, database) from business logic
2. Allows swapping implementations without changing consumers
3. Enables offline-first architecture with cache fallback
4. Simplifies testing with mock repositories
5. Centralizes error handling and data transformation
```

### Question: When would you use Circuit Breaker?
**Answer:**
```
Circuit Breaker is useful when:
1. Calling external APIs that might be slow or unavailable
2. Preventing cascade failures across microservices
3. Protecting system resources from repeated failed calls
4. Providing fast failure response instead of timeouts

Implementation: Track failures, open circuit after threshold, allow
retry after timeout, close circuit on success.
```

---

## 6. Additional Resources

- [Repository Pattern](https://martinfowler.com/eaaCatalog/repository.html)
- [Strategy Pattern](https://refactoring.guru/design-patterns/strategy)
- [Circuit Breaker](https://martinfowler.com/bliki/CircuitBreaker.html)
- Project References: Alexandria, LearnWorlds

---

**Last update:** December 2024
**Version:** 1.0.0
