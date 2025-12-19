# MOFE-MIN-001: Performance

## Technical Sheet

| Field | Value |
|-------|-------|
| **Code** | MOFE-MIN-001 |
| **Type** | Minimum (Mandatory) |
| **Description** | Performance |
| **Associated Quality Attribute** | Performance |
| **Technology** | Flutter |
| **Responsible** | FrontEnd, Mobile |
| **Capability** | Mobile/Frontend |

---

## 1. Why (Business Justification)

### Business Rationale

> - Improves user experience.
> - Reduces bounce rate and increases user time-on-app.
> - Improves SEO/ASO positioning, obtaining better ranking in search results for the company.

### Business Impact

#### User Experience Impact
- **53% of users abandon apps** that take more than 3 seconds to load (Google research)
- **1 second delay** in mobile load time can reduce conversions by 20%
- **79% of users** who are dissatisfied with app performance are less likely to buy again
- **Apps rated 4+ stars** have significantly better performance metrics

#### Financial Impact
| Metric | Poor Performance | Optimized Performance |
|--------|------------------|----------------------|
| User retention (30-day) | 20-30% | 40-60% |
| Conversion rate | 1-2% | 3-5% |
| App store rating | 2.5-3.5 stars | 4.0-4.5 stars |
| Support tickets/month | High | Low |

#### Performance Benchmarks
| Metric | Target | Critical |
|--------|--------|----------|
| First Contentful Paint | < 1.8s | > 3s |
| Time to Interactive | < 3.8s | > 7.3s |
| Frame rate | 60 FPS | < 30 FPS |
| Jank frames | < 1% | > 5% |

---

## 2. What (Technical Objective)

### Technical Goal

> Reduce app size and improve load times and general performance of mobile apps, contributing positively to user experience and favoring SEO/ASO.

### Performance Pillars

1. **Rendering Performance**: Maintain 60 FPS, avoid jank
2. **Memory Management**: Efficient memory usage, no leaks
3. **Network Efficiency**: Minimize requests, optimize payloads
4. **App Size**: Optimize bundle size for faster downloads
5. **Battery Efficiency**: Minimize background processing

---

## 3. How (Implementation Strategy)

### Implementation Approach

```
- Implement image optimization using modern formats (WebP, AVIF)
- Implement Skeleton UI during resource loading
- Avoid blocking the main execution thread with long-running or expensive processing tasks
- Make correct use of lazy loading to postpone views not immediately required
- Always release unused resources
- Use monitoring tools to measure performance, considering platform-specific metrics
- Avoid unnecessary access to resources like external services or local databases
```

---

## 4. Way to do it (Flutter Instructions)

### 4.1 Use const Constructors

```dart
// INCORRECT: Rebuilds on every parent rebuild
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text('Static Text'),
          Icon(Icons.home),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Another text'),
          ),
        ],
      ),
    );
  }
}

// CORRECT: Const prevents unnecessary rebuilds
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Column(
        children: [
          Text('Static Text'),
          Icon(Icons.home),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Another text'),
          ),
        ],
      ),
    );
  }
}

// CRITICAL: Make widgets const when possible
const myWidget = MyWidget(); // Compile-time constant
```

### 4.2 Container vs Specialized Widgets

```dart
// INCORRECT: Using Container for simple cases
Container(
  width: 100,
  height: 100,
)

Container(
  padding: EdgeInsets.all(8),
  child: Text('Hello'),
)

Container(
  color: Colors.red,
  child: Text('Hello'),
)

// CORRECT: Use specialized widgets
const SizedBox(
  width: 100,
  height: 100,
)

const Padding(
  padding: EdgeInsets.all(8),
  child: Text('Hello'),
)

const ColoredBox(
  color: Colors.red,
  child: Text('Hello'),
)

// Use Container only when you need 3+ properties
Container(
  width: 100,
  height: 100,
  padding: EdgeInsets.all(8),
  decoration: BoxDecoration(
    color: Colors.red,
    borderRadius: BorderRadius.circular(8),
  ),
  child: Text('Hello'),
)

// For empty space, always use SizedBox.shrink()
const SizedBox.shrink() // NOT Container()
```

