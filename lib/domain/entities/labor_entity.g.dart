// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'labor_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LaborEntityAdapter extends TypeAdapter<LaborEntity> {
  @override
  final int typeId = 12;

  @override
  LaborEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LaborEntity(
      idlabor: fields[0] as int,
      idactividad: fields[1] as int,
      labor: fields[2] as String,
      descripcion: fields[3] as String,
      activo: fields[4] as bool,
      idusuario: fields[5] as int,
      fechamod: fields[6] as DateTime,
      actividad: fields[7] as ActividadEntity,
    );
  }

  @override
  void write(BinaryWriter writer, LaborEntity obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.idlabor)
      ..writeByte(1)
      ..write(obj.idactividad)
      ..writeByte(2)
      ..write(obj.labor)
      ..writeByte(3)
      ..write(obj.descripcion)
      ..writeByte(4)
      ..write(obj.activo)
      ..writeByte(5)
      ..write(obj.idusuario)
      ..writeByte(6)
      ..write(obj.fechamod)
      ..writeByte(7)
      ..write(obj.actividad);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LaborEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
