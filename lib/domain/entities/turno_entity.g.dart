// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'turno_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TurnoEntityAdapter extends TypeAdapter<TurnoEntity> {
  @override
  final int typeId = 36;

  @override
  TurnoEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TurnoEntity(
      idturno: fields[0] as int,
      detalleturno: fields[1] as String,
      turno: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TurnoEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.idturno)
      ..writeByte(1)
      ..write(obj.detalleturno)
      ..writeByte(2)
      ..write(obj.turno);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TurnoEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
