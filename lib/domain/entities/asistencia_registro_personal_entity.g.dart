// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asistencia_registro_personal_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AsistenciaRegistroPersonalEntityAdapter
    extends TypeAdapter<AsistenciaRegistroPersonalEntity> {
  @override
  final int typeId = 39;

  @override
  AsistenciaRegistroPersonalEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AsistenciaRegistroPersonalEntity(
      idasistencia: fields[0] as int,
      codigoempresa: fields[1] as String,
      tipomovimiento: fields[2] as String,
      fechaentrada: fields[3] as DateTime,
      horaentrada: fields[4] as DateTime,
      idubicacionentrada: fields[5] as int,
      fechasalida: fields[6] as DateTime,
      horasalida: fields[7] as DateTime,
      idubicacionsalida: fields[8] as int,
      idturno: fields[9] as int,
      fechaturno: fields[10] as DateTime,
      idusuario: fields[11] as int,
      fechamod: fields[12] as DateTime,
      estadoLocal: fields[13] as String,
      key: fields[14] as int,
      personal: fields[15] as PersonalEmpresaEntity,
      idasistenciaturno: fields[16] as int,
      nrodocumento: fields[17] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AsistenciaRegistroPersonalEntity obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.idasistencia)
      ..writeByte(1)
      ..write(obj.codigoempresa)
      ..writeByte(2)
      ..write(obj.tipomovimiento)
      ..writeByte(3)
      ..write(obj.fechaentrada)
      ..writeByte(4)
      ..write(obj.horaentrada)
      ..writeByte(5)
      ..write(obj.idubicacionentrada)
      ..writeByte(6)
      ..write(obj.fechasalida)
      ..writeByte(7)
      ..write(obj.horasalida)
      ..writeByte(8)
      ..write(obj.idubicacionsalida)
      ..writeByte(9)
      ..write(obj.idturno)
      ..writeByte(10)
      ..write(obj.fechaturno)
      ..writeByte(11)
      ..write(obj.idusuario)
      ..writeByte(12)
      ..write(obj.fechamod)
      ..writeByte(13)
      ..write(obj.estadoLocal)
      ..writeByte(14)
      ..write(obj.key)
      ..writeByte(15)
      ..write(obj.personal)
      ..writeByte(16)
      ..write(obj.idasistenciaturno)
      ..writeByte(17)
      ..write(obj.nrodocumento);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AsistenciaRegistroPersonalEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
