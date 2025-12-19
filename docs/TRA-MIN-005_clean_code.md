# TRA-MIN-005: Clean Code

## Technical Sheet

| Field | Value |
|-------|-------|
| **Code** | TRA-MIN-005 |
| **Type** | Minimum (Mandatory) |
| **Description** | Clean Code |
| **Associated Quality Attribute** | Maintainability |
| **Technology** | Java, Python, JavaScript/TypeScript, Flutter |
| **Responsible** | FrontEnd, BackEnd, Mobile |
| **Capability** | Cross-functional |

---

## 1. Why (Business Justification)

### Business Rationale

> - There is greater flexibility and adaptability to new requirements or technologies, extending its useful life and avoiding costly implementations for the business later.
> - Reduces maintenance, updates, and adaptation costs as the business evolves.

### Business Impact

#### Financial Impact
- **40% reduction in maintenance costs**: Clean code is easier to understand and modify
- **60% faster bug fixes**: Clear code reveals problems quickly
- **50% reduction in onboarding time**: Self-documenting code needs less explanation
- **3x faster feature development**: Adding to clean code is straightforward

#### Long-term Impact
| Metric | Dirty Code | Clean Code |
|--------|------------|------------|
| Time to understand function | 15-30 min | 2-5 min |
| Bug introduction rate per change | 15% | 3% |
| Code lifespan before rewrite | 2-3 years | 7-10 years |
| Developer satisfaction | Low | High |

#### Industry Research
- Code is read **10x more often** than it's written (Robert Martin)
- **50% of developer time** is spent understanding existing code
- Technical debt costs **$85 billion annually** in the US alone
- Clean code projects have **4x lower defect density**

---

## 2. What (Technical Objective)

### Technical Goal

> Improve understanding and collaboration between developers, facilitate error detection and correction, and allow greater scalability and extensibility of code.

### Clean Code Principles

