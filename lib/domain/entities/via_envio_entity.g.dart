// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'via_envio_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ViaEnvioEntityAdapter extends TypeAdapter<ViaEnvioEntity> {
  @override
  final int typeId = 34;

  @override
  ViaEnvioEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ViaEnvioEntity(
      idvia: fields[0] as int,
      codigo: fields[1] as String,
      detalle: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ViaEnvioEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.idvia)
      ..writeByte(1)
      ..write(obj.codigo)
      ..writeByte(2)
      ..write(obj.detalle);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ViaEnvioEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
