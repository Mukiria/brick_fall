// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameStateAdapter extends TypeAdapter<GameState> {
  @override
  final int typeId = 2;

  @override
  GameState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameState(
      grid: (fields[0] as List)
          .map((dynamic e) => (e as List).cast<bool>())
          .toList(),
      gridColors: (fields[1] as List)
          .map((dynamic e) => (e as List).cast<int>())
          .toList(),
      currentBrick: fields[2] as Brick?,
      nextBrick: fields[3] as Brick?,
      heldBrick: fields[4] as Brick?,
      canHold: fields[5] as bool,
      score: fields[6] as int,
      level: fields[7] as int,
      linesCleared: fields[8] as int,
      totalLinesCleared: fields[9] as int,
      combo: fields[10] as int,
      state: fields[11] as CoreGameState,
      startTime: fields[12] as DateTime?,
      elapsedTime: fields[13] as Duration,
      difficulty: fields[14] as Difficulty,
      highScore: fields[15] as int,
    );
  }

  @override
  void write(BinaryWriter writer, GameState obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.grid)
      ..writeByte(1)
      ..write(obj.gridColors)
      ..writeByte(2)
      ..write(obj.currentBrick)
      ..writeByte(3)
      ..write(obj.nextBrick)
      ..writeByte(4)
      ..write(obj.heldBrick)
      ..writeByte(5)
      ..write(obj.canHold)
      ..writeByte(6)
      ..write(obj.score)
      ..writeByte(7)
      ..write(obj.level)
      ..writeByte(8)
      ..write(obj.linesCleared)
      ..writeByte(9)
      ..write(obj.totalLinesCleared)
      ..writeByte(10)
      ..write(obj.combo)
      ..writeByte(11)
      ..write(obj.state)
      ..writeByte(12)
      ..write(obj.startTime)
      ..writeByte(13)
      ..write(obj.elapsedTime)
      ..writeByte(14)
      ..write(obj.difficulty)
      ..writeByte(15)
      ..write(obj.highScore);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
