// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_constants.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CoreGameStateAdapter extends TypeAdapter<CoreGameState> {
  @override
  final int typeId = 5;

  @override
  CoreGameState read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CoreGameState.idle;
      case 1:
        return CoreGameState.playing;
      case 2:
        return CoreGameState.paused;
      case 3:
        return CoreGameState.gameOver;
      case 4:
        return CoreGameState.levelComplete;
      default:
        return CoreGameState.idle;
    }
  }

  @override
  void write(BinaryWriter writer, CoreGameState obj) {
    switch (obj) {
      case CoreGameState.idle:
        writer.writeByte(0);
        break;
      case CoreGameState.playing:
        writer.writeByte(1);
        break;
      case CoreGameState.paused:
        writer.writeByte(2);
        break;
      case CoreGameState.gameOver:
        writer.writeByte(3);
        break;
      case CoreGameState.levelComplete:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoreGameStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BrickTypeAdapter extends TypeAdapter<BrickType> {
  @override
  final int typeId = 6;

  @override
  BrickType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BrickType.i;
      case 1:
        return BrickType.j;
      case 2:
        return BrickType.l;
      case 3:
        return BrickType.o;
      case 4:
        return BrickType.s;
      case 5:
        return BrickType.t;
      case 6:
        return BrickType.z;
      default:
        return BrickType.i;
    }
  }

  @override
  void write(BinaryWriter writer, BrickType obj) {
    switch (obj) {
      case BrickType.i:
        writer.writeByte(0);
        break;
      case BrickType.j:
        writer.writeByte(1);
        break;
      case BrickType.l:
        writer.writeByte(2);
        break;
      case BrickType.o:
        writer.writeByte(3);
        break;
      case BrickType.s:
        writer.writeByte(4);
        break;
      case BrickType.t:
        writer.writeByte(5);
        break;
      case BrickType.z:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrickTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DirectionAdapter extends TypeAdapter<Direction> {
  @override
  final int typeId = 7;

  @override
  Direction read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Direction.left;
      case 1:
        return Direction.right;
      case 2:
        return Direction.down;
      case 3:
        return Direction.rotate;
      case 4:
        return Direction.drop;
      default:
        return Direction.left;
    }
  }

  @override
  void write(BinaryWriter writer, Direction obj) {
    switch (obj) {
      case Direction.left:
        writer.writeByte(0);
        break;
      case Direction.right:
        writer.writeByte(1);
        break;
      case Direction.down:
        writer.writeByte(2);
        break;
      case Direction.rotate:
        writer.writeByte(3);
        break;
      case Direction.drop:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DirectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DifficultyAdapter extends TypeAdapter<Difficulty> {
  @override
  final int typeId = 8;

  @override
  Difficulty read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Difficulty.easy;
      case 1:
        return Difficulty.normal;
      case 2:
        return Difficulty.hard;
      case 3:
        return Difficulty.expert;
      default:
        return Difficulty.easy;
    }
  }

  @override
  void write(BinaryWriter writer, Difficulty obj) {
    switch (obj) {
      case Difficulty.easy:
        writer.writeByte(0);
        break;
      case Difficulty.normal:
        writer.writeByte(1);
        break;
      case Difficulty.hard:
        writer.writeByte(2);
        break;
      case Difficulty.expert:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DifficultyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
