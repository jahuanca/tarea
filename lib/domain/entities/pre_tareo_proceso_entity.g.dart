// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pre_tareo_proceso_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PreTareoProcesoEntityAdapter extends TypeAdapter<PreTareoProcesoEntity> {
  @override
  final int typeId = 14;

  @override
  PreTareoProcesoEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PreTareoProcesoEntity(
      itempretareaproceso: fields[0] as int,
      fecha: fields[1] as DateTime,
      horainicio: fields[2] as DateTime,
      horafin: fields[3] as DateTime,
      pausainicio: fields[4] as DateTime,
      pausafin: fields[5] as DateTime,
      linea: fields[6] as int,
      item: fields[7] as int,
      idcentrocosto: fields[8] as int,
      codigoempresasupervisor: fields[9] as String,
      codigoempresadigitador: fields[10] as String,
      fechamod: fields[11] as DateTime,
      activo: fields[12] as bool,
      idusuario: fields[13] as int,
      laboresCultivoPacking: fields[14] as LaboresCultivoPackingEntity,
      detalles: (fields[15] as List)?.cast<PreTareoProcesoDetalleEntity>(),
      centroCosto: fields[20] as CentroCostoEntity,
    )
      ..sede = fields[16] as SubdivisionEntity
      ..pathUrl = fields[17] as String
      ..estadoLocal = fields[18] as String
      ..firmaSupervisor = fields[19] as String
      ..turnotareo = fields[21] as String
      ..supervisor = fields[22] as PersonalEmpresaEntity
      ..digitador = fields[23] as PersonalEmpresaEntity
      ..diasiguiente = fields[24] as bool;
  }

  @override
  void write(BinaryWriter writer, PreTareoProcesoEntity obj) {
    writer
      ..writeByte(25)
      ..writeByte(0)
      ..write(obj.itempretareaproceso)
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
      ..write(obj.item)
      ..writeByte(8)
      ..write(obj.idcentrocosto)
      ..writeByte(9)
      ..write(obj.codigoempresasupervisor)
      ..writeByte(10)
      ..write(obj.codigoempresadigitador)
      ..writeByte(11)
      ..write(obj.fechamod)
      ..writeByte(12)
      ..write(obj.activo)
      ..writeByte(13)
      ..write(obj.idusuario)
      ..writeByte(14)
      ..write(obj.laboresCultivoPacking)
      ..writeByte(15)
      ..write(obj.detalles)
      ..writeByte(16)
      ..write(obj.sede)
      ..writeByte(17)
      ..write(obj.pathUrl)
      ..writeByte(18)
      ..write(obj.estadoLocal)
      ..writeByte(19)
      ..write(obj.firmaSupervisor)
      ..writeByte(20)
      ..write(obj.centroCosto)
      ..writeByte(21)
      ..write(obj.turnotareo)
      ..writeByte(22)
      ..write(obj.supervisor)
      ..writeByte(23)
      ..write(obj.digitador)
      ..writeByte(24)
      ..write(obj.diasiguiente);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PreTareoProcesoEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
