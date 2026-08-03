import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';

part 'settings.g.dart';

@HiveType(typeId: 4)
class Settings extends Equatable {
  @HiveField(0)
  final bool soundEnabled;

  @HiveField(1)
  final bool musicEnabled;

  @HiveField(2)
  final double soundVolume;

  @HiveField(3)
  final double musicVolume;

  @HiveField(4)
  final bool vibrationEnabled;

  @HiveField(5)
  final bool ghostPieceEnabled;

  @HiveField(6)
  final bool gridEnabled;

  @HiveField(7)
  final bool nextPieceEnabled;

  @HiveField(8)
  final bool holdPieceEnabled;

  @HiveField(9)
  final int touchSensitivity;

  @HiveField(10)
  final bool leftHandedMode;

  @HiveField(11)
  final int themeModeIndex;

  @HiveField(12)
  final Difficulty defaultDifficulty;

  @HiveField(13)
  final bool autoPause;

  @HiveField(14)
  final bool showFPS;

  const Settings({
    this.soundEnabled = true,
    this.musicEnabled = true,
    this.soundVolume = 1.0,
    this.musicVolume = 0.7,
    this.vibrationEnabled = true,
    this.ghostPieceEnabled = true,
    this.gridEnabled = true,
    this.nextPieceEnabled = true,
    this.holdPieceEnabled = true,
    this.touchSensitivity = 50,
    this.leftHandedMode = false,
    this.themeModeIndex = 0,
    this.defaultDifficulty = Difficulty.normal,
    this.autoPause = true,
    this.showFPS = false,
  });

  ThemeMode get themeMode => ThemeMode.values[themeModeIndex.clamp(0, ThemeMode.values.length - 1)];

  factory Settings.defaultSettings() => const Settings();

  Settings copyWith({
    bool? soundEnabled,
    bool? musicEnabled,
    double? soundVolume,
    double? musicVolume,
    bool? vibrationEnabled,
    bool? ghostPieceEnabled,
    bool? gridEnabled,
    bool? nextPieceEnabled,
    bool? holdPieceEnabled,
    int? touchSensitivity,
    bool? leftHandedMode,
    ThemeMode? themeMode,
    int? themeModeIndex,
    Difficulty? defaultDifficulty,
    bool? autoPause,
    bool? showFPS,
  }) {
    return Settings(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      soundVolume: soundVolume ?? this.soundVolume,
      musicVolume: musicVolume ?? this.musicVolume,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      ghostPieceEnabled: ghostPieceEnabled ?? this.ghostPieceEnabled,
      gridEnabled: gridEnabled ?? this.gridEnabled,
      nextPieceEnabled: nextPieceEnabled ?? this.nextPieceEnabled,
      holdPieceEnabled: holdPieceEnabled ?? this.holdPieceEnabled,
      touchSensitivity: touchSensitivity ?? this.touchSensitivity,
      leftHandedMode: leftHandedMode ?? this.leftHandedMode,
      themeModeIndex: themeModeIndex ?? (themeMode?.index ?? this.themeModeIndex),
      defaultDifficulty: defaultDifficulty ?? this.defaultDifficulty,
      autoPause: autoPause ?? this.autoPause,
      showFPS: showFPS ?? this.showFPS,
    );
  }

  @override
  List<Object?> get props => [
    soundEnabled,
    musicEnabled,
    soundVolume,
    musicVolume,
    vibrationEnabled,
    ghostPieceEnabled,
    gridEnabled,
    nextPieceEnabled,
    holdPieceEnabled,
    touchSensitivity,
    leftHandedMode,
    themeModeIndex,
    defaultDifficulty,
    autoPause,
    showFPS,
  ];
}