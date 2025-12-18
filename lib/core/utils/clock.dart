/// Abstraction for time retrieval to avoid hard dependencies on [DateTime.now].
abstract interface class Clock {
  DateTime now();
}

/// Production implementation of [Clock].
final class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now();
}

