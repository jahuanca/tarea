// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tipo_tarea_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TipoTareaEntityAdapter extends TypeAdapter<TipoTareaEntity> {
  @override
  final int typeId = 29;

  @override
  TipoTareaEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TipoTareaEntity(
      idtipotarea: fields[0] as int,
      descripcion: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TipoTareaEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.idtipotarea)
      ..writeByte(1)
      ..write(obj.descripcion);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TipoTareaEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
