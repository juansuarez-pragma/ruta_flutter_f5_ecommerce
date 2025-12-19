# TRA-BP-007: Domain-Driven Design (DDD)

## Technical Sheet

| Field | Value |
|-------|-------|
| **Code** | TRA-BP-007 |
| **Type** | Best Practice |
| **Description** | Domain-Driven Design |
| **Associated Quality Attribute** | Scalability |
| **Technology** | BackEnd, Mobile |
| **Responsible** | BackEnd, Mobile |
| **Capability** | Cross-functional |

---

## 1. Why (Business Justification)

### Business Rationale

> Focuses on close collaboration between domain experts and developers to model the business accurately and effectively, using a common language.

### Business Impact

| Metric | Without DDD | With DDD |
|--------|-------------|----------|
| Requirement misunderstandings | High | Minimal |
| Business-tech alignment | Poor | Strong |
| Complex domain modeling | Chaotic | Structured |
| Feature evolution | Difficult | Natural |

---

## 2. What (Technical Objective)

### Technical Goal

> Create a flexible, modular, and understandable software design that reflects the complexities and rules of the domain, facilitating system evolution and maintenance.

### DDD Strategic Concepts

1. **Ubiquitous Language**: Shared vocabulary between developers and domain experts
2. **Bounded Contexts**: Clear boundaries between different parts of the system
3. **Entities**: Objects with identity that persists over time
4. **Value Objects**: Immutable objects defined by their attributes
5. **Aggregates**: Clusters of entities treated as a single unit
6. **Domain Services**: Operations that don't belong to entities
7. **Repositories**: Abstractions for data persistence

---

## 3. How (Implementation Strategy)

### Approach

```
- Understanding the problem domain
- Identifying key concepts
- Creating, refining, and communicating a domain model
```

### Flutter DDD Implementation

#### Bounded Context Structure
```
lib/
├── features/
│   ├── order/                  # Order Bounded Context
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── order.dart
│   │   │   │   └── order_item.dart
│   │   │   ├── value_objects/
│   │   │   │   ├── order_id.dart
│   │   │   │   └── money.dart
│   │   │   ├── aggregates/
│   │   │   │   └── order_aggregate.dart
│   │   │   ├── services/
│   │   │   │   └── order_pricing_service.dart
│   │   │   └── repositories/
│   │   │       └── order_repository.dart
│   │   ├── application/
│   │   │   └── usecases/
│   │   └── infrastructure/
│   │       └── repositories/
│   │
│   └── inventory/              # Inventory Bounded Context
│       └── ...
```

#### Value Objects
```dart
/// Value Object - Immutable, defined by attributes
class Money extends Equatable {
  final double amount;
  final String currency;

  const Money({
    required this.amount,
    required this.currency,
  }) : assert(amount >= 0, 'Amount cannot be negative');

  Money add(Money other) {
    _assertSameCurrency(other);
    return Money(amount: amount + other.amount, currency: currency);
  }

  Money subtract(Money other) {
    _assertSameCurrency(other);
    return Money(amount: amount - other.amount, currency: currency);
  }

  Money multiply(double factor) {
    return Money(amount: amount * factor, currency: currency);
  }

  void _assertSameCurrency(Money other) {
    if (currency != other.currency) {
      throw CurrencyMismatchException();
    }
  }

  @override
  List<Object?> get props => [amount, currency];
}

/// Value Object for Order ID
class OrderId extends Equatable {
  final String value;

  const OrderId(this.value) : assert(value.isNotEmpty);

  factory OrderId.generate() => OrderId(const Uuid().v4());

  @override
  List<Object?> get props => [value];
}
```

#### Entities
```dart
/// Entity - Has identity, mutable over time
class Order {
  final OrderId id;
  final CustomerId customerId;
  final List<OrderItem> items;
  OrderStatus status;
  final DateTime createdAt;
  DateTime? updatedAt;

  Order({
    required this.id,
    required this.customerId,
    required this.items,
    this.status = OrderStatus.pending,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Money get total => items.fold(
    const Money(amount: 0, currency: 'USD'),
    (sum, item) => sum.add(item.subtotal),
  );

  bool get canBeCancelled =>
      status == OrderStatus.pending || status == OrderStatus.confirmed;

  void addItem(OrderItem item) {
    if (status != OrderStatus.pending) {
      throw OrderModificationException('Cannot modify non-pending order');
    }
    items.add(item);
    _markUpdated();
  }

  void confirm() {
    if (status != OrderStatus.pending) {
      throw InvalidOrderStateException('Can only confirm pending orders');
    }
    if (items.isEmpty) {
      throw EmptyOrderException();
    }
    status = OrderStatus.confirmed;
    _markUpdated();
  }

  void cancel() {
    if (!canBeCancelled) {
      throw InvalidOrderStateException('Order cannot be cancelled');
    }
    status = OrderStatus.cancelled;
    _markUpdated();
  }

  void _markUpdated() {
    updatedAt = DateTime.now();
  }
}
```

