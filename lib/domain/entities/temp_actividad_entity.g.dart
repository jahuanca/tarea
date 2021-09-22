// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'temp_actividad_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TempActividadEntityAdapter extends TypeAdapter<TempActividadEntity> {
  @override
  final int typeId = 1;

  @override
  TempActividadEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TempActividadEntity(
      actividad: fields[0] as String,
      descAct: fields[1] as String,
      indJoRe: fields[2] as String,
      sociedad: fields[3] as String,
      fechamod: fields[4] as DateTime,
      horamod: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TempActividadEntity obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.actividad)
      ..writeByte(1)
      ..write(obj.descAct)
      ..writeByte(2)
      ..write(obj.indJoRe)
      ..writeByte(3)
      ..write(obj.sociedad)
      ..writeByte(4)
      ..write(obj.fechamod)
      ..writeByte(5)
      ..write(obj.horamod);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TempActividadEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
