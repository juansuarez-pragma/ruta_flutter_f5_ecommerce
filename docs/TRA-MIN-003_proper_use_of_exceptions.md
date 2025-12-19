# TRA-MIN-003: Proper Use of Exceptions

## Technical Sheet

| Field | Value |
|-------|-------|
| **Code** | TRA-MIN-003 |
| **Type** | Minimum (Mandatory) |
| **Description** | Proper Use of Exceptions |
| **Associated Quality Attribute** | Traceability |
| **Technology** | Flutter |
| **Responsible** | FrontEnd, BackEnd, Mobile |
| **Capability** | Cross-functional |

---

## 1. Why (Business Justification)

### Business Rationale

> - Detect and manage exceptions early and effectively, reducing the risk of failures and support/maintenance costs.
> - Avoid unexpected crashes, offering clear messages instead of blocking users.
> - Ensure compliance with quality and security standards, avoiding penalties for the company.
> - Facilitate error identification and resolution, optimizing development and debugging activities.

### Business Impact

#### Financial Impact
- **Reduced support costs**: Each unhandled crash generates support tickets costing $15-50 per ticket
- **User retention**: Apps with frequent crashes have 3x higher uninstall rates
- **App Store ratings**: Crashes are the #1 reason for 1-star reviews
- **Revenue loss**: Each minute of downtime can cost $5,600 on average for e-commerce

#### Operational Impact
- **Faster debugging**: Proper exception handling reduces bug resolution time by 60%
- **Proactive monitoring**: Remote monitoring allows fixing issues before users report them
- **Compliance**: GDPR and PCI-DSS require proper error handling to avoid exposing sensitive data

#### Impact Metrics
| Metric | Poor Exception Handling | Proper Exception Handling |
|--------|------------------------|---------------------------|
| Crash-free rate | < 95% | > 99.5% |
| Mean Time to Resolution (MTTR) | 4-8 hours | 30-60 minutes |
| User-reported bugs | 80% | 20% |
| Support tickets/month | 500+ | < 50 |

---

## 2. What (Technical Objective)

### Technical Goal

> Respond appropriately to unexpected situations and improve user experience, capturing and logging each event executed in the system. Facilitate debugging and maintenance by providing detailed information about failures.

### Fundamental Principles

1. **Never crash silently**: Every exception must be captured and handled
2. **User-friendly messages**: Technical errors should never reach the user
3. **Comprehensive logging**: Every error must leave a trace for debugging
4. **Fail gracefully**: The app should degrade functionality, not crash entirely
5. **Security first**: Never expose sensitive information in error messages

---

## 3. How (Implementation Strategy)

### Implementation Approach

```
- Always implement controlled error handling that doesn't interrupt system operation
- Use try-catch blocks and appropriate error boundaries for the technology
- Use custom error types or factories
- Avoid ignoring exceptions in try/catch
- Implement a remote monitoring service to identify errors in real-time
- Use typed exceptions that semantically describe the problem
- Use log classification appropriately when debugging (Info, Warning, Error, Debug)
- Use the Result pattern (Success-Failure) to explicitly handle errors
- Provide clear and understandable feedback to the user if an error occurs
- User must not perceive uncontrolled errors
- Avoid exposing sensitive information in logs or internal error messages
```

### Error Flow Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        DATA LAYER                                │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │  try {                                                    │    │
│  │    final response = await api.call();                    │    │
│  │    return Right(Model.fromJson(response));               │    │
│  │  } on SocketException {                                  │    │
│  │    return Left(NetworkFailure());                        │    │
│  │  } on ServerException catch (e) {                        │    │
│  │    return Left(ServerFailure(e.message));                │    │
│  │  }                                                        │    │
│  └─────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘
                              │
                              │ Either<Failure, Data>
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                       DOMAIN LAYER                               │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │  sealed class Failure {                                  │    │
│  │    String get message;                                   │    │
│  │  }                                                        │    │
│  │  class NetworkFailure extends Failure {}                 │    │
│  │  class ServerFailure extends Failure {}                  │    │
│  │  class CacheFailure extends Failure {}                   │    │
│  └─────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘
                              │
                              │ Either<Failure, Data>
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                            │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │  result.fold(                                            │    │
│  │    (failure) => emit(ErrorState(                         │    │
│  │      _mapFailureToMessage(failure)  // User-friendly     │    │
│  │    )),                                                    │    │
│  │    (data) => emit(SuccessState(data)),                   │    │
│  │  );                                                       │    │
│  └─────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘
```

---

## 4. Way to do it (Flutter Instructions)

### 4.1 Null Safety Best Practices

```dart
// CORRECT: Using null-aware operators
class UserModel {
  final String name;
  final String? email;
  final int age;

