// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pre_tarea_esparrago_formato_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PreTareaEsparragoFormatoEntityAdapter
    extends TypeAdapter<PreTareaEsparragoFormatoEntity> {
  @override
  final int typeId = 26;

  @override
  PreTareaEsparragoFormatoEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PreTareaEsparragoFormatoEntity(
      itemprestareaesparragoformato: fields[0] as int,
      itempretareaesparrago: fields[1] as int,
      fecha: fields[6] as DateTime,
      hora: fields[4] as DateTime,
      idestado: fields[7] as int,
      codigotk: fields[10] as String,
      idusuario: fields[8] as int,
      idlabor: fields[11] as int,
      labor: fields[15] as LaborEntity,
      correlativo: fields[17] as int,
      idactividad: fields[12] as int,
      idcliente: fields[3] as int,
      cliente: fields[9] as ClienteEntity,
      actividad: fields[14] as ActividadEntity,
      imei: fields[5] as String,
      key: fields[18] as int,
      linea: fields[19] as int,
      sizeDetails: fields[20] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PreTareaEsparragoFormatoEntity obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.itemprestareaesparragoformato)
      ..writeByte(1)
      ..write(obj.itempretareaesparrago)
      ..writeByte(3)
      ..write(obj.idcliente)
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
      ..write(obj.cliente)
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
      ..writeByte(17)
      ..write(obj.correlativo)
      ..writeByte(18)
      ..write(obj.key)
      ..writeByte(19)
      ..write(obj.linea)
      ..writeByte(20)
      ..write(obj.sizeDetails);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PreTareaEsparragoFormatoEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