#### Aggregates
```dart
/// Aggregate Root - Entry point for the aggregate
class OrderAggregate {
  final Order _order;
  final OrderPricingService _pricingService;

  OrderAggregate(this._order, this._pricingService);

  Order get order => _order;

  void addProduct(Product product, int quantity) {
    final price = _pricingService.calculatePrice(product, quantity);
    final item = OrderItem(
      productId: product.id,
      productName: product.name,
      quantity: quantity,
      unitPrice: price,
    );
    _order.addItem(item);
  }

  void applyDiscount(Discount discount) {
    if (!discount.isApplicable(_order)) {
      throw DiscountNotApplicableException();
    }
    // Apply discount logic through aggregate
  }

  void checkout() {
    _order.confirm();
    // Invariant: Order must have items
    // Invariant: Total must be positive
    // Invariant: Customer must be valid
  }
}
```

#### Domain Services
```dart
/// Domain Service - Business logic that doesn't belong to entities
class OrderPricingService {
  final PricingRulesRepository pricingRules;

  OrderPricingService({required this.pricingRules});

  Money calculatePrice(Product product, int quantity) {
    var price = product.basePrice;

    // Apply quantity discount
    if (quantity >= 10) {
      price = price.multiply(0.9); // 10% discount
    }

    // Apply promotional pricing
    final promotion = pricingRules.getActivePromotion(product.id);
    if (promotion != null) {
      price = promotion.apply(price);
    }

    return price.multiply(quantity.toDouble());
  }

  Money calculateOrderTotal(Order order) {
    var total = order.total;

    // Apply order-level discounts
    if (total.amount > 100) {
      total = total.multiply(0.95); // 5% for orders over $100
    }

    return total;
  }
}
```

#### Domain Events
```dart
/// Domain Event - Something that happened in the domain
abstract class DomainEvent {
  final DateTime occurredOn;

  DomainEvent() : occurredOn = DateTime.now();
}

class OrderPlaced extends DomainEvent {
  final OrderId orderId;
  final CustomerId customerId;
  final Money total;

  OrderPlaced({
    required this.orderId,
    required this.customerId,
    required this.total,
  });
}

class OrderCancelled extends DomainEvent {
  final OrderId orderId;
  final String reason;

  OrderCancelled({
    required this.orderId,
    required this.reason,
  });
}

/// Event Publisher
class DomainEventPublisher {
  final List<DomainEventHandler> _handlers = [];

  void subscribe(DomainEventHandler handler) {
    _handlers.add(handler);
  }

  void publish(DomainEvent event) {
    for (final handler in _handlers) {
      if (handler.canHandle(event)) {
        handler.handle(event);
      }
    }
  }
}
```

---

## 4. Verification Checklist

- [ ] Ubiquitous language defined and documented
- [ ] Bounded contexts identified and separated
- [ ] Entities have clear identity
- [ ] Value objects are immutable
- [ ] Aggregates enforce invariants
- [ ] Domain services for cross-entity logic
- [ ] Domain events for significant occurrences

---

## 5. Interview Questions

### Question: Explain Entity vs Value Object
**Answer:**
```
Entity:
- Has unique identity (ID)
- Identity persists over time
- Two entities with same attributes but different IDs are different
- Example: User, Order, Product

Value Object:
- Defined by its attributes, not identity
- Immutable - changes create new instances
- Two value objects with same attributes are equal
- Example: Money, Address, DateRange

In code:
// Entity - identity matters
user1.id == user2.id // Same user even if attributes differ

// Value Object - attributes matter
money1 == money2 // Equal if same amount and currency
```

### Question: What is an Aggregate?
**Answer:**
```
An Aggregate is a cluster of domain objects treated as a single unit:

1. Has a root entity (Aggregate Root)
2. External objects can only reference the root
3. Enforces invariants across contained objects
4. Defines transactional boundary
5. Loaded and saved as a whole

Example: Order aggregate contains Order (root), OrderItems, and
shipping info. You access items through Order, never directly.
This ensures order total always matches sum of items.

Rule: Only the aggregate root is referenced from outside. Changes
to internal objects go through the root, maintaining consistency.
```

### Question: How do you identify Bounded Contexts?
**Answer:**
```
Identifying Bounded Contexts:

1. **Language differences**: When the same term means different things
   - "Product" in catalog vs. inventory vs. shipping

2. **Team boundaries**: Different teams own different contexts

3. **Business capability**: Each capability = potential context
   - Orders, Payments, Shipping, Inventory

4. **Data consistency requirements**: Strong consistency within,
   eventual consistency between contexts

5. **Rate of change**: Parts that change together belong together

In Flutter e-commerce:
- Catalog Context: Products, Categories, Search
- Order Context: Cart, Checkout, Order History
- User Context: Profile, Authentication, Preferences
- Payment Context: Payment methods, Transactions
```

---

## 6. Additional Resources

- "Domain-Driven Design" - Eric Evans
- "Implementing Domain-Driven Design" - Vaughn Vernon
- [DDD Community](https://dddcommunity.org/)

---

**Last update:** December 2024
**Version:** 1.0.0
