// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asistencia_fecha_turno_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AsistenciaFechaTurnoEntityAdapter
    extends TypeAdapter<AsistenciaFechaTurnoEntity> {
  @override
  final int typeId = 38;

  @override
  AsistenciaFechaTurnoEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AsistenciaFechaTurnoEntity(
      idasistenciaturno: fields[1] as int,
      key: fields[0] as int,
      idubicacion: fields[2] as int,
      idturno: fields[3] as int,
      idestado: fields[4] as int,
      idusuario: fields[5] as int,
      fecha: fields[6] as DateTime,
      fechamod: fields[7] as DateTime,
      ipmovil: fields[8] as String,
      estadoLocal: fields[9] as String,
      turno: fields[10] as TurnoEntity,
      ubicacion: fields[11] as AsistenciaUbicacionEntity,
      sizeDetails: fields[12] as int,
      pathUrl: fields[13] as String,
      firmaSupervisor: fields[14] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AsistenciaFechaTurnoEntity obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.key)
      ..writeByte(1)
      ..write(obj.idasistenciaturno)
      ..writeByte(2)
      ..write(obj.idubicacion)
      ..writeByte(3)
      ..write(obj.idturno)
      ..writeByte(4)
      ..write(obj.idestado)
      ..writeByte(5)
      ..write(obj.idusuario)
      ..writeByte(6)
      ..write(obj.fecha)
      ..writeByte(7)
      ..write(obj.fechamod)
      ..writeByte(8)
      ..write(obj.ipmovil)
      ..writeByte(9)
      ..write(obj.estadoLocal)
      ..writeByte(10)
      ..write(obj.turno)
      ..writeByte(11)
      ..write(obj.ubicacion)
      ..writeByte(12)
      ..write(obj.sizeDetails)
      ..writeByte(13)
      ..write(obj.pathUrl)
      ..writeByte(14)
      ..write(obj.firmaSupervisor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AsistenciaFechaTurnoEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
