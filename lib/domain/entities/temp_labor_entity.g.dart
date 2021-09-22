// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'temp_labor_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TempLaborEntityAdapter extends TypeAdapter<TempLaborEntity> {
  @override
  final int typeId = 2;

  @override
  TempLaborEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TempLaborEntity(
      labor: fields[0] as String,
      descLabor: fields[1] as String,
      actividad: fields[2] as String,
      sociedad: fields[3] as String,
      fechamod: fields[4] as DateTime,
      horamod: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TempLaborEntity obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.labor)
      ..writeByte(1)
      ..write(obj.descLabor)
      ..writeByte(2)
      ..write(obj.actividad)
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
      other is TempLaborEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
