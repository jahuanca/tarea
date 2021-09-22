// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_empresa_subdivision_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PersonalEmpresaSubdivisionEntityAdapter
    extends TypeAdapter<PersonalEmpresaSubdivisionEntity> {
  @override
  final int typeId = 6;

  @override
  PersonalEmpresaSubdivisionEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PersonalEmpresaSubdivisionEntity(
      codigoempresa: fields[0] as String,
      idsubdivision: fields[1] as int,
      fechadesde: fields[2] as DateTime,
      fechahasta: fields[3] as DateTime,
      activo: fields[4] as bool,
      fechamod: fields[5] as DateTime,
      idusuario: fields[6] as int,
      personalEmpresa: fields[7] as PersonalEmpresaEntity,
    );
  }

  @override
  void write(BinaryWriter writer, PersonalEmpresaSubdivisionEntity obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.codigoempresa)
      ..writeByte(1)
      ..write(obj.idsubdivision)
      ..writeByte(2)
      ..write(obj.fechadesde)
      ..writeByte(3)
      ..write(obj.fechahasta)
      ..writeByte(4)
      ..write(obj.activo)
      ..writeByte(5)
      ..write(obj.fechamod)
      ..writeByte(6)
      ..write(obj.idusuario)
      ..writeByte(7)
      ..write(obj.personalEmpresa);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonalEmpresaSubdivisionEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