### 4.3 Lazy Loading with Builders

```dart
// INCORRECT: Loads all items immediately
ListView(
  children: items.map((item) => ItemWidget(item)).toList(),
)

// CORRECT: Lazy loads items as they become visible
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)

// For grids
GridView.builder(
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
  ),
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)

// For pages
PageView.builder(
  itemCount: pages.length,
  itemBuilder: (context, index) => PageWidget(pages[index]),
)

// CRITICAL: Never use shrinkWrap with lazy builders
// INCORRECT: Defeats lazy loading purpose
ListView.builder(
  shrinkWrap: true, // BAD: Builds all items!
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)

// CORRECT: Use Expanded or give explicit height
Expanded(
  child: ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, index) => ItemWidget(items[index]),
  ),
)
```

### 4.4 Minimize Rebuild Scope

```dart
// INCORRECT: Rebuilding entire tree
class ProductsPage extends StatefulWidget {
  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      body: Column(
        children: [
          // Entire Column rebuilds when counter changes
          Text('Counter: $counter'),
          ExpensiveProductList(), // Rebuilds unnecessarily!
          AnotherWidget(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => counter++),
        child: Icon(Icons.add),
      ),
    );
  }
}

// CORRECT: Isolate rebuilds to leaf widgets
class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: const Column(
        children: [
          CounterWidget(), // Only this rebuilds
          ExpensiveProductList(), // Const, doesn't rebuild
          AnotherWidget(),
        ],
      ),
    );
  }
}

class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Counter: $counter'),
        IconButton(
          onPressed: () => setState(() => counter++),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
```

### 4.5 StatelessWidget vs StatefulWidget

```dart
// PREFER StatelessWidget when possible
// Use StatefulWidget only for:
// - Animations
// - Form handling
// - Local state that doesn't belong in BLoC

// INCORRECT: Using StatefulWidget unnecessarily
class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Text(widget.product.name),
    );
  }
}

// CORRECT: StatelessWidget for static UI
class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Text(product.name),
    );
  }
}
```

### 4.6 ValueNotifier over setState

```dart
// For simple local state, ValueNotifier is more efficient
class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  // ValueNotifier instead of plain int
  final _counter = ValueNotifier<int>(0);

  @override
  void dispose() {
    _counter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Only this rebuilds, not the entire widget
        ValueListenableBuilder<int>(
          valueListenable: _counter,
          builder: (context, value, child) {
            return Text('Counter: $value');
          },
        ),
        // These don't rebuild
        const ExpensiveWidget(),
        ElevatedButton(
          onPressed: () => _counter.value++,
          child: const Text('Increment'),
        ),
      ],
    );
  }
}
```

### 4.7 Isolates for Heavy Computation

```dart
import 'dart:isolate';

// INCORRECT: Blocking main thread
Future<List<Product>> parseProducts(String jsonString) async {
  // This runs on main thread, blocks UI!
  final data = jsonDecode(jsonString) as List;
  return data.map((e) => Product.fromJson(e)).toList();
}

// CORRECT: Using Isolate for heavy work
Future<List<Product>> parseProductsInBackground(String jsonString) async {
  return await Isolate.run(() {
    final data = jsonDecode(jsonString) as List;
    return data.map((e) => Product.fromJson(e)).toList();
  });
}

// For compute-heavy operations
Future<Image> processImage(Uint8List imageData) async {
  return await Isolate.run(() {
    // Heavy image processing
    return processedImage;
  });
}

// Using compute helper
Future<List<Product>> parseProducts(String jsonString) async {
  return await compute(_parseProducts, jsonString);
}

List<Product> _parseProducts(String jsonString) {
  final data = jsonDecode(jsonString) as List;
  return data.map((e) => Product.fromJson(e)).toList();
}
```

