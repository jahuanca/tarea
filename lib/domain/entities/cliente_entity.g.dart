// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cliente_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClienteEntityAdapter extends TypeAdapter<ClienteEntity> {
  @override
  final int typeId = 30;

  @override
  ClienteEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClienteEntity(
      idcliente: fields[0] as int,
      idtipocliente: fields[1] as int,
      abreviatura: fields[2] as String,
      descripcion: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ClienteEntity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.idcliente)
      ..writeByte(1)
      ..write(obj.idtipocliente)
      ..writeByte(2)
      ..write(obj.abreviatura)
      ..writeByte(3)
      ..write(obj.descripcion);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClienteEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
