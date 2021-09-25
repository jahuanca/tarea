// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'actividad_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActividadEntityAdapter extends TypeAdapter<ActividadEntity> {
  @override
  final int typeId = 9;

  @override
  ActividadEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActividadEntity(
      idactividad: fields[0] as int,
      actividad: fields[1] as String,
      descripcion: fields[2] as String,
      activo: fields[3] as bool,
      esrendimiento: fields[4] as bool,
      esjornal: fields[5] as bool,
      idsociedad: fields[6] as int,
      idusuario: fields[7] as int,
      fechamod: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ActividadEntity obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.idactividad)
      ..writeByte(1)
      ..write(obj.actividad)
      ..writeByte(2)
      ..write(obj.descripcion)
      ..writeByte(3)
      ..write(obj.activo)
      ..writeByte(4)
      ..write(obj.esrendimiento)
      ..writeByte(5)
      ..write(obj.esjornal)
      ..writeByte(6)
      ..write(obj.idsociedad)
      ..writeByte(7)
      ..write(obj.idusuario)
      ..writeByte(8)
      ..write(obj.fechamod);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActividadEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