1. **Readability**: Code should read like well-written prose
2. **Simplicity**: Do one thing and do it well
3. **Self-documenting**: Code explains itself through naming
4. **DRY (Don't Repeat Yourself)**: Eliminate duplication
5. **SOLID**: Follow the five fundamental OOP principles

---

## 3. How (Implementation Strategy)

### Implementation Approach

```
- Write readable, simple, and self-documenting code
- Code should be an asset, not a liability
- Use clear, descriptive, and consistent names for variables, functions, and classes
- Keep functions and methods short, with a single responsibility
- Avoid code duplication; reuse functions and components
- Document code concisely: comments only if they explain what's not obvious
- Remove dead, unnecessary, or unused code
- Prefer simple and readable structures over complex or "clever" ones
- Follow language style conventions (indentation, spacing, etc.)
- Refactor periodically to improve readability and maintenance
- All code must satisfy SOLID principles
```

---

## 4. Way to do it (Flutter Instructions)

### 4.1 Naming Conventions

```dart
// Variables: camelCase
final userName = 'John';
final productList = <Product>[];
final isLoading = false;
final hasError = true;
final itemCount = 10;

// Classes: PascalCase
class UserRepository {}
class ProductModel {}
class AuthenticationBloc {}
class GetProductsUseCase {}

// Files: snake_case
// user_repository.dart
// product_model.dart
// authentication_bloc.dart
// get_products_usecase.dart

// Constants: lowerCamelCase or SCREAMING_SNAKE_CASE
const maxRetryCount = 3;
const apiTimeout = Duration(seconds: 30);
const String API_BASE_URL = 'https://api.example.com'; // For truly constant values

// Private members: prefix with underscore
class _InternalHelper {}
final _privateVariable = 'internal';
void _privateMethod() {}

// Boolean variables: use is, has, can, should prefixes
final isValid = true;
final hasPermission = false;
final canSubmit = true;
final shouldRefresh = false;
```

### 4.2 Descriptive Naming Examples

```dart
// INCORRECT: Cryptic names
final d = DateTime.now();
final u = await getU();
final lst = items.where((e) => e.a > 0).toList();
void fn(int x, int y) {}

// CORRECT: Self-documenting names
final currentDateTime = DateTime.now();
final currentUser = await getCurrentUser();
final availableItems = items.where((item) => item.quantity > 0).toList();
void calculateTotalPrice(int quantity, int unitPrice) {}

// INCORRECT: Hungarian notation or type in name
final strName = 'John';
final intAge = 25;
final lstProducts = <Product>[];

// CORRECT: Let the type system handle types
final name = 'John';
final age = 25;
final products = <Product>[];

// INCORRECT: Abbreviations
final usr = getUsr();
final prod = getProd();
final qty = item.qty;

// CORRECT: Full words
final user = getUser();
final product = getProduct();
final quantity = item.quantity;
```

### 4.3 Code Formatting

```dart
// Indentation: 2 spaces (Dart standard)
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text('Hello'),
          Text('World'),
        ],
      ),
    );
  }
}

// Conditionals and loops: always use braces
// INCORRECT
if (isLoading) return CircularProgressIndicator();
for (var item in items) print(item);

// CORRECT
if (isLoading) {
  return const CircularProgressIndicator();
}

for (final item in items) {
  processItem(item);
}

// Line length: 80 characters (configurable)
// INCORRECT: Long line
final veryLongVariableName = someFunction(parameter1, parameter2, parameter3, parameter4);

// CORRECT: Break into multiple lines
final veryLongVariableName = someFunction(
  parameter1,
  parameter2,
  parameter3,
  parameter4,
);
```

### 4.4 Documentation Standards

```dart
/// A repository for managing user data.
///
/// This class provides methods for CRUD operations on user entities.
/// It abstracts the data source (local or remote) from the business logic.
///
/// Example:
/// ```dart
/// final repository = UserRepository();
/// final user = await repository.getUserById('123');
/// ```
class UserRepository {
  /// Retrieves a user by their unique identifier.
  ///
  /// Returns `null` if no user is found with the given [id].
  ///
  /// Throws [NetworkException] if the network is unavailable.
  Future<User?> getUserById(String id) async {
    // Implementation
  }

  /// Creates a new user with the given [data].
  ///
  /// The [data] map must contain:
  /// - `name`: The user's full name (required)
  /// - `email`: The user's email address (required)
  /// - `age`: The user's age (optional)
  ///
  /// Returns the created [User] with generated ID.
  Future<User> createUser(Map<String, dynamic> data) async {
    // Implementation
  }
}

// Comments for non-obvious logic only
void calculateDiscount(double price, int quantity) {
  // Apply bulk discount: 10% off for orders of 10+ items
  // Business rule defined in JIRA-1234
  if (quantity >= 10) {
    price *= 0.9;
  }
}

// INCORRECT: Obvious comments
// Get the user
final user = getUser();
// Check if user is null
if (user == null) {
  // Return early
  return;
}

// CORRECT: Code is self-explanatory, no comments needed
final user = getUser();
if (user == null) {
  return;
}
```

### 4.5 Constants and Magic Values

```dart
// INCORRECT: Magic values scattered in code
if (response.statusCode == 200) {}
if (retryCount > 3) {}
await Future.delayed(Duration(milliseconds: 300));

// CORRECT: Centralized constants
// lib/core/constants/api_constants.dart
abstract class ApiConstants {
  static const int successStatusCode = 200;
  static const int maxRetryCount = 3;
  static const Duration debounceDelay = Duration(milliseconds: 300);
  static const String baseUrl = 'https://api.example.com';
}

// lib/core/constants/ui_constants.dart
abstract class UiConstants {
  static const double defaultPadding = 16.0;
  static const double borderRadius = 8.0;
  static const Duration animationDuration = Duration(milliseconds: 200);
}

// Usage
if (response.statusCode == ApiConstants.successStatusCode) {}
if (retryCount > ApiConstants.maxRetryCount) {}
await Future.delayed(ApiConstants.debounceDelay);
```

### 4.6 Single Responsibility Functions

```dart
// INCORRECT: Function doing multiple things
Future<void> handleLogin(String email, String password) async {
  // Validate
  if (email.isEmpty || !email.contains('@')) {
    showError('Invalid email');
    return;
  }
  if (password.length < 8) {
    showError('Password too short');
    return;
  }

  // Make API call
  try {
    final response = await http.post(
      Uri.parse('https://api.example.com/login'),
      body: {'email': email, 'password': password},
    );

    // Parse response
    final data = jsonDecode(response.body);
    final user = User.fromJson(data);

    // Save to local storage
    await prefs.setString('user', jsonEncode(user.toJson()));
    await prefs.setString('token', data['token']);

    // Update UI
    setState(() {
      currentUser = user;
      isLoggedIn = true;
    });

    // Navigate
    Navigator.pushReplacementNamed(context, '/home');
  } catch (e) {
    showError('Login failed');
  }
}

// CORRECT: Separate concerns
class LoginValidator {
  ValidationResult validateCredentials(String email, String password) {
    if (email.isEmpty || !email.contains('@')) {
      return ValidationResult.failure('Invalid email');
    }
    if (password.length < 8) {
      return ValidationResult.failure('Password too short');
    }
    return ValidationResult.success();
  }
}

class AuthRepository {
  Future<Either<Failure, AuthResult>> login(String email, String password) async {
    try {
      final response = await apiClient.login(email, password);
      await localStorage.saveAuthResult(response);
      return Right(response);
    } on ApiException catch (e) {
      return Left(AuthFailure(e.message));
    }
  }
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginValidator validator;
  final AuthRepository repository;

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    final validation = validator.validateCredentials(event.email, event.password);
    if (!validation.isValid) {
      emit(LoginValidationError(validation.message));
      return;
    }

    emit(LoginLoading());
    final result = await repository.login(event.email, event.password);
    result.fold(
      (failure) => emit(LoginError(failure.message)),
      (authResult) => emit(LoginSuccess(authResult.user)),
    );
  }
}
```

### 4.7 SOLID Principles in Flutter

```dart
// S - Single Responsibility Principle
// Each class has one reason to change

