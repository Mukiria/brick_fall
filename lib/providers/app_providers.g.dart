// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$gameLoopHash() => r'13b312d4c5178599893940f1ab95fbe9f99f86a9';

/// See also [gameLoop].
@ProviderFor(gameLoop)
final gameLoopProvider = AutoDisposeProvider<engine.GameLoop>.internal(
  gameLoop,
  name: r'gameLoopProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$gameLoopHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GameLoopRef = AutoDisposeProviderRef<engine.GameLoop>;
String _$gameEngineHash() => r'36f548f6e28159d8ac7b23239be71ce90be61813';

/// See also [gameEngine].
@ProviderFor(gameEngine)
final gameEngineProvider = AutoDisposeProvider<engine.GameEngine>.internal(
  gameEngine,
  name: r'gameEngineProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$gameEngineHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GameEngineRef = AutoDisposeProviderRef<engine.GameEngine>;
String _$audioServiceHash() => r'b744f27739274a3510a5898a2794b09ac07c7ee6';

/// See also [audioService].
@ProviderFor(audioService)
final audioServiceProvider = AutoDisposeProvider<AudioService>.internal(
  audioService,
  name: r'audioServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$audioServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AudioServiceRef = AutoDisposeProviderRef<AudioService>;
String _$storageServiceHash() => r'a6d23bc030486b6d1106efa40d3a7733b6bf906f';

/// See also [storageService].
@ProviderFor(storageService)
final storageServiceProvider = AutoDisposeProvider<StorageService>.internal(
  storageService,
  name: r'storageServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$storageServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StorageServiceRef = AutoDisposeProviderRef<StorageService>;
String _$settingsHash() => r'0146dbede2f2a5c01ce2d24e95729c6a60de2ad2';

/// See also [settings].
@ProviderFor(settings)
final settingsProvider = AutoDisposeFutureProvider<models.Settings>.internal(
  settings,
  name: r'settingsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$settingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SettingsRef = AutoDisposeFutureProviderRef<models.Settings>;
String _$statisticsHash() => r'849c76ce7859ac2ae6434ad539a8a0de02369581';

/// See also [statistics].
@ProviderFor(statistics)
final statisticsProvider =
    AutoDisposeFutureProvider<models.Statistics>.internal(
  statistics,
  name: r'statisticsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$statisticsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StatisticsRef = AutoDisposeFutureProviderRef<models.Statistics>;
String _$gameStateNotifierHash() => r'34d3706371ff28be65857a65d0ea374e9f0aae51';

/// See also [GameStateNotifier].
@ProviderFor(GameStateNotifier)
final gameStateNotifierProvider =
    AutoDisposeNotifierProvider<GameStateNotifier, engine.GameState>.internal(
  GameStateNotifier.new,
  name: r'gameStateNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$gameStateNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GameStateNotifier = AutoDisposeNotifier<engine.GameState>;
String _$settingsNotifierHash() => r'cbf7a485a63c4d9a79b4144f24e908c53dc9fa0e';

/// See also [SettingsNotifier].
@ProviderFor(SettingsNotifier)
final settingsNotifierProvider = AutoDisposeAsyncNotifierProvider<
    SettingsNotifier, models.Settings>.internal(
  SettingsNotifier.new,
  name: r'settingsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$settingsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SettingsNotifier = AutoDisposeAsyncNotifier<models.Settings>;
String _$statisticsNotifierHash() =>
    r'b02b2b4fe20b9471cc09cd8b047e5772c8da1350';

/// See also [StatisticsNotifier].
@ProviderFor(StatisticsNotifier)
final statisticsNotifierProvider = AutoDisposeAsyncNotifierProvider<
    StatisticsNotifier, models.Statistics>.internal(
  StatisticsNotifier.new,
  name: r'statisticsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$statisticsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$StatisticsNotifier = AutoDisposeAsyncNotifier<models.Statistics>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
