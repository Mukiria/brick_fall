// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brick.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BrickAdapter extends TypeAdapter<Brick> {
  @override
  final int typeId = 1;

  @override
  Brick read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Brick(
      type: fields[0] as BrickType,
      blocks: (fields[1] as List).cast<Position>(),
      pivot: fields[2] as Position,
      colorValue: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Brick obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.blocks)
      ..writeByte(2)
      ..write(obj.pivot)
      ..writeByte(3)
      ..write(obj.colorValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrickAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