  UserModel({
    required this.name,
    this.email,
    required this.age,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      // Use ?? for default values
      name: json['name'] ?? 'Unknown',
      // Keep nullable for optional fields
      email: json['email'],
      // Safe cast with default
      age: (json['age'] as int?) ?? 0,
    );
  }
}

// CORRECT: Safe navigation
void processUser(User? user) {
  // Use ?. for safe method calls
  final displayName = user?.name?.toUpperCase() ?? 'Guest';

  // Use ?[] for safe indexing
  final firstItem = user?.items?[0];

  // Use ! only when 100% certain it's not null
  // Prefer null checks instead
  if (user != null) {
    processVerifiedUser(user); // Now user is non-null
  }
}
```

### 4.2 Custom Exception Classes

```dart
// INCORRECT: Using generic Exception
throw Exception('Something went wrong'); // BAD: Not descriptive

// CORRECT: Custom typed exceptions
// lib/core/error/exceptions.dart
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final StackTrace? stackTrace;

  const AppException({
    required this.message,
    this.code,
    this.stackTrace,
  });

  @override
  String toString() => 'AppException: $message (code: $code)';
}

class ServerException extends AppException {
  final int statusCode;

  const ServerException({
    required super.message,
    required this.statusCode,
    super.code,
    super.stackTrace,
  });
}

class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection',
    super.code = 'NETWORK_ERROR',
  });
}

class CacheException extends AppException {
  const CacheException({
    super.message = 'Cache operation failed',
    super.code = 'CACHE_ERROR',
  });
}

class ValidationException extends AppException {
  final Map<String, String> fieldErrors;

  const ValidationException({
    required super.message,
    required this.fieldErrors,
    super.code = 'VALIDATION_ERROR',
  });
}

class AuthenticationException extends AppException {
  const AuthenticationException({
    super.message = 'Authentication required',
    super.code = 'AUTH_ERROR',
  });
}
```

### 4.3 Failure Classes with Sealed Classes

```dart
// lib/core/error/failures.dart
sealed class Failure {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});
}

class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    required super.message,
    this.statusCode,
    super.code,
  });
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Please check your internet connection',
    super.code = 'NETWORK_ERROR',
  });
}

class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Unable to load cached data',
    super.code = 'CACHE_ERROR',
  });
}

class ValidationFailure extends Failure {
  final Map<String, String> fieldErrors;

  const ValidationFailure({
    required super.message,
    required this.fieldErrors,
    super.code = 'VALIDATION_ERROR',
  });
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = 'An unexpected error occurred',
    super.code = 'UNEXPECTED_ERROR',
  });
}
```

### 4.4 Either Pattern Implementation

```dart
// lib/core/utils/either.dart
// Using dartz package or custom implementation
import 'package:dartz/dartz.dart';

// Repository implementation with Either
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
        final remoteProducts = await remoteDataSource.getProducts();
        await localDataSource.cacheProducts(remoteProducts);
        return Right(remoteProducts);
      } on ServerException catch (e) {
        return Left(ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
        ));
      } on SocketException {
        return Left(const NetworkFailure());
      } catch (e, stackTrace) {
        // Log unexpected errors
        _logError(e, stackTrace);
        return Left(const UnexpectedFailure());
      }
    } else {
      try {
        final localProducts = await localDataSource.getCachedProducts();
        return Right(localProducts);
      } on CacheException {
        return Left(const CacheFailure());
      }
    }
  }

  void _logError(Object error, StackTrace stackTrace) {
    // Use developer tools, not print
    log(
      'Unexpected error in ProductRepository',
      error: error,
      stackTrace: stackTrace,
      name: 'ProductRepository',
    );
  }
}
```

### 4.5 BLoC Error Handling with Alerts vs Modals

```dart
// lib/features/products/presentation/bloc/products_bloc.dart
import 'dart:developer';

