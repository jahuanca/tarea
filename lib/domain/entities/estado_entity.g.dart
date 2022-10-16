// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'estado_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EstadoEntityAdapter extends TypeAdapter<EstadoEntity> {
  @override
  final int typeId = 33;

  @override
  EstadoEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EstadoEntity(
      idestado: fields[0] as int,
      detalle: fields[1] as String,
      estado: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, EstadoEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.idestado)
      ..writeByte(1)
      ..write(obj.detalle)
      ..writeByte(2)
      ..write(obj.estado);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EstadoEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
