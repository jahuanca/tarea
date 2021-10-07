// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'labores_cultivo_packing_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LaboresCultivoPackingEntityAdapter
    extends TypeAdapter<LaboresCultivoPackingEntity> {
  @override
  final int typeId = 17;

  @override
  LaboresCultivoPackingEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LaboresCultivoPackingEntity(
      item: fields[0] as int,
      idcultivo: fields[1] as int,
      idlabor: fields[2] as int,
      idactividad: fields[3] as int,
      fechamod: fields[4] as DateTime,
      activo: fields[5] as bool,
      idpresentacion: fields[6] as int,
      labor: fields[7] as LaborEntity,
      cultivo: fields[8] as CultivoEntity,
      actividad: fields[9] as ActividadEntity,
      presentacionLinea: fields[10] as PresentacionLineaEntity,
    );
  }

  @override
  void write(BinaryWriter writer, LaboresCultivoPackingEntity obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.item)
      ..writeByte(1)
      ..write(obj.idcultivo)
      ..writeByte(2)
      ..write(obj.idlabor)
      ..writeByte(3)
      ..write(obj.idactividad)
      ..writeByte(4)
      ..write(obj.fechamod)
      ..writeByte(5)
      ..write(obj.activo)
      ..writeByte(6)
      ..write(obj.idpresentacion)
      ..writeByte(7)
      ..write(obj.labor)
      ..writeByte(8)
      ..write(obj.cultivo)
      ..writeByte(9)
      ..write(obj.actividad)
      ..writeByte(10)
      ..write(obj.presentacionLinea);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LaboresCultivoPackingEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
