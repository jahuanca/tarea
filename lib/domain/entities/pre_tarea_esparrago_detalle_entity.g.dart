// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pre_tarea_esparrago_detalle_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PreTareaEsparragoDetalleEntityAdapter
    extends TypeAdapter<PreTareaEsparragoDetalleEntity> {
  @override
  final int typeId = 27;

  @override
  PreTareaEsparragoDetalleEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PreTareaEsparragoDetalleEntity(
      itempretareaesparragodetalle: fields[0] as int,
      itemprestareaesparragoformato: fields[1] as int,
      codigoempresa: fields[3] as String,
      fecha: fields[6] as DateTime,
      hora: fields[4] as DateTime,
      idestado: fields[7] as int,
      personal: fields[9] as PersonalEmpresaEntity,
      codigotk: fields[10] as String,
      correlativo: fields[2] as int,
      idusuario: fields[8] as int,
      idlabor: fields[11] as int,
      linea: fields[16] as int,
      labor: fields[15] as LaborEntity,
      idactividad: fields[12] as int,
      actividad: fields[14] as ActividadEntity,
      imei: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PreTareaEsparragoDetalleEntity obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.itempretareaesparragodetalle)
      ..writeByte(1)
      ..write(obj.itemprestareaesparragoformato)
      ..writeByte(2)
      ..write(obj.correlativo)
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
      ..write(obj.codigotk)
      ..writeByte(11)
      ..write(obj.idlabor)
      ..writeByte(12)
      ..write(obj.idactividad)
      ..writeByte(14)
      ..write(obj.actividad)
      ..writeByte(15)
      ..write(obj.labor)
      ..writeByte(16)
      ..write(obj.linea);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PreTareaEsparragoDetalleEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
