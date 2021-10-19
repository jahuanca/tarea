// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pre_tareo_proceso_uva_detalle_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PreTareoProcesoUvaDetalleEntityAdapter
    extends TypeAdapter<PreTareoProcesoUvaDetalleEntity> {
  @override
  final int typeId = 20;

  @override
  PreTareoProcesoUvaDetalleEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PreTareoProcesoUvaDetalleEntity(
      itempretareoprocesouvadetalle: fields[0] as int,
      itempretareaprocesouva: fields[1] as int,
      codigoempresa: fields[2] as String,
      hora: fields[3] as DateTime,
      numcaja: fields[4] as int,
      imei: fields[5] as String,
      fecha: fields[6] as DateTime,
      idestado: fields[7] as int,
      idusuario: fields[8] as int,
      personal: fields[9] as PersonalEmpresaEntity,
      codigotk: fields[10] as String,
      labor: fields[15] as LaborEntity,
      actividad: fields[14] as ActividadEntity,
      presentacion: fields[16] as PresentacionLineaEntity,
      idactividad: fields[12] as int,
      idlabor: fields[11] as int,
    )..idpresentacion = fields[13] as int;
  }

  @override
  void write(BinaryWriter writer, PreTareoProcesoUvaDetalleEntity obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.itempretareoprocesouvadetalle)
      ..writeByte(1)
      ..write(obj.itempretareaprocesouva)
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
      ..write(obj.codigotk)
      ..writeByte(11)
      ..write(obj.idlabor)
      ..writeByte(12)
      ..write(obj.idactividad)
      ..writeByte(13)
      ..write(obj.idpresentacion)
      ..writeByte(14)
      ..write(obj.actividad)
      ..writeByte(15)
      ..write(obj.labor)
      ..writeByte(16)
      ..write(obj.presentacion);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PreTareoProcesoUvaDetalleEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
