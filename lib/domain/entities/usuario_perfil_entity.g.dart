// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario_perfil_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UsuarioPerfilEntityAdapter extends TypeAdapter<UsuarioPerfilEntity> {
  @override
  final int typeId = 13;

  @override
  UsuarioPerfilEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UsuarioPerfilEntity(
      idusuario: fields[0] as int,
      idPerfil: fields[1] as int,
      idsubdivision: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UsuarioPerfilEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.idusuario)
      ..writeByte(1)
      ..write(obj.idPerfil)
      ..writeByte(2)
      ..write(obj.idsubdivision);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsuarioPerfilEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
