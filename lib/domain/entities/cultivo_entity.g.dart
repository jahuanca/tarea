// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cultivo_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CultivoEntityAdapter extends TypeAdapter<CultivoEntity> {
  @override
  final int typeId = 15;

  @override
  CultivoEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CultivoEntity(
      idcultivo: fields[1] as int,
      detallecultivo: fields[2] as String,
      cultivo: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CultivoEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.idcultivo)
      ..writeByte(2)
      ..write(obj.detallecultivo)
      ..writeByte(3)
      ..write(obj.cultivo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CultivoEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
