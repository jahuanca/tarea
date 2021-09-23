// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LogEntityAdapter extends TypeAdapter<LogEntity> {
  @override
  final int typeId = 8;

  @override
  LogEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LogEntity(
      id: fields[0] as int,
      version: fields[1] as String,
      fecha: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, LogEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.version)
      ..writeByte(2)
      ..write(obj.fecha);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LogEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