### 4.8 Image Optimization

```dart
// Use modern formats and caching
CachedNetworkImage(
  imageUrl: product.imageUrl,
  // Use WebP format from server
  placeholder: (context, url) => const ShimmerPlaceholder(),
  errorWidget: (context, url, error) => const Icon(Icons.error),
  // Optimize memory
  memCacheWidth: 300,
  memCacheHeight: 300,
  // Fade animation
  fadeInDuration: const Duration(milliseconds: 200),
)

// Preload images that will be needed
Future<void> precacheImages(BuildContext context) async {
  await precacheImage(
    const AssetImage('assets/images/hero.webp'),
    context,
  );
}

// Use SVG for icons and simple graphics
SvgPicture.asset(
  'assets/icons/cart.svg',
  width: 24,
  height: 24,
)

// Proper image sizing
Image.network(
  imageUrl,
  width: 200, // Specify dimensions
  height: 200,
  fit: BoxFit.cover,
  cacheWidth: 200, // Cache at display size
  cacheHeight: 200,
)
```

### 4.9 Environment Variables for Tree Shaking

```dart
// Use compile-time constants for tree shaking
// lib/core/config/environment.dart

class Environment {
  // These are resolved at compile time
  static const bool isProduction = bool.fromEnvironment(
    'IS_PRODUCTION',
    defaultValue: false,
  );

  static const String apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://dev.api.example.com',
  );

  static const bool enableAnalytics = bool.fromEnvironment(
    'ENABLE_ANALYTICS',
    defaultValue: false,
  );
}

// Build with environment variables
// flutter build apk --dart-define=IS_PRODUCTION=true --dart-define=API_URL=https://api.example.com

// Tree shaking removes dead code
void main() {
  if (Environment.isProduction) {
    // This code is removed in dev builds
    initializeProductionServices();
  } else {
    // This code is removed in production builds
    initializeDevTools();
  }
}
```

### 4.10 Controller Disposal

```dart
// CRITICAL: Always dispose controllers
class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final ScrollController _scrollController;
  late final AnimationController _animationController;
  late final StreamController<String> _streamController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _streamController = StreamController<String>();
  }

  @override
  void dispose() {
    // ALWAYS dispose in reverse order of creation
    _streamController.close();
    _animationController.dispose();
    _scrollController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextField(controller: _nameController),
          TextField(controller: _emailController),
        ],
      ),
    );
  }
}
```

### 4.11 DevTools Performance Monitoring

```dart
// Enable performance overlay in debug
MaterialApp(
  showPerformanceOverlay: kDebugMode,
)

// Use Timeline for custom measurements
import 'dart:developer';

Future<void> fetchProducts() async {
  Timeline.startSync('fetchProducts');
  try {
    final products = await repository.getProducts();
    Timeline.instantSync('productsLoaded', arguments: {
      'count': products.length,
    });
    return products;
  } finally {
    Timeline.finishSync();
  }
}

// Profile specific code sections
void expensiveOperation() {
  Timeline.startSync('expensiveOperation');

  Timeline.startSync('phase1');
  // Phase 1 code
  Timeline.finishSync();

  Timeline.startSync('phase2');
  // Phase 2 code
  Timeline.finishSync();

  Timeline.finishSync();
}
```

### 4.12 Skeleton UI Implementation

```dart
// Shimmer loading placeholder
class ProductListSkeleton extends StatelessWidget {
  const ProductListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) => const ProductCardSkeleton(),
      ),
    );
  }
}

class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              color: Colors.white,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 100,
                    height: 16,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Usage in BLoC consumer
BlocBuilder<ProductsBloc, ProductsState>(
  builder: (context, state) {
    return switch (state) {
      ProductsLoading() => const ProductListSkeleton(),
      ProductsLoaded(:final products) => ProductList(products: products),
      ProductsError(:final message) => ErrorWidget(message: message),
      _ => const SizedBox.shrink(),
    };
  },
)
```

