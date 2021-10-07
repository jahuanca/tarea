// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pre_tareo_proceso_detalle_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PreTareoProcesoDetalleEntityAdapter
    extends TypeAdapter<PreTareoProcesoDetalleEntity> {
  @override
  final int typeId = 18;

  @override
  PreTareoProcesoDetalleEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PreTareoProcesoDetalleEntity(
      item: fields[0] as int,
      itempretareaproceso: fields[1] as int,
      codigoempresa: fields[2] as String,
      hora: fields[3] as DateTime,
      numcaja: fields[4] as int,
      imei: fields[5] as String,
      fecha: fields[6] as DateTime,
      idestado: fields[7] as int,
      idusuario: fields[8] as int,
      personal: fields[9] as PersonalEmpresaEntity,
      codigotk: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PreTareoProcesoDetalleEntity obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.item)
      ..writeByte(1)
      ..write(obj.itempretareaproceso)
      ..writeByte(2)
      ..write(obj.codigoempresa)
      ..writeByte(3)
      ..write(obj.hora)
      ..writeByte(4)
      ..write(obj.numcaja)
      ..writeByte(5)
      ..write(obj.imei)
      ..writeByte(6)
      ..write(obj.fecha)
      ..writeByte(7)
      ..write(obj.idestado)
      ..writeByte(8)
      ..write(obj.idusuario)
      ..writeByte(9)
      ..write(obj.personal)
      ..writeByte(10)
      ..write(obj.codigotk);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PreTareoProcesoDetalleEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
