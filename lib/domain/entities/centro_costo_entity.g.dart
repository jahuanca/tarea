// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'centro_costo_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CentroCostoEntityAdapter extends TypeAdapter<CentroCostoEntity> {
  @override
  final int typeId = 10;

  @override
  CentroCostoEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CentroCostoEntity(
      idcentrocosto: fields[0] as int,
      detallecentrocosto: fields[1] as String,
      idsociedad: fields[2] as int,
      idtipocentrocosto: fields[3] as int,
      homologacion: fields[4] as String,
      activo: fields[5] as bool,
      fechamod: fields[6] as DateTime,
      idusuario: fields[7] as int,
      codigoempresa: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CentroCostoEntity obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.idcentrocosto)
      ..writeByte(1)
      ..write(obj.detallecentrocosto)
      ..writeByte(2)
      ..write(obj.idsociedad)
      ..writeByte(3)
      ..write(obj.idtipocentrocosto)
      ..writeByte(4)
      ..write(obj.homologacion)
      ..writeByte(5)
      ..write(obj.activo)
      ..writeByte(6)
      ..write(obj.fechamod)
      ..writeByte(7)
      ..write(obj.idusuario)
      ..writeByte(8)
      ..write(obj.codigoempresa);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CentroCostoEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
