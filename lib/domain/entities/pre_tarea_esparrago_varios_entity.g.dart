// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pre_tarea_esparrago_varios_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PreTareaEsparragoVariosEntityAdapter
    extends TypeAdapter<PreTareaEsparragoVariosEntity> {
  @override
  final int typeId = 21;

  @override
  PreTareaEsparragoVariosEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PreTareaEsparragoVariosEntity(
      itempretareaesparragosvarios: fields[0] as int,
      fecha: fields[1] as DateTime,
      horainicio: fields[2] as DateTime,
      horafin: fields[3] as DateTime,
      pausainicio: fields[4] as DateTime,
      pausafin: fields[5] as DateTime,
      linea: fields[6] as int,
      idcentrocosto: fields[7] as int,
      codigosupervisor: fields[8] as String,
      codigodigitador: fields[9] as String,
      idusuario: fields[10] as int,
      centroCosto: fields[17] as CentroCostoEntity,
      turnotareo: fields[18] as String,
      diasiguiente: fields[21] as bool,
      firmaSupervisor: fields[16] as String,
      key: fields[22] as int,
      idestado: fields[11] as int,
      sizeDetails: fields[23] as int,
      idtipotarea: fields[24] as int,
      tipoTarea: fields[25] as TipoTareaEntity,
      sizeTipoCaja: fields[27] as int,
      sizeTipoPersona: fields[26] as int,
    )
      ..sede = fields[13] as SubdivisionEntity
      ..pathUrl = fields[14] as String
      ..estadoLocal = fields[15] as String
      ..supervisor = fields[19] as PersonalEmpresaEntity
      ..digitador = fields[20] as PersonalEmpresaEntity;
  }

  @override
  void write(BinaryWriter writer, PreTareaEsparragoVariosEntity obj) {
    writer
      ..writeByte(27)
      ..writeByte(0)
      ..write(obj.itempretareaesparragosvarios)
      ..writeByte(1)
      ..write(obj.fecha)
      ..writeByte(2)
      ..write(obj.horainicio)
      ..writeByte(3)
      ..write(obj.horafin)
      ..writeByte(4)
      ..write(obj.pausainicio)
      ..writeByte(5)
      ..write(obj.pausafin)
      ..writeByte(6)
      ..write(obj.linea)
      ..writeByte(7)
      ..write(obj.idcentrocosto)
      ..writeByte(8)
      ..write(obj.codigosupervisor)
      ..writeByte(9)
      ..write(obj.codigodigitador)
      ..writeByte(10)
      ..write(obj.idusuario)
      ..writeByte(11)
      ..write(obj.idestado)
      ..writeByte(13)
      ..write(obj.sede)
      ..writeByte(14)
      ..write(obj.pathUrl)
      ..writeByte(15)
      ..write(obj.estadoLocal)
      ..writeByte(16)
      ..write(obj.firmaSupervisor)
      ..writeByte(17)
      ..write(obj.centroCosto)
      ..writeByte(18)
      ..write(obj.turnotareo)
      ..writeByte(19)
      ..write(obj.supervisor)
      ..writeByte(20)
      ..write(obj.digitador)
      ..writeByte(21)
      ..write(obj.diasiguiente)
      ..writeByte(22)
      ..write(obj.key)
      ..writeByte(23)
      ..write(obj.sizeDetails)
      ..writeByte(24)
      ..write(obj.idtipotarea)
      ..writeByte(25)
      ..write(obj.tipoTarea)
      ..writeByte(26)
      ..write(obj.sizeTipoPersona)
      ..writeByte(27)
      ..write(obj.sizeTipoCaja);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PreTareaEsparragoVariosEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