---

## 5. Verification Checklist

### Widget Optimization
- [ ] `const` constructors used wherever possible
- [ ] `Container` only used when 3+ properties needed
- [ ] `SizedBox.shrink()` used for empty space
- [ ] Rebuilds isolated to leaf widgets
- [ ] StatelessWidget preferred over StatefulWidget

### List Performance
- [ ] `ListView.builder` used for dynamic lists
- [ ] `GridView.builder` used for grids
- [ ] No `shrinkWrap: true` with builders
- [ ] `itemExtent` specified when items have fixed height

### Resource Management
- [ ] All controllers disposed in `dispose()`
- [ ] Streams closed properly
- [ ] Subscriptions cancelled
- [ ] Isolates used for heavy computation

### Images
- [ ] Modern formats used (WebP, SVG)
- [ ] Image caching implemented
- [ ] Proper sizing with `cacheWidth`/`cacheHeight`
- [ ] Placeholder/error widgets provided

### Build Configuration
- [ ] Environment variables for tree shaking
- [ ] Debug code removed in production
- [ ] Performance overlay enabled in debug

### Monitoring
- [ ] DevTools profiling performed
- [ ] Timeline markers added for critical paths
- [ ] Performance metrics tracked

---

## 6. Importance of Defining at Project Start

### Why It Cannot Wait

1. **Performance debt compounds**: Each unoptimized widget adds to the problem. After 100 screens, optimization is overwhelming.

2. **Architecture affects performance**: Early decisions about state management and widget structure determine performance ceiling.

3. **User habits form fast**: Users who experience poor performance early don't come back.

4. **Testing infrastructure**: Performance testing should be part of CI/CD from day one.

5. **Resource patterns**: Disposal patterns must be established early to prevent memory leaks.

### Consequences of Not Doing It

| Problem | Consequence |
|---------|-------------|
| No const widgets | Unnecessary rebuilds, janky UI |
| shrinkWrap with builders | All items built immediately, slow scrolling |
| Heavy work on main thread | UI freezes, ANR errors |
| No controller disposal | Memory leaks, app crashes |
| Large images | Slow loading, high memory usage |

---

## 7. Technical Interview Questions - Senior Flutter

### Question 1: Widget Rebuilds
**Interviewer:** "How do you minimize unnecessary widget rebuilds in Flutter?"

**Expected Answer:**
```
I use several strategies to minimize rebuilds:

1. **const constructors**: Mark widgets and their parameters as const when
   possible. Const widgets are compile-time constants and never rebuild.

2. **Isolate state**: Push stateful logic down to leaf widgets. A counter
   change shouldn't rebuild the entire screen, just the counter widget.

3. **Builder patterns**: Use ValueListenableBuilder, BlocBuilder with
   buildWhen, and similar patterns to rebuild only what changed.

4. **Widget keys**: Use keys strategically to help Flutter identify which
   widgets actually changed vs just moved.

5. **const child parameter**: In AnimatedBuilder and similar, pass const
   widgets as child to prevent them from rebuilding during animation.

6. **Selector patterns**: In BLoC, use Selector to listen to specific
   parts of state, not the entire state object.

Example:
BlocSelector<ProductsBloc, ProductsState, int>(
  selector: (state) => state.itemCount,
  builder: (context, count) => Text('Items: $count'),
)

Only rebuilds when itemCount changes, not on any state change.
```

### Question 2: List Performance
**Interviewer:** "What's the difference between ListView and ListView.builder and when would you use each?"

