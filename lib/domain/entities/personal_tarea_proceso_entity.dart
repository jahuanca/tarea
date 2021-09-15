
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';

class PersonalTareaProcesoEntity{

  PersonalTareaProcesoEntity({
    this.item,
    this.itemtareoproceso,
    this.codigoempresa,
    this.transferidosap,
    this.horainicio,
    this.horafin,
    this.pausainicio,
    this.pausafin,
    this.fechainicio,
    this.fechafin,
    this.turno,
    this.diasiguiente,
    this.fechamod,
    this.cantidadHoras,
    this.cantidadrendimiento,
    this.cantidadavance,
    this.idestado,
    this.idusuario,

    this.personal,
  });

  int item;
  int itemtareoproceso;
  String codigoempresa;
  bool transferidosap;
  DateTime horainicio;
  DateTime horafin;
  DateTime pausainicio;
  DateTime pausafin;
  DateTime fechainicio;
  DateTime fechafin;
  String turno;
  bool diasiguiente;
  DateTime fechamod;
  double cantidadHoras;
  double cantidadrendimiento;
  double cantidadavance;
  int idestado;
  int idusuario;

  PersonalEmpresaEntity personal;

  factory PersonalTareaProcesoEntity.fromJson(Map<String, dynamic> json) => PersonalTareaProcesoEntity(
    item : json['item'],
    itemtareoproceso : json['itemtareoproceso'],
    codigoempresa : json['codigoempresa'],
    transferidosap : json['transferidosap'],
    horainicio : DateTime?.parse(json['horainicio']),
    horafin : DateTime?.parse(json['horafin']),
    pausainicio : DateTime?.parse(json['pausainicio']),
    pausafin : DateTime?.parse(json['pausafin']),
    fechainicio : DateTime?.parse(json['fechainicio']),
    fechafin : DateTime?.parse(json['fechafin']),
    turno : json['turno'],
    diasiguiente : json['diasiguiente'],
    fechamod : DateTime?.parse(json['fechamod']),
    cantidadHoras : json['cantidadHoras'],
    cantidadrendimiento : json['cantidadrendimiento'],
    cantidadavance : json['cantidadavance'],
    idestado : json['idestado'],
    idusuario : json['idusuario'],
  );

  Map<String, dynamic> toJson() => {
    'item' : item,
    'itemtareoproceso' : itemtareoproceso,
    'codigoempresa' : codigoempresa,
    'transferidosap' : transferidosap,
    'horainicio' : horainicio?.toIso8601String(),
    'horafin' : horafin?.toIso8601String(),
    'pausainicio' : pausainicio?.toIso8601String(),
    'pausafin' : pausafin?.toIso8601String(),
    'fechainicio' : fechainicio?.toIso8601String(),
    'fechafin' : fechafin?.toIso8601String(),
    'turno' : turno,
    'diasiguiente' : diasiguiente,
    'fechamod' : fechamod?.toIso8601String(),
    'cantidadHoras' : cantidadHoras,
    'cantidadrendimiento' : cantidadrendimiento,
    'cantidadavance' : cantidadavance,
    'idestado' : idestado,
    'idusuario' : idusuario,
  };

}