sealed class ProductsState extends Equatable {
  const ProductsState();
}

class ProductsInitial extends ProductsState {
  @override
  List<Object?> get props => [];
}

class ProductsLoading extends ProductsState {
  @override
  List<Object?> get props => [];
}

class ProductsLoaded extends ProductsState {
  final List<Product> products;
  // Non-blocking alert (e.g., snackbar)
  final String? alertMessage;

  const ProductsLoaded({
    required this.products,
    this.alertMessage,
  });

  @override
  List<Object?> get props => [products, alertMessage];
}

// Blocking error - shows modal dialog
class ProductsError extends ProductsState {
  final String message;
  final bool isRetryable;

  const ProductsError({
    required this.message,
    this.isRetryable = true,
  });

  @override
  List<Object?> get props => [message, isRetryable];
}

// BLoC implementation
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
      (failure) {
        // Log failure for debugging
        log(
          'Products load failed',
          error: failure.message,
          name: 'ProductsBloc',
        );

        emit(ProductsError(
          message: _mapFailureToUserMessage(failure),
          isRetryable: _isRetryable(failure),
        ));
      },
      (products) {
        // Can include non-blocking alerts
        emit(ProductsLoaded(
          products: products,
          alertMessage: products.isEmpty
              ? 'No products available at this time'
              : null,
        ));
      },
    );
  }

  String _mapFailureToUserMessage(Failure failure) {
    // NEVER expose technical details to user
    return switch (failure) {
      NetworkFailure() => 'Please check your internet connection and try again',
      ServerFailure(:final statusCode) when statusCode == 404 =>
          'The requested products could not be found',
      ServerFailure(:final statusCode) when statusCode == 503 =>
          'Service temporarily unavailable. Please try again later',
      ServerFailure() => 'Unable to load products. Please try again',
      CacheFailure() => 'Unable to load saved products',
      ValidationFailure() => 'Invalid request. Please check your input',
      UnexpectedFailure() => 'Something went wrong. Please try again',
    };
  }

  bool _isRetryable(Failure failure) {
    return switch (failure) {
      NetworkFailure() => true,
      ServerFailure(:final statusCode) =>
          statusCode != null && statusCode >= 500,
      CacheFailure() => false,
      _ => true,
    };
  }
}
```

### 4.6 Using Developer Tools Instead of Print

```dart
// INCORRECT: Using print
void fetchData() {
  try {
    // ...
  } catch (e) {
    print('Error: $e'); // BAD: Not filtered in production
  }
}

// CORRECT: Using developer tools
import 'dart:developer';

void fetchData() {
  try {
    // ...

    // Info level logging
    log(
      'Fetching data from API',
      name: 'DataService',
      level: 800, // INFO level
    );

  } catch (e, stackTrace) {
    // Error level logging with stack trace
    log(
      'Failed to fetch data',
      error: e,
      stackTrace: stackTrace,
      name: 'DataService',
      level: 1000, // ERROR level
    );

    // Can also use Timeline for performance
    Timeline.instantSync('API_ERROR', arguments: {'error': e.toString()});
  }
}

// Log levels reference:
// 0 - FINEST
// 300 - FINER
// 400 - FINE
// 500 - CONFIG
// 700 - INFO
// 800 - WARNING
// 900 - SEVERE
// 1000 - SHOUT
```

### 4.7 Remote Monitoring Integration

```dart
// lib/core/monitoring/crash_reporter.dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

abstract class CrashReporter {
  Future<void> initialize();
  Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  });
  Future<void> setUserIdentifier(String identifier);
  Future<void> log(String message);
}

class FirebaseCrashReporter implements CrashReporter {
  @override
  Future<void> initialize() async {
    // Pass all uncaught errors to Crashlytics
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    // Pass all uncaught asynchronous errors
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  @override
  Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    await FirebaseCrashlytics.instance.recordError(
      exception,
      stackTrace,
      reason: reason,
      fatal: fatal,
    );
  }

