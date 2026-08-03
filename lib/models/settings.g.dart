// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsAdapter extends TypeAdapter<Settings> {
  @override
  final int typeId = 4;

  @override
  Settings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Settings(
      soundEnabled: fields[0] as bool,
      musicEnabled: fields[1] as bool,
      soundVolume: fields[2] as double,
      musicVolume: fields[3] as double,
      vibrationEnabled: fields[4] as bool,
      ghostPieceEnabled: fields[5] as bool,
      gridEnabled: fields[6] as bool,
      nextPieceEnabled: fields[7] as bool,
      holdPieceEnabled: fields[8] as bool,
      touchSensitivity: fields[9] as int,
      leftHandedMode: fields[10] as bool,
      themeModeIndex: fields[11] as int,
      defaultDifficulty: fields[12] as Difficulty,
      autoPause: fields[13] as bool,
      showFPS: fields[14] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Settings obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.soundEnabled)
      ..writeByte(1)
      ..write(obj.musicEnabled)
      ..writeByte(2)
      ..write(obj.soundVolume)
      ..writeByte(3)
      ..write(obj.musicVolume)
      ..writeByte(4)
      ..write(obj.vibrationEnabled)
      ..writeByte(5)
      ..write(obj.ghostPieceEnabled)
      ..writeByte(6)
      ..write(obj.gridEnabled)
      ..writeByte(7)
      ..write(obj.nextPieceEnabled)
      ..writeByte(8)
      ..write(obj.holdPieceEnabled)
      ..writeByte(9)
      ..write(obj.touchSensitivity)
      ..writeByte(10)
      ..write(obj.leftHandedMode)
      ..writeByte(11)
      ..write(obj.themeModeIndex)
      ..writeByte(12)
      ..write(obj.defaultDifficulty)
      ..writeByte(13)
      ..write(obj.autoPause)
      ..writeByte(14)
      ..write(obj.showFPS);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
