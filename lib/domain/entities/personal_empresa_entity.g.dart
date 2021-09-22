// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_empresa_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PersonalEmpresaEntityAdapter extends TypeAdapter<PersonalEmpresaEntity> {
  @override
  final int typeId = 3;

  @override
  PersonalEmpresaEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PersonalEmpresaEntity(
      codigoempresa: fields[0] as String,
      apellidopaterno: fields[1] as String,
      apellidomaterno: fields[2] as String,
      nombres: fields[3] as String,
      nrodocumento: fields[4] as String,
      fechamod: fields[5] as DateTime,
      idtipodocumento: fields[6] as int,
      fechaingreso: fields[7] as DateTime,
      bloqueado: fields[8] as bool,
      fechacese: fields[9] as DateTime,
      idusuario: fields[10] as int,
      personalEmpresaSubdivision:
          fields[11] as PersonalEmpresaSubdivisionEntity,
    );
  }

  @override
  void write(BinaryWriter writer, PersonalEmpresaEntity obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.codigoempresa)
      ..writeByte(1)
      ..write(obj.apellidopaterno)
      ..writeByte(2)
      ..write(obj.apellidomaterno)
      ..writeByte(3)
      ..write(obj.nombres)
      ..writeByte(4)
      ..write(obj.nrodocumento)
      ..writeByte(5)
      ..write(obj.fechamod)
      ..writeByte(6)
      ..write(obj.idtipodocumento)
      ..writeByte(7)
      ..write(obj.fechaingreso)
      ..writeByte(8)
      ..write(obj.bloqueado)
      ..writeByte(9)
      ..write(obj.fechacese)
      ..writeByte(10)
      ..write(obj.idusuario)
      ..writeByte(11)
      ..write(obj.personalEmpresaSubdivision);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonalEmpresaEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