  @override
  Future<void> setUserIdentifier(String identifier) async {
    await FirebaseCrashlytics.instance.setUserIdentifier(identifier);
  }

  @override
  Future<void> log(String message) async {
    await FirebaseCrashlytics.instance.log(message);
  }
}

// Usage in repository
class ProductRepositoryImpl implements ProductRepository {
  final CrashReporter crashReporter;

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      // ...
    } catch (e, stackTrace) {
      // Report to remote monitoring
      await crashReporter.recordError(
        e,
        stackTrace,
        reason: 'Failed to fetch products',
      );
      return Left(UnexpectedFailure());
    }
  }
}
```

### 4.8 Global Error Boundary

```dart
// lib/main.dart
void main() async {
  // Catch errors in the Flutter framework
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    // Report to crash monitoring
    sl<CrashReporter>().recordError(
      details.exception,
      details.stack,
      reason: 'Flutter framework error',
    );
  };

  // Catch errors outside Flutter framework
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await initializeDependencies();
      runApp(const MyApp());
    },
    (error, stackTrace) {
      // Report to crash monitoring
      sl<CrashReporter>().recordError(
        error,
        stackTrace,
        reason: 'Zoned error',
        fatal: true,
      );
    },
  );
}

// UI Error Boundary Widget
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(FlutterErrorDetails) onError;

  const ErrorBoundary({
    super.key,
    required this.child,
    required this.onError,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  FlutterErrorDetails? _error;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.onError(_error!);
    }
    return widget.child;
  }
}
```

---

## 5. Verification Checklist

### Null Safety
- [ ] All nullable values properly handled with `?`, `??`, `!`
- [ ] Default values defined for external data mapping
- [ ] No force unwrapping (`!`) without null checks

### Custom Exceptions
- [ ] Custom exception classes created (not using generic `Exception`)
- [ ] Exception names are descriptive and semantic
- [ ] Exceptions include relevant context (message, code, stackTrace)

### Failure Pattern
- [ ] Sealed classes used for Either/Optional implementation
- [ ] All failure types defined and documented
- [ ] Failures mapped to user-friendly messages

### BLoC Error Handling
- [ ] Alerts (non-blocking) differentiated from modals (blocking)
- [ ] User messages are non-technical
- [ ] Retry functionality available where appropriate

### Logging
- [ ] `print` not used for debugging (use `dart:developer` log)
- [ ] Log levels used appropriately (Info, Warning, Error, Debug)
- [ ] Sensitive information never logged

### Remote Monitoring
- [ ] Crashlytics or Sentry integrated
- [ ] All uncaught exceptions reported
- [ ] User identifiers set for tracking
- [ ] Custom logs sent for debugging context

### Security
- [ ] No sensitive data in error messages
- [ ] Stack traces not exposed to users
- [ ] API keys/tokens never in logs

---

## 6. Importance of Defining at Project Start

### Why It Cannot Wait

1. **Error patterns propagate**: Once developers start catching exceptions incorrectly, the pattern spreads throughout the codebase.

2. **Monitoring requires early setup**: Crashlytics/Sentry integration is easier before the app is complex.

3. **User experience foundation**: Error handling directly impacts perceived quality from day one.

4. **Debugging efficiency**: Proper logging from start means easier debugging as features are added.

5. **Security compliance**: Many regulations require proper error handling; retrofitting is expensive.

### Consequences of Not Doing It

| Problem | Consequence |
|---------|-------------|
| Empty catch blocks | Silent failures, impossible to debug |
| Generic exceptions | No semantic meaning, hard to handle specifically |
| Print statements | Logs mixed with production output, performance impact |
| Technical error messages | Poor UX, potential security vulnerability |
| No remote monitoring | Blind to production issues until users complain |

---

## 7. Technical Interview Questions - Senior Flutter

### Question 1: Exception Handling Strategy
**Interviewer:** "How do you handle errors across the different layers of your Flutter application?"

**Expected Answer:**
```
I implement a comprehensive error handling strategy across layers:

