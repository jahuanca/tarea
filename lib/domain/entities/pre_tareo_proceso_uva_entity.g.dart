// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pre_tareo_proceso_uva_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PreTareoProcesoUvaEntityAdapter
    extends TypeAdapter<PreTareoProcesoUvaEntity> {
  @override
  final int typeId = 19;

  @override
  PreTareoProcesoUvaEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PreTareoProcesoUvaEntity(
      itempretareaprocesouva: fields[0] as int,
      fecha: fields[1] as DateTime,
      horainicio: fields[2] as DateTime,
      horafin: fields[3] as DateTime,
      pausainicio: fields[4] as DateTime,
      pausafin: fields[5] as DateTime,
      linea: fields[6] as int,
      idcentrocosto: fields[7] as int,
      codigoempresasupervisor: fields[8] as String,
      codigoempresadigitador: fields[9] as String,
      fechamod: fields[10] as DateTime,
      activo: fields[11] as bool,
      idusuario: fields[12] as int,
      detalles: (fields[13] as List)?.cast<PreTareoProcesoUvaDetalleEntity>(),
      centroCosto: fields[18] as CentroCostoEntity,
      presentacion: fields[23] as PresentacionLineaEntity,
      turnotareo: fields[19] as String,
      diasiguiente: fields[22] as bool,
      firmaSupervisor: fields[17] as String,
      idcultivo: fields[24] as int,
      cultivo: fields[25] as CultivoEntity,
      key: fields[26] as int,
    )
      ..sede = fields[14] as SubdivisionEntity
      ..pathUrl = fields[15] as String
      ..estadoLocal = fields[16] as String
      ..supervisor = fields[20] as PersonalEmpresaEntity
      ..digitador = fields[21] as PersonalEmpresaEntity;
  }

  @override
  void write(BinaryWriter writer, PreTareoProcesoUvaEntity obj) {
    writer
      ..writeByte(27)
      ..writeByte(0)
      ..write(obj.itempretareaprocesouva)
      ..writeByte(1)
      ..write(obj.fecha)
      ..writeByte(2)
      ..write(obj.horainicio)
      ..writeByte(3)
      ..write(obj.horafin)
      ..writeByte(4)
      ..write(obj.pausainicio)
      ..writeByte(5)
      ..write(obj.pausafin)
      ..writeByte(6)
      ..write(obj.linea)
      ..writeByte(7)
      ..write(obj.idcentrocosto)
      ..writeByte(8)
      ..write(obj.codigoempresasupervisor)
      ..writeByte(9)
      ..write(obj.codigoempresadigitador)
      ..writeByte(10)
      ..write(obj.fechamod)
      ..writeByte(11)
      ..write(obj.activo)
      ..writeByte(12)
      ..write(obj.idusuario)
      ..writeByte(13)
      ..write(obj.detalles)
      ..writeByte(14)
      ..write(obj.sede)
      ..writeByte(15)
      ..write(obj.pathUrl)
      ..writeByte(16)
      ..write(obj.estadoLocal)
      ..writeByte(17)
      ..write(obj.firmaSupervisor)
      ..writeByte(18)
      ..write(obj.centroCosto)
      ..writeByte(19)
      ..write(obj.turnotareo)
      ..writeByte(20)
      ..write(obj.supervisor)
      ..writeByte(21)
      ..write(obj.digitador)
      ..writeByte(22)
      ..write(obj.diasiguiente)
      ..writeByte(23)
      ..write(obj.presentacion)
      ..writeByte(24)
      ..write(obj.idcultivo)
      ..writeByte(25)
      ..write(obj.cultivo)
      ..writeByte(26)
      ..write(obj.key);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PreTareoProcesoUvaEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