// INCORRECT: Class doing too much
class UserManager {
  void createUser() {}
  void deleteUser() {}
  void sendEmail() {}      // Different responsibility
  void generateReport() {} // Different responsibility
  void validateUser() {}   // Different responsibility
}

// CORRECT: Separated responsibilities
class UserRepository {
  Future<User> createUser(UserData data) async {}
  Future<void> deleteUser(String id) async {}
}

class EmailService {
  Future<void> sendEmail(Email email) async {}
}

class UserReportGenerator {
  Report generateReport(List<User> users) {}
}

class UserValidator {
  ValidationResult validate(UserData data) {}
}

// O - Open/Closed Principle
// Open for extension, closed for modification

// INCORRECT: Modifying class for each payment type
class PaymentProcessor {
  void processPayment(String type) {
    if (type == 'credit') {
      // Credit card logic
    } else if (type == 'debit') {
      // Debit card logic
    } else if (type == 'paypal') {
      // PayPal logic - had to modify class!
    }
  }
}

// CORRECT: Extensible through abstraction
abstract class PaymentMethod {
  Future<PaymentResult> process(Payment payment);
}

class CreditCardPayment implements PaymentMethod {
  @override
  Future<PaymentResult> process(Payment payment) async {}
}

class PayPalPayment implements PaymentMethod {
  @override
  Future<PaymentResult> process(Payment payment) async {}
}

class PaymentProcessor {
  Future<PaymentResult> process(PaymentMethod method, Payment payment) {
    return method.process(payment);
  }
}

// L - Liskov Substitution Principle
// Subtypes must be substitutable for their base types

// INCORRECT: Square violates Rectangle contract
class Rectangle {
  double width;
  double height;

  void setWidth(double w) => width = w;
  void setHeight(double h) => height = h;
  double area() => width * height;
}

class Square extends Rectangle {
  @override
  void setWidth(double w) {
    width = w;
    height = w; // Violates expected behavior!
  }
}

// CORRECT: Proper abstraction
abstract class Shape {
  double area();
}

class Rectangle implements Shape {
  final double width;
  final double height;

  const Rectangle(this.width, this.height);

  @override
  double area() => width * height;
}

class Square implements Shape {
  final double side;

  const Square(this.side);

  @override
  double area() => side * side;
}

// I - Interface Segregation Principle
// Clients shouldn't depend on interfaces they don't use

// INCORRECT: Fat interface
abstract class Worker {
  void work();
  void eat();
  void sleep();
  void attendMeeting();
  void writeReport();
}

// CORRECT: Segregated interfaces
abstract class Workable {
  void work();
}

abstract class Feedable {
  void eat();
}

