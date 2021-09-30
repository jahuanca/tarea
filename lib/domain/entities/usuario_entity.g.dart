// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UsuarioEntityAdapter extends TypeAdapter<UsuarioEntity> {
  @override
  final int typeId = 7;

  @override
  UsuarioEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UsuarioEntity(
      idusuario: fields[0] as int,
      idtipodocumento: fields[1] as int,
      alias: fields[2] as String,
      password: fields[3] as String,
      apellidosnombres: fields[4] as String,
      nrodocumento: fields[5] as String,
      email: fields[6] as String,
      area: fields[7] as String,
      activo: fields[8] as int,
      fechamod: fields[9] as DateTime,
      idsubdivision: fields[10] as int,
      usuarioPerfils: (fields[11] as List)?.cast<UsuarioPerfilEntity>(),
    );
  }

  @override
  void write(BinaryWriter writer, UsuarioEntity obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.idusuario)
      ..writeByte(1)
      ..write(obj.idtipodocumento)
      ..writeByte(2)
      ..write(obj.alias)
      ..writeByte(3)
      ..write(obj.password)
      ..writeByte(4)
      ..write(obj.apellidosnombres)
      ..writeByte(5)
      ..write(obj.nrodocumento)
      ..writeByte(6)
      ..write(obj.email)
      ..writeByte(7)
      ..write(obj.area)
      ..writeByte(8)
      ..write(obj.activo)
      ..writeByte(9)
      ..write(obj.fechamod)
      ..writeByte(10)
      ..write(obj.idsubdivision)
      ..writeByte(11)
      ..write(obj.usuarioPerfils);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsuarioEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
