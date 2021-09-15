
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/entities/subdivision_entity.dart';
import 'package:flutter_tareo/domain/entities/temp_actividad_entity.dart';
import 'package:flutter_tareo/domain/entities/temp_labor_entity.dart';

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

  int itemtareoproceso;
  String codigoempresa;
  DateTime fecha;
  int idactividad;
  int idlabor;
  int idcentrocosto;
  int idturno;
  DateTime fechamod;
  int idusuario;
  int idestado;
  bool escampo;
  bool espacking;
  DateTime horainicio;
  DateTime horafin;
  DateTime pausainicio;
  DateTime pausafin;

  TempActividadEntity actividad;
  TempLaborEntity labor;
  PersonalEmpresaEntity supervisor;
  SubdivisionEntity sede;
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