abstract class Reportable {
  void writeReport();
}

class Developer implements Workable, Feedable, Reportable {
  @override
  void work() {}
  @override
  void eat() {}
  @override
  void writeReport() {}
}

class Robot implements Workable {
  @override
  void work() {}
  // Doesn't need to implement eat()!
}

// D - Dependency Inversion Principle
// Depend on abstractions, not concretions

// INCORRECT: High-level depends on low-level
class ProductsBloc {
  final ProductApiService apiService; // Concrete dependency

  ProductsBloc() : apiService = ProductApiService();
}

// CORRECT: Depend on abstraction
abstract class ProductRepository {
  Future<List<Product>> getProducts();
}

class ProductsBloc {
  final ProductRepository repository; // Abstract dependency

  ProductsBloc({required this.repository});
}

// Allows easy testing and swapping implementations
class MockProductRepository implements ProductRepository {
  @override
  Future<List<Product>> getProducts() async => [];
}
```

### 4.8 Code Hygiene

```dart
// INCORRECT: Dead code left in
void processOrder(Order order) {
  // final oldCalculation = order.total * 0.9;
  // if (order.isLegacy) {
  //   return oldCalculation;
  // }

  final total = order.total;
  // TODO: implement discount logic
  // FIXME: this breaks for negative values
  return total;
}

// CORRECT: Clean, no dead code, no stale TODOs
void processOrder(Order order) {
  if (order.total <= 0) {
    throw ArgumentError('Order total must be positive');
  }
  return applyDiscount(order.total, order.discountPercentage);
}

// Conventional Commits for git
// feat: add user authentication
// fix: resolve null pointer in cart calculation
// docs: update API documentation
// style: format code according to style guide
// refactor: extract payment processing to separate service
// test: add unit tests for order validation
// chore: update dependencies
```

---

## 5. Verification Checklist

### Naming
- [ ] Variables use camelCase
- [ ] Classes use PascalCase
- [ ] Files use snake_case
- [ ] Boolean variables have is/has/can/should prefix
- [ ] Names are descriptive and self-documenting
- [ ] No abbreviations or cryptic names

### Formatting
- [ ] Indentation is 2 spaces
- [ ] Conditionals and loops use braces
- [ ] Line length <= 80 characters
- [ ] Consistent formatting throughout

### Documentation
- [ ] Public APIs documented with `///`
- [ ] Complex logic has explanatory comments
- [ ] No obvious comments
- [ ] Examples provided where helpful

### Code Quality
- [ ] No magic values (all constants centralized)
- [ ] Functions have single responsibility
- [ ] No code duplication (DRY)
- [ ] No dead or commented code
- [ ] No stale TODOs or FIXMEs

### SOLID Compliance
- [ ] Classes have single responsibility
- [ ] Open for extension, closed for modification
- [ ] Subtypes are substitutable
- [ ] Interfaces are segregated
- [ ] Dependencies are inverted

### Git Hygiene
- [ ] Commits follow Conventional Commits spec
- [ ] No commented code committed
- [ ] Meaningful commit messages

---

## 6. Importance of Defining at Project Start

### Why It Cannot Wait

1. **Code culture is contagious**: Developers copy existing patterns. Clean code begets clean code; messy code spreads.

2. **Refactoring cost compounds**: Every day of messy code adds debt. After 6 months, cleanup may cost more than the original development.

3. **Team velocity**: Clean code enables fast feature development. Dirty code slows everything down.

4. **Knowledge transfer**: Clean code is documentation. New team members ramp up faster.

5. **Debugging efficiency**: When bugs occur (and they will), clean code reveals them quickly.

### Consequences of Not Doing It

| Problem | Consequence |
|---------|-------------|
| Inconsistent naming | Developers can't find what they need |
| No documentation | Knowledge locked in original developer's head |
| Magic values | Changes require hunting through entire codebase |
| Large functions | Impossible to test, debug, or understand |
| SOLID violations | Changes cascade unpredictably |

---

## 7. Technical Interview Questions - Senior Flutter

### Question 1: Clean Code Definition
**Interviewer:** "What does 'clean code' mean to you and why is it important?"

