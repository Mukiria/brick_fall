// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$gameLoopHash() => r'9204b43de0c06cab6c6a068e20e7d98517b7314a';

/// See also [gameLoop].
@ProviderFor(gameLoop)
final gameLoopProvider = AutoDisposeProvider<GameLoop>.internal(
  gameLoop,
  name: r'gameLoopProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$gameLoopHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GameLoopRef = AutoDisposeProviderRef<GameLoop>;
String _$gameEngineHash() => r'982ad0977b5fef5802553ae7f1b96a3a6f97d33e';

/// See also [gameEngine].
@ProviderFor(gameEngine)
final gameEngineProvider = AutoDisposeProvider<GameEngine>.internal(
  gameEngine,
  name: r'gameEngineProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$gameEngineHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GameEngineRef = AutoDisposeProviderRef<GameEngine>;
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
String _$settingsHash() => r'10e076be871e45568785e10052f79f198e1fe557';

/// See also [settings].
@ProviderFor(settings)
final settingsProvider = AutoDisposeFutureProvider<Settings>.internal(
  settings,
  name: r'settingsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$settingsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SettingsRef = AutoDisposeFutureProviderRef<Settings>;
String _$statisticsHash() => r'cdda25ab150e260849368558f0b5ce43878a616f';

/// See also [statistics].
@ProviderFor(statistics)
final statisticsProvider = AutoDisposeFutureProvider<Statistics>.internal(
  statistics,
  name: r'statisticsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$statisticsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StatisticsRef = AutoDisposeFutureProviderRef<Statistics>;
String _$gameStateNotifierHash() => r'45b3a455b035432f3bcb205cf2c1713d7c8a5e74';

/// See also [GameStateNotifier].
@ProviderFor(GameStateNotifier)
final gameStateNotifierProvider =
    AutoDisposeNotifierProvider<GameStateNotifier, GameState>.internal(
  GameStateNotifier.new,
  name: r'gameStateNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$gameStateNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GameStateNotifier = AutoDisposeNotifier<GameState>;
String _$settingsNotifierHash() => r'11c432a8f6d7b2f07e132f0b83be3dffbf111e1a';

/// See also [SettingsNotifier].
@ProviderFor(SettingsNotifier)
final settingsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<SettingsNotifier, Settings>.internal(
  SettingsNotifier.new,
  name: r'settingsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$settingsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SettingsNotifier = AutoDisposeAsyncNotifier<Settings>;
String _$statisticsNotifierHash() =>
    r'35bea4fd2cf1d35f5e812dcb147a0fb8e361ed72';

/// See also [StatisticsNotifier].
@ProviderFor(StatisticsNotifier)
final statisticsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<StatisticsNotifier, Statistics>.internal(
  StatisticsNotifier.new,
  name: r'statisticsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$statisticsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$StatisticsNotifier = AutoDisposeAsyncNotifier<Statistics>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