**Expected Answer:**
```
The key difference is lazy loading:

**ListView (with children)**:
- Builds ALL children immediately
- Holds all widgets in memory
- Good for: Small, fixed lists (< 20 items)
- Example: Settings page with 10 options

**ListView.builder**:
- Builds items lazily as they scroll into view
- Only keeps visible items (+buffer) in memory
- Good for: Long or dynamic lists
- Example: Product catalog with 1000+ items

Performance implications:
- ListView with 1000 items: Creates 1000 widgets immediately (slow, high memory)
- ListView.builder with 1000 items: Creates ~15 visible widgets (fast, low memory)

Critical pitfall - shrinkWrap:
ListView.builder(shrinkWrap: true) defeats lazy loading because Flutter
needs to know total height, so it builds ALL items. Solutions:
- Give explicit height
- Use Expanded/Flexible
- Use SliverList in CustomScrollView

Additional optimization:
- Set itemExtent if all items have same height
- Use addAutomaticKeepAlives: false if items can be recycled
- Implement itemBuilder to return const widgets when possible
```

### Question 3: Memory Management
**Interviewer:** "How do you prevent memory leaks in Flutter?"

**Expected Answer:**
```
Memory leaks in Flutter typically come from undisposed resources:

1. **Controller disposal**: Always dispose in the dispose() method
   - TextEditingController
   - ScrollController
   - AnimationController
   - PageController

2. **Stream subscriptions**: Cancel in dispose()
   late StreamSubscription _subscription;

   @override
   void dispose() {
     _subscription.cancel();
     super.dispose();
   }

3. **BLoC subscriptions**: Use BlocListener which auto-disposes, or
   manually close BLoCs you create

4. **Focus nodes**: Dispose FocusNode instances

5. **Timers**: Cancel periodic timers

6. **Avoid closure captures**: Be careful with closures that capture
   BuildContext or State objects in async callbacks

7. **Image cache**: Clear image cache if loading many large images
   imageCache.clear();
   imageCache.clearLiveImages();

8. **DevTools monitoring**: Use Memory tab in DevTools to:
   - Check for retained objects
   - Track allocations
   - Find leak sources

Pattern I follow:
- Initialize in initState
- Dispose in reverse order in dispose
- Document any cleanup requirements in widget docs
```

### Question 4: Heavy Computation
**Interviewer:** "How do you handle CPU-intensive tasks in Flutter?"

**Expected Answer:**
```
Flutter's UI runs on the main isolate. Heavy computation blocks UI,
causing jank. Solutions:

1. **Isolate.run** (Dart 2.19+):
   final result = await Isolate.run(() {
     return expensiveOperation(data);
   });

2. **compute** helper (older approach):
   final result = await compute(expensiveFunction, data);

3. **Long-running isolates** for ongoing work:
   - Use Isolate.spawn for persistent workers
   - Communicate via SendPort/ReceivePort

4. **Worker packages**: flutter_isolate, worker_manager for
   more complex scenarios

Rules of thumb:
- > 16ms work? Consider isolate
- JSON parsing large payloads? Use isolate
- Image processing? Always isolate
- Crypto operations? Always isolate

Limitations:
- Can't pass UI objects to isolates
- Data must be serializable
- Overhead for small operations (not worth it for < 5ms work)

Example:
Future<List<Product>> parseProducts(String json) async {
  if (json.length > 100000) {
    // Large payload - use isolate
    return await Isolate.run(() => _parseJson(json));
  }
  // Small payload - main thread is fine
  return _parseJson(json);
}
```

### Question 5: Performance Profiling
**Interviewer:** "How do you identify and fix performance issues in Flutter?"

**Expected Answer:**
```
My performance debugging workflow:

1. **Visual indicators**:
   - Enable performance overlay (showPerformanceOverlay: true)
   - Watch for red bars (jank) in the overlay
   - Check frame rendering times

2. **DevTools Performance tab**:
   - Record frame timeline
   - Identify slow frames (> 16ms)
   - Check build, layout, paint phases
   - Look for excessive rebuilds

3. **DevTools Memory tab**:
   - Check for memory growth over time
   - Identify retained objects
   - Find memory leaks

4. **Timeline markers**:
   Timeline.startSync('operation');
   // Code
   Timeline.finishSync();

5. **Widget rebuild debugging**:
   - Add debugPrint in build methods
   - Use DevTools widget rebuild counts
   - Check for unexpected rebuilds

6. **Profile mode testing**:
   flutter run --profile (not debug)
   Debug mode has different characteristics

Common findings and fixes:
- Excessive rebuilds -> Add const, use selectors
- Long frame times -> Move to isolate
- Memory growth -> Check disposal
- Slow list scrolling -> Use builder, remove shrinkWrap
- Image memory -> Add cacheWidth/cacheHeight
```