1. **Data Layer**: Catches all external exceptions (network, cache, API) and
   converts them to typed custom exceptions. Uses try-catch with specific
   exception types.

2. **Repository Layer**: Transforms exceptions into Failures using the Either
   pattern (Left for failure, Right for success). This makes error handling
   explicit and type-safe.

3. **Domain Layer**: Defines sealed Failure classes that represent all possible
   error states. UseCases propagate Either without modification.

4. **Presentation Layer**: BLoC receives Either, maps Failures to user-friendly
   messages, and emits appropriate states. Distinguishes between blocking errors
   (dialogs) and non-blocking alerts (snackbars).

This approach ensures no unhandled exceptions reach the user and maintains
traceability throughout the application.
```

### Question 2: Either Pattern
**Interviewer:** "Why do you use the Either pattern instead of throwing exceptions?"

**Expected Answer:**
```
The Either pattern offers several advantages over traditional exception throwing:

1. **Explicit error handling**: Functions that return Either<Failure, Success>
   make it clear they can fail. Developers must handle both cases.

2. **Type safety**: The compiler enforces handling of failure cases. You can't
   accidentally ignore an error.

3. **Composition**: Either values can be chained, mapped, and transformed
   functionally without try-catch blocks everywhere.

4. **No stack unwinding**: Exceptions are expensive as they unwind the call
   stack. Either is just a return value.

5. **Testability**: Testing functions that return Either is simpler than
   testing exception throwing.

Example:
result.fold(
  (failure) => handleFailure(failure),
  (success) => handleSuccess(success),
);
```

### Question 3: Null Safety
**Interviewer:** "How do you handle null values when mapping JSON responses to models?"

**Expected Answer:**
```
I follow a defensive approach when mapping external data:

1. **Always define defaults**: Every field should have a fallback value
   factory User.fromJson(Map<String, dynamic> json) {
     return User(
       name: json['name'] ?? 'Unknown',
       age: (json['age'] as int?) ?? 0,
     );
   }

2. **Use safe casts**: Never assume types from JSON
   price: (json['price'] as num?)?.toDouble() ?? 0.0

3. **Null-aware operators**: Use ?., ??, and ??= appropriately
   final email = json['email']?.toString()?.toLowerCase();

4. **Late validation**: Parse first, validate in domain layer
   The model can have null fields, but the entity requires non-null values
   validated before construction.

5. **Never force unwrap external data**: The ! operator should never be
   used on data from APIs, databases, or other external sources.
```

### Question 4: Logging Strategy
**Interviewer:** "What's your approach to logging in Flutter applications?"

**Expected Answer:**
```
I implement a structured logging approach:

1. **Never use print()**: Instead, I use dart:developer's log() function
   which provides levels, names, and is filtered in production.

2. **Log levels**:
   - DEBUG: Development details
   - INFO: Normal operations
   - WARNING: Potential issues
   - ERROR: Failures that need attention

3. **Structured logging**: Include context with every log
   log('User login attempt',
       name: 'AuthService',
       level: 700,
       error: null);

4. **Remote logging**: Integrate with Crashlytics/Sentry for production
   monitoring. Send breadcrumbs for context before crashes.

5. **Security**: Never log sensitive data (passwords, tokens, PII).
   Sanitize logs before sending to remote services.

6. **Performance**: Avoid logging in hot paths. Use conditional logging
   based on environment.
```

### Question 5: User Error Messages
**Interviewer:** "How do you handle showing error messages to users?"

**Expected Answer:**
```
I follow UX best practices for error communication:

1. **Never show technical errors**: Users should never see "NullPointerException"
   or "404 Not Found". Map all failures to human-readable messages.

2. **Categorize by impact**:
   - Non-blocking (snackbar): Informational, can be dismissed
   - Blocking (dialog): Requires user action, has recovery options

3. **Actionable messages**: Always tell users what they can do
   "No internet connection. Please check your settings and try again."

4. **Consistent tone**: Use friendly, non-blaming language
   "We couldn't load your data" not "Failed to fetch data"

5. **Localization**: Error messages should support i18n
   Map failure codes to localized strings

