// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_tarea_proceso_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PersonalTareaProcesoEntityAdapter
    extends TypeAdapter<PersonalTareaProcesoEntity> {
  @override
  final int typeId = 5;

  @override
  PersonalTareaProcesoEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PersonalTareaProcesoEntity(
      item: fields[0] as int,
      itemtareoproceso: fields[1] as int,
      codigoempresa: fields[2] as String,
      transferidosap: fields[3] as bool,
      horainicio: fields[4] as DateTime,
      horafin: fields[5] as DateTime,
      pausainicio: fields[6] as DateTime,
      pausafin: fields[7] as DateTime,
      fechainicio: fields[8] as DateTime,
      fechafin: fields[9] as DateTime,
      turno: fields[10] as String,
      diasiguiente: fields[11] as bool,
      fechamod: fields[12] as DateTime,
      cantidadHoras: fields[13] as double,
      cantidadrendimiento: fields[14] as double,
      cantidadavance: fields[15] as double,
      idestado: fields[16] as int,
      idusuario: fields[17] as int,
      esrendimiento: fields[19] as bool,
      esjornal: fields[20] as bool,
      idactividad: fields[21] as bool,
      personal: fields[18] as PersonalEmpresaEntity,
    );
  }

  @override
  void write(BinaryWriter writer, PersonalTareaProcesoEntity obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.item)
      ..writeByte(1)
      ..write(obj.itemtareoproceso)
      ..writeByte(2)
      ..write(obj.codigoempresa)
      ..writeByte(3)
      ..write(obj.transferidosap)
      ..writeByte(4)
      ..write(obj.horainicio)
      ..writeByte(5)
      ..write(obj.horafin)
      ..writeByte(6)
      ..write(obj.pausainicio)
      ..writeByte(7)
      ..write(obj.pausafin)
      ..writeByte(8)
      ..write(obj.fechainicio)
      ..writeByte(9)
      ..write(obj.fechafin)
      ..writeByte(10)
      ..write(obj.turno)
      ..writeByte(11)
      ..write(obj.diasiguiente)
      ..writeByte(12)
      ..write(obj.fechamod)
      ..writeByte(13)
      ..write(obj.cantidadHoras)
      ..writeByte(14)
      ..write(obj.cantidadrendimiento)
      ..writeByte(15)
      ..write(obj.cantidadavance)
      ..writeByte(16)
      ..write(obj.idestado)
      ..writeByte(17)
      ..write(obj.idusuario)
      ..writeByte(18)
      ..write(obj.personal)
      ..writeByte(19)
      ..write(obj.esrendimiento)
      ..writeByte(20)
      ..write(obj.esjornal)
      ..writeByte(21)
      ..write(obj.idactividad);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonalTareaProcesoEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
