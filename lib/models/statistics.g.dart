// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StatisticsAdapter extends TypeAdapter<Statistics> {
  @override
  final int typeId = 3;

  @override
  Statistics read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Statistics(
      gamesPlayed: fields[0] as int,
      totalScore: fields[1] as int,
      highScore: fields[2] as int,
      totalLinesCleared: fields[3] as int,
      maxLevelReached: fields[4] as int,
      totalPlayTime: fields[5] as Duration,
      brickCounts: (fields[6] as Map).cast<String, int>(),
      difficultyGamesPlayed: (fields[7] as Map).cast<String, int>(),
      difficultyHighScores: (fields[8] as Map).cast<String, int>(),
      lastPlayed: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Statistics obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.gamesPlayed)
      ..writeByte(1)
      ..write(obj.totalScore)
      ..writeByte(2)
      ..write(obj.highScore)
      ..writeByte(3)
      ..write(obj.totalLinesCleared)
      ..writeByte(4)
      ..write(obj.maxLevelReached)
      ..writeByte(5)
      ..write(obj.totalPlayTime)
      ..writeByte(6)
      ..write(obj.brickCounts)
      ..writeByte(7)
      ..write(obj.difficultyGamesPlayed)
      ..writeByte(8)
      ..write(obj.difficultyHighScores)
      ..writeByte(9)
      ..write(obj.lastPlayed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatisticsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
