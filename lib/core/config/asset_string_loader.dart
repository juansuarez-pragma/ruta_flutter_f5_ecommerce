import 'package:flutter/services.dart';

/// Abstraction for loading text assets to avoid hard dependencies on [rootBundle].
abstract interface class AssetStringLoader {
  Future<String> loadString(String key);
}

/// Production implementation of [AssetStringLoader] backed by [rootBundle].
final class RootBundleAssetStringLoader implements AssetStringLoader {
  const RootBundleAssetStringLoader();

  @override
  Future<String> loadString(String key) => rootBundle.loadString(key);
}

