// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calibre_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CalibreEntityAdapter extends TypeAdapter<CalibreEntity> {
  @override
  final int typeId = 32;

  @override
  CalibreEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CalibreEntity(
      idcalibre: fields[0] as int,
      codigo: fields[1] as String,
      detalle: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CalibreEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.idcalibre)
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
      other is CalibreEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
