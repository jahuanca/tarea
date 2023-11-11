// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asistencia_ubicacion_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AsistenciaUbicacionEntityAdapter
    extends TypeAdapter<AsistenciaUbicacionEntity> {
  @override
  final int typeId = 37;

  @override
  AsistenciaUbicacionEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AsistenciaUbicacionEntity(
      idubicacion: fields[0] as int,
      ubicacion: fields[1] as String,
      detallebreve: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AsistenciaUbicacionEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.idubicacion)
      ..writeByte(1)
      ..write(obj.ubicacion)
      ..writeByte(2)
      ..write(obj.detallebreve);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AsistenciaUbicacionEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
