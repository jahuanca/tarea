
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/entities/subdivision_entity.dart';
import 'package:flutter_tareo/domain/entities/temp_actividad_entity.dart';
import 'package:flutter_tareo/domain/entities/temp_labor_entity.dart';
import 'package:hive/hive.dart';

part 'tarea_proceso_entity.g.dart';

@HiveType(typeId : 0)
class TareaProcesoEntity{

  TareaProcesoEntity({
    this.itemtareoproceso,
    this.codigoempresa,
    this.fecha,
    this.idactividad,
    this.idlabor,
    this.idcentrocosto,
    this.idturno,
    this.fechamod,
    this.idusuario,
    this.idestado,
    this.escampo,
    this.espacking,
    this.horainicio,
    this.horafin,
    this.pausainicio,
    this.pausafin,
    this.personal,
  }){
    if(personal==null){
      personal=[];
    }
  }

  @HiveField(0)
  int itemtareoproceso;
  @HiveField(1)
  String codigoempresa;
  @HiveField(2)
  DateTime fecha;
  @HiveField(3)
  int idactividad;
  @HiveField(4)
  int idlabor;
  @HiveField(5)
  int idcentrocosto;
  @HiveField(6)
  int idturno;
  @HiveField(7)
  DateTime fechamod;
  @HiveField(8)
  int idusuario;
  @HiveField(9)
  int idestado;
  @HiveField(10)
  bool escampo;
  @HiveField(11)
  bool espacking;
  @HiveField(12)
  DateTime horainicio;
  @HiveField(13)
  DateTime horafin;
  @HiveField(14)
  DateTime pausainicio;
  @HiveField(15)
  DateTime pausafin;

  @HiveField(16)
  TempActividadEntity actividad;
  @HiveField(17)
  TempLaborEntity labor;
  @HiveField(18)
  PersonalEmpresaEntity supervisor;
  @HiveField(19)
  SubdivisionEntity sede;
  @HiveField(20)
  List<PersonalTareaProcesoEntity> personal;

  factory TareaProcesoEntity.fromJson(Map<String, dynamic> json) => TareaProcesoEntity(
        itemtareoproceso: json['itemtareoproceso'],
        codigoempresa: json['codigoempresa'],
        fecha: DateTime.parse(json['fecha']),
        idactividad: json['idactividad'],
        idlabor: json['idlabor'],
        idcentrocosto: json['idcentrocosto'],
        idturno: json['idturno'],
        fechamod: DateTime.parse(json['fechamod']),
        idusuario: json['idusuario'],
        idestado: json['idestado'],
        escampo: json['escampo'],
        espacking: json['espacking'],
        horainicio: DateTime.parse(json['horainicio']),
        horafin: DateTime.parse(json['horafin']),
        pausainicio: DateTime.parse(json['pausainicio']),
        pausafin: DateTime.parse(json['pausafin']),
    );

    Map<String, dynamic> toJson() => {
        'itemtareoproceso' : itemtareoproceso,
        'codigoempresa' : codigoempresa,
        'fecha' : fecha?.toIso8601String(),
        'idactividad' : idactividad,
        'idlabor' : idlabor,
        'idcentrocosto' : idcentrocosto,
        'idturno' : idturno,
        'fechamod' : fechamod?.toIso8601String(),
        'idusuario' : idusuario,
        'idestado' : idestado,
        'escampo' : escampo,
        'espacking' : espacking,
        'horainicio' : horainicio?.toIso8601String(),
        'horafin' : horafin?.toIso8601String(),
        'pausainicio' : pausainicio?.toIso8601String(),
        'pausafin' : pausafin?.toIso8601String(),
    };
  
}