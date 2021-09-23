// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tarea_proceso_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TareaProcesoEntityAdapter extends TypeAdapter<TareaProcesoEntity> {
  @override
  final int typeId = 0;

  @override
  TareaProcesoEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TareaProcesoEntity(
      itemtareoproceso: fields[0] as int,
      codigoempresa: fields[1] as String,
      fecha: fields[2] as DateTime,
      idactividad: fields[3] as int,
      idlabor: fields[4] as int,
      idcentrocosto: fields[5] as int,
      idturno: fields[6] as int,
      fechamod: fields[7] as DateTime,
      idusuario: fields[8] as int,
      idestado: fields[9] as int,
      escampo: fields[10] as bool,
      espacking: fields[11] as bool,
      horainicio: fields[12] as DateTime,
      horafin: fields[13] as DateTime,
      pausainicio: fields[14] as DateTime,
      pausafin: fields[15] as DateTime,
      personal: (fields[20] as List)?.cast<PersonalTareaProcesoEntity>(),
    )
      ..actividad = fields[16] as TempActividadEntity
      ..labor = fields[17] as TempLaborEntity
      ..supervisor = fields[18] as PersonalEmpresaEntity
      ..sede = fields[19] as SubdivisionEntity;
  }

  @override
  void write(BinaryWriter writer, TareaProcesoEntity obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.itemtareoproceso)
      ..writeByte(1)
      ..write(obj.codigoempresa)
      ..writeByte(2)
      ..write(obj.fecha)
      ..writeByte(3)
      ..write(obj.idactividad)
      ..writeByte(4)
      ..write(obj.idlabor)
      ..writeByte(5)
      ..write(obj.idcentrocosto)
      ..writeByte(6)
      ..write(obj.idturno)
      ..writeByte(7)
      ..write(obj.fechamod)
      ..writeByte(8)
      ..write(obj.idusuario)
      ..writeByte(9)
      ..write(obj.idestado)
      ..writeByte(10)
      ..write(obj.escampo)
      ..writeByte(11)
      ..write(obj.espacking)
      ..writeByte(12)
      ..write(obj.horainicio)
      ..writeByte(13)
      ..write(obj.horafin)
      ..writeByte(14)
      ..write(obj.pausainicio)
      ..writeByte(15)
      ..write(obj.pausafin)
      ..writeByte(16)
      ..write(obj.actividad)
      ..writeByte(17)
      ..write(obj.labor)
      ..writeByte(18)
      ..write(obj.supervisor)
      ..writeByte(19)
      ..write(obj.sede)
      ..writeByte(20)
      ..write(obj.personal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TareaProcesoEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}