**Expected Answer:**
```
Clean code is code that is easy to read, understand, and modify. It has
several key characteristics:

1. **Readability**: Anyone can understand what it does without extensive
   documentation. It reads like well-written prose.

2. **Simplicity**: It does one thing and does it well. No unnecessary
   complexity or "clever" tricks.

3. **Maintainability**: Changes can be made confidently without fear of
   breaking unrelated functionality.

4. **Testability**: Components are isolated and can be tested independently.

Why it matters:
- Code is read 10x more than written, so readability is paramount
- 50% of development time is understanding existing code
- Clean code reduces bug introduction rate by 80%
- Enables sustainable velocity over project lifetime
- Facilitates team collaboration and knowledge transfer

I always follow the Boy Scout Rule: "Leave the code cleaner than you found it."
```

### Question 2: Naming Practices
**Interviewer:** "How do you approach naming in your code?"

**Expected Answer:**
```
Naming is one of the most important aspects of clean code. My approach:

1. **Intention-revealing names**: The name tells what the variable/function
   does without needing comments
   - Bad: `d` (elapsed time in days)
   - Good: `elapsedTimeInDays`

2. **Avoid disinformation**: Names shouldn't lie about what they contain
   - Bad: `accountList` when it's actually a Set
   - Good: `accounts` or `accountSet`

3. **Pronounceable names**: You should be able to discuss the code verbally
   - Bad: `genymdhms` (generation date, year, month, day, hour, minute, second)
   - Good: `generationTimestamp`

4. **Searchable names**: Avoid single letters except in very short scopes
   - Bad: `for (var e in list)`
   - Good: `for (final employee in employees)`

5. **Consistent vocabulary**: Use one word per concept throughout
   - Don't mix `fetch`, `retrieve`, `get`, `obtain` for the same action
   - Pick one and use it everywhere

6. **Context in names**: Class membership provides context
   - In `Address` class: `street` not `addressStreet`
```

### Question 3: Function Design
**Interviewer:** "What makes a well-designed function?"

**Expected Answer:**
```
A well-designed function follows these principles:

1. **Small**: Functions should be 5-20 lines. If longer, extract subfunctions.

2. **Single responsibility**: Does one thing only. If the name has "and"
   in it, split it.

3. **One level of abstraction**: Don't mix high and low level operations.
   `processOrder()` shouldn't contain HTTP parsing code.

4. **Descriptive name**: The name should describe everything the function
   does. Long names are fine if descriptive.

5. **Few parameters**: Ideal is 0-2. More than 3 suggests the function
   does too much or needs a parameter object.

6. **No side effects**: If it's called `checkPassword`, it shouldn't also
   log the user in. Do what the name says, nothing more.

7. **Command-Query Separation**: Functions either do something (command)
   or return something (query), not both.

8. **Error handling**: Separate error handling from happy path logic.
   Use Either pattern or early returns.

Example:
  // Good: small, single responsibility, descriptive
  bool isEligibleForDiscount(User user) {
    return user.isPremium && user.orderCount > 10;
  }
```

### Question 4: SOLID in Practice
**Interviewer:** "How do you apply SOLID principles in Flutter?"

**Expected Answer:**
```
I apply SOLID throughout my Flutter architecture:

**Single Responsibility**:
- Each BLoC handles one feature/flow
- Repositories handle data operations
- UseCases encapsulate single business rules
- Widgets have focused UI responsibilities

**Open/Closed**:
- Use abstract classes for repositories, datasources
- New payment methods don't modify PaymentProcessor
- Dependency injection allows swapping implementations

**Liskov Substitution**:
- All repository implementations honor their interface contracts
- Mock implementations behave like real ones for testing
- No surprises when substituting subclasses

**Interface Segregation**:
- Create focused interfaces: UserReader, UserWriter vs giant UserManager
- Widgets depend only on callbacks they use
- BLoCs expose only needed state slices

**Dependency Inversion**:
- BLoC depends on UseCase abstractions
- UseCase depends on Repository interfaces
- All wired up via get_it, not instantiated directly
- Enables testing with mocks at every layer

Practical example:
Instead of ProductsBloc depending on ProductApiService (concrete),
it depends on ProductRepository (abstract). This lets me:
- Swap API implementation without touching BLoC
- Test with MockProductRepository
- Support offline mode with LocalProductRepository
```

### Question 5: Refactoring Strategy
**Interviewer:** "How do you approach refactoring legacy code?"

