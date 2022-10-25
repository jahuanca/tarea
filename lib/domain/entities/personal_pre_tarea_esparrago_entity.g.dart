// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_pre_tarea_esparrago_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PersonalPreTareaEsparragoEntityAdapter
    extends TypeAdapter<PersonalPreTareaEsparragoEntity> {
  @override
  final int typeId = 35;

  @override
  PersonalPreTareaEsparragoEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PersonalPreTareaEsparragoEntity(
      itempersonalpretareaesparrago: fields[0] as int,
      fecha: fields[1] as DateTime,
      hora: fields[2] as DateTime,
      idestado: fields[3] as int,
      itempretareaesparragovarios: fields[4] as int,
      codigotkcaja: fields[5] as String,
      idlabor: fields[6] as int,
      idcliente: fields[7] as int,
      idvia: fields[8] as int,
      correlativocaja: fields[9] as int,
      codigotkmesa: fields[10] as String,
      mesa: fields[11] as String,
      linea: fields[12] as String,
      correlativomesa: fields[13] as int,
      idusuario: fields[14] as int,
      fechamod: fields[15] as DateTime,
      key: fields[16] as int,
      esperandoCierre: fields[17] as bool,
      cliente: fields[18] as ClienteEntity,
      labor: fields[19] as LaborEntity,
      calibre: fields[20] as CalibreEntity,
      viaEnvio: fields[21] as ViaEnvioEntity,
      idcalibre: fields[22] as int,
      idSQLite: fields[23] as int,
      idSQLitePreTareaEsparrago: fields[24] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PersonalPreTareaEsparragoEntity obj) {
    writer
      ..writeByte(25)
      ..writeByte(0)
      ..write(obj.itempersonalpretareaesparrago)
      ..writeByte(1)
      ..write(obj.fecha)
      ..writeByte(2)
      ..write(obj.hora)
      ..writeByte(3)
      ..write(obj.idestado)
      ..writeByte(4)
      ..write(obj.itempretareaesparragovarios)
      ..writeByte(5)
      ..write(obj.codigotkcaja)
      ..writeByte(6)
      ..write(obj.idlabor)
      ..writeByte(7)
      ..write(obj.idcliente)
      ..writeByte(8)
      ..write(obj.idvia)
      ..writeByte(9)
      ..write(obj.correlativocaja)
      ..writeByte(10)
      ..write(obj.codigotkmesa)
      ..writeByte(11)
      ..write(obj.mesa)
      ..writeByte(12)
      ..write(obj.linea)
      ..writeByte(13)
      ..write(obj.correlativomesa)
      ..writeByte(14)
      ..write(obj.idusuario)
      ..writeByte(15)
      ..write(obj.fechamod)
      ..writeByte(16)
      ..write(obj.key)
      ..writeByte(17)
      ..write(obj.esperandoCierre)
      ..writeByte(18)
      ..write(obj.cliente)
      ..writeByte(19)
      ..write(obj.labor)
      ..writeByte(20)
      ..write(obj.calibre)
      ..writeByte(21)
      ..write(obj.viaEnvio)
      ..writeByte(22)
      ..write(obj.idcalibre)
      ..writeByte(23)
      ..write(obj.idSQLite)
      ..writeByte(24)
      ..write(obj.idSQLitePreTareaEsparrago);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonalPreTareaEsparragoEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
