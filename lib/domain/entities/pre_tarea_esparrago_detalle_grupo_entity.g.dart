// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pre_tarea_esparrago_detalle_grupo_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PreTareaEsparragoDetalleGrupoEntityAdapter
    extends TypeAdapter<PreTareaEsparragoDetalleGrupoEntity> {
  @override
  final int typeId = 24;

  @override
  PreTareaEsparragoDetalleGrupoEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PreTareaEsparragoDetalleGrupoEntity(
      itempretareaesparragodetallegrupo: fields[0] as int,
      itempretareaesparragogrupo: fields[1] as int,
      codigoempresa: fields[3] as String,
      fecha: fields[6] as DateTime,
      hora: fields[4] as DateTime,
      idestado: fields[7] as int,
      personal: fields[9] as PersonalEmpresaEntity,
      codigotk: fields[10] as String,
      idusuario: fields[8] as int,
      imei: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PreTareaEsparragoDetalleGrupoEntity obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.itempretareaesparragodetallegrupo)
      ..writeByte(1)
      ..write(obj.itempretareaesparragogrupo)
      ..writeByte(3)
      ..write(obj.codigoempresa)
      ..writeByte(4)
      ..write(obj.hora)
      ..writeByte(5)
      ..write(obj.imei)
      ..writeByte(6)
      ..write(obj.fecha)
      ..writeByte(7)
      ..write(obj.idestado)
      ..writeByte(8)
      ..write(obj.idusuario)
      ..writeByte(9)
      ..write(obj.personal)
      ..writeByte(10)
      ..write(obj.codigotk);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PreTareaEsparragoDetalleGrupoEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