**Expected Answer:**
```
My approach to refactoring follows a systematic process:

1. **Characterization tests first**: Before changing anything, write tests
   that capture current behavior. This safety net catches unintended changes.

2. **Small, incremental changes**: Never big-bang refactor. Each change
   should be mergeable and deployable.

3. **Extract method**: Long functions -> extract meaningful chunks with
   descriptive names.

4. **Extract class**: God classes -> separate into focused classes with
   single responsibilities.

5. **Rename for clarity**: Poor names -> descriptive names (IDE refactoring
   tools make this safe).

6. **Remove duplication**: Copy-paste code -> extracted shared functions.

7. **Introduce abstractions**: Concrete dependencies -> interfaces/abstract
   classes for flexibility.

8. **Boy Scout Rule**: Every PR leaves code a little cleaner than before.

Practical example:
Faced with 500-line widget:
1. Added widget tests for critical paths
2. Extracted business logic to BLoC
3. Split UI into smaller widgets
4. Introduced constants for magic values
5. Applied over 3 sprints, no disruption to features
```

### Question 6: Real Challenge Solved
**Interviewer:** "Tell me about a time you improved code quality significantly"

**Expected Answer:**
```
In a healthcare app, I inherited a codebase with serious clean code violations:

Problems found:
- 2000-line "GodWidget" with all app logic
- Variables named a, b, temp, data
- Duplicated API calls in 15+ places
- No constants - URLs hardcoded everywhere
- Zero tests

Approach:
1. Added crash reporting to understand failure points
2. Wrote characterization tests for critical flows
3. Created architecture document and got team buy-in

Refactoring (over 4 sprints):
- Extracted GodWidget into 20 focused widgets
- Created constants files, eliminated 200+ magic values
- Introduced repository pattern, unified 15 duplicate API calls to 1
- Renamed 300+ variables and functions
- Established code review checklist

Results:
- Bug rate dropped 65%
- New feature time reduced 50%
- Code coverage went from 0% to 70%
- New developers onboarded in days instead of weeks
- Team morale improved significantly

Key lesson: Clean code isn't a one-time activity but a continuous practice.
```

---

## 8. Anti-Patterns to Avoid

### 8.1 God Classes
```dart
// INCORRECT: Class doing everything
class AppManager {
  void login() {}
  void logout() {}
  void fetchProducts() {}
  void addToCart() {}
  void checkout() {}
  void sendAnalytics() {}
  void showNotification() {}
}

// CORRECT: Focused classes
class AuthManager {}
class ProductRepository {}
class CartService {}
class CheckoutService {}
class AnalyticsService {}
class NotificationService {}
```

### 8.2 Cryptic Names
```dart
// INCORRECT
final d = DateTime.now();
final u = await getU();
final p = u.p;
fn(x, y);

// CORRECT
final currentDate = DateTime.now();
final user = await getCurrentUser();
final permissions = user.permissions;
calculateTotal(quantity, unitPrice);
```

### 8.3 Comments Instead of Clarity
```dart
// INCORRECT: Comment explains unclear code
// Calculate total with tax and discount
final t = (p * q) * (1 + tr) * (1 - d);

// CORRECT: Code is self-explanatory
final subtotal = price * quantity;
final taxAmount = subtotal * taxRate;
final discountAmount = subtotal * discountPercentage;
final total = subtotal + taxAmount - discountAmount;
```

---

## 9. Additional Resources

### Books
- "Clean Code" - Robert C. Martin
- "The Pragmatic Programmer" - David Thomas, Andrew Hunt
- "Refactoring" - Martin Fowler
- "Code Complete" - Steve McConnell

### Official Documentation
- [Effective Dart](https://dart.dev/effective-dart)
- [Flutter Style Guide](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo)

### Project References
- Alexandria: Clean code
- LearnWorlds: Clean code

---

## 10. Compliance Evidence

To validate compliance with this requirement, document:

| Evidence | Description |
|----------|-------------|
| Code review checklist | Clean code verification in PRs |
| Naming conventions doc | Team agreement on naming |
| Refactoring log | History of code improvements |
| SOLID compliance review | Architecture review notes |

---

**Last update:** December 2024
**Author:** Architecture Team
**Version:** 1.0.0
