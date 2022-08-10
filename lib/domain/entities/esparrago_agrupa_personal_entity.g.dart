// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'esparrago_agrupa_personal_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EsparragoAgrupaPersonalEntityAdapter
    extends TypeAdapter<EsparragoAgrupaPersonalEntity> {
  @override
  final int typeId = 31;

  @override
  EsparragoAgrupaPersonalEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EsparragoAgrupaPersonalEntity(
      itemagruparpersonal: fields[0] as int,
      fecha: fields[1] as DateTime,
      linea: fields[2] as int,
      grupo: fields[3] as int,
      turno: fields[4] as String,
      fechamod: fields[5] as DateTime,
      idusuario: fields[6] as int,
      idestado: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, EsparragoAgrupaPersonalEntity obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.itemagruparpersonal)
      ..writeByte(1)
      ..write(obj.fecha)
      ..writeByte(2)
      ..write(obj.linea)
      ..writeByte(3)
      ..write(obj.grupo)
      ..writeByte(4)
      ..write(obj.turno)
      ..writeByte(5)
      ..write(obj.fechamod)
      ..writeByte(6)
      ..write(obj.idusuario)
      ..writeByte(7)
      ..write(obj.idestado);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EsparragoAgrupaPersonalEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
