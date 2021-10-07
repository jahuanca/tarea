// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'presentacion_linea_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PresentacionLineaEntityAdapter
    extends TypeAdapter<PresentacionLineaEntity> {
  @override
  final int typeId = 16;

  @override
  PresentacionLineaEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PresentacionLineaEntity(
      idpresentacion: fields[0] as int,
      descripcion: fields[1] as String,
      codigoempresa: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PresentacionLineaEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.idpresentacion)
      ..writeByte(1)
      ..write(obj.descripcion)
      ..writeByte(2)
      ..write(obj.codigoempresa);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PresentacionLineaEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