6. **Recovery options**: Provide retry buttons, alternative actions,
   or contact support links depending on error type.

Example mapping:
String mapFailureToMessage(Failure f) {
  return switch (f) {
    NetworkFailure() => 'Check your internet connection',
    ServerFailure() => 'Our servers are busy. Try again later',
    _ => 'Something went wrong. Please try again',
  };
}
```

### Question 6: Real Challenge Solved
**Interviewer:** "Tell me about a challenging error handling situation you've solved"

**Expected Answer:**
```
In a fintech app, we had intermittent payment failures that were
difficult to diagnose:

Problem:
- Users reported "payment failed" but our logs showed success
- No crash reports despite user complaints
- Support couldn't reproduce issues

Investigation:
- Empty catch blocks were swallowing exceptions
- Generic error messages didn't distinguish failure types
- No remote monitoring beyond crashes

Solution implemented:
1. Created typed PaymentException hierarchy (NetworkPaymentException,
   ValidationPaymentException, GatewayPaymentException)

2. Implemented Either pattern throughout payment flow with detailed
   Failure types

3. Added Crashlytics non-fatal error reporting for all payment failures

4. Implemented breadcrumb logging for payment flow steps

5. Created user-friendly messages with support contact options

Result:
- Payment success rate improved from 94% to 99.2%
- MTTR for payment issues reduced from 2 days to 2 hours
- Support tickets reduced 70%
- Could now identify that most failures were network timeouts on
  3G connections, leading to retry implementation
```

---

## 8. Anti-Patterns to Avoid

### 8.1 Empty Catch Blocks
```dart
// INCORRECT: Silently swallowing exceptions
try {
  await api.call();
} catch (e) {
  // Empty - errors disappear silently
}

// CORRECT: Always handle or rethrow
try {
  await api.call();
} catch (e, stackTrace) {
  log('API call failed', error: e, stackTrace: stackTrace);
  return Left(ServerFailure(message: 'Operation failed'));
}
```

### 8.2 Generic Exception Messages
```dart
// INCORRECT: Meaningless to users
throw Exception('Error'); // What error?

// CORRECT: Descriptive and actionable
throw ServerException(
  message: 'Failed to fetch products',
  statusCode: 500,
  code: 'PRODUCTS_FETCH_ERROR',
);
```

### 8.3 Exposing Technical Details
```dart
// INCORRECT: Technical message to user
emit(ProductsError(message: failure.toString()));
// User sees: "ServerException: HTTP 500 at /api/products"

// CORRECT: User-friendly message
emit(ProductsError(
  message: 'Unable to load products. Please try again.',
));
```

### 8.4 Using Print for Logging
```dart
// INCORRECT: Print in production
print('Error: $e'); // Not filtered, performance impact

// CORRECT: Developer tools
log('Error occurred', error: e, name: 'MyService');
```

---

## 9. Additional Resources

### Official Documentation
- [Dart Error Handling](https://dart.dev/language/error-handling)
- [Flutter Error Handling](https://docs.flutter.dev/testing/errors)
- [Firebase Crashlytics](https://firebase.google.com/docs/crashlytics/get-started?platform=flutter)
- [Sentry for Flutter](https://docs.sentry.io/platforms/flutter/)

### Packages
- [dartz](https://pub.dev/packages/dartz) - Functional programming
- [fpdart](https://pub.dev/packages/fpdart) - Alternative to dartz
- [firebase_crashlytics](https://pub.dev/packages/firebase_crashlytics)
- [sentry_flutter](https://pub.dev/packages/sentry_flutter)

### Project References
- Alexandria: RUM Flutter, Logs - Mobile
- LearnWorlds: Exceptions - Mobile

---

## 10. Compliance Evidence

To validate compliance with this requirement, document:

| Evidence | Description |
|----------|-------------|
| Exception class diagram | Visualization of exception hierarchy |
| Crash-free rate dashboard | Crashlytics/Sentry metrics |
| Error message mapping | Document of failure to user message mappings |
| Code review checklist | Verification of exception handling in PRs |

---

**Last update:** December 2024
**Author:** Architecture Team
**Version:** 1.0.0