### Question 6: Real Challenge Solved
**Interviewer:** "Tell me about a performance issue you've solved"

**Expected Answer:**
```
In an e-commerce app, users complained about slow, janky scrolling
in the product catalog:

Investigation:
1. Enabled performance overlay - saw consistent red frames
2. DevTools showed build times of 30-50ms per frame
3. Found ListView (not builder) with 500+ products
4. Each ProductCard built complex widget tree
5. Images were full resolution, no caching

Root causes:
- Non-lazy list building all 500 cards
- No const constructors
- High-resolution images
- Entire page rebuilt on filter change

Solutions implemented:
1. Changed to ListView.builder
2. Added const to all static widgets
3. Implemented CachedNetworkImage with sizing
4. Isolated filter state to separate widget
5. Added shimmer loading skeleton

Code changes:
// Before
ListView(children: products.map(ProductCard.new).toList())

// After
ListView.builder(
  itemCount: products.length,
  itemExtent: 120, // Fixed height optimization
  itemBuilder: (_, i) => ProductCard(product: products[i]),
)

Results:
- Frame time: 50ms -> 8ms
- Memory usage: 400MB -> 150MB
- User complaints: Eliminated
- App store rating: 3.2 -> 4.4
```

---

## 8. Anti-Patterns to Avoid

### 8.1 Using Container Unnecessarily
```dart
// INCORRECT
Container() // Empty container for spacing
Container(width: 100, height: 100) // Just sizing

// CORRECT
const SizedBox.shrink() // Empty space
const SizedBox(width: 100, height: 100) // Sizing
```

### 8.2 shrinkWrap with Builders
```dart
// INCORRECT: Defeats lazy loading
ListView.builder(
  shrinkWrap: true, // Builds all items!
  itemCount: 1000,
  itemBuilder: (_, i) => Item(i),
)

// CORRECT: Use proper constraints
SizedBox(
  height: 400,
  child: ListView.builder(
    itemCount: 1000,
    itemBuilder: (_, i) => Item(i),
  ),
)
```

### 8.3 Rebuilding Entire Tree
```dart
// INCORRECT: Counter change rebuilds everything
class Page extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Count: $counter'), // Needs counter
        ExpensiveWidget(), // Doesn't need counter, but rebuilds!
      ],
    );
  }
}

// CORRECT: Isolate the changing part
class Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CounterText(), // Has its own state
        const ExpensiveWidget(), // Never rebuilds
      ],
    );
  }
}
```

---

## 9. Additional Resources

### Official Documentation
- [Flutter Performance Best Practices](https://docs.flutter.dev/perf)
- [DevTools Performance View](https://docs.flutter.dev/tools/devtools/performance)
- [Flutter Profiling](https://docs.flutter.dev/perf/ui-performance)

### Tools
- Flutter DevTools
- Android Profiler
- Xcode Instruments
- Firebase Performance Monitoring

### Project References
- Alexandria: Performance & Profiling - Flutter
- Alexandria: Performance monitor - Flutter

---

## 10. Compliance Evidence

To validate compliance with this requirement, document:

| Evidence | Description |
|----------|-------------|
| DevTools recording | Frame timeline showing 60 FPS |
| Memory profile | No memory leaks over time |
| Lighthouse/Performance audit | App size and load time metrics |
| Performance test results | Automated performance tests |

---

**Last update:** December 2024
**Author:** Architecture Team
**Version:** 1.0.0
