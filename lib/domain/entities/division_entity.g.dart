// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'division_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DivisionEntityAdapter extends TypeAdapter<DivisionEntity> {
  @override
  final int typeId = 11;

  @override
  DivisionEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DivisionEntity(
      iddivision: fields[0] as int,
      detalledivision: fields[1] as String,
      idsociedad: fields[2] as int,
      division: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DivisionEntity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.iddivision)
      ..writeByte(1)
      ..write(obj.detalledivision)
      ..writeByte(2)
      ..write(obj.idsociedad)
      ..writeByte(3)
      ..write(obj.division);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DivisionEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
