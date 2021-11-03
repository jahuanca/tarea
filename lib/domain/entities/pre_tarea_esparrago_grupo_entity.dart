// To parse this JSON data, do
//
//     final preTareoProcesoEntity = preTareoProcesoEntityFromJson(jsonString);

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_tareo/core/colors.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_detalle_grupo_entity.dart';
import 'package:flutter_tareo/domain/entities/subdivision_entity.dart';
import 'package:flutter_tareo/domain/entities/centro_costo_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/entities/labor_entity.dart';
import 'package:flutter_tareo/domain/entities/actividad_entity.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'pre_tarea_esparrago_grupo_entity.g.dart';

@HiveType(typeId: 23)
class PreTareaEsparragoGrupoEntity {
  PreTareaEsparragoGrupoEntity({
    this.itempretareaesparragosgrupo,
    this.fecha,
    this.horainicio,
    this.horafin,
    this.pausainicio,
    this.pausafin,
    this.idestado,
    this.idcentrocosto,
    this.diasiguiente,
    this.codigosupervisor,
    this.codigodigitador,
    this.linea,
    this.idlabor,
    this.labor,
    this.idactividad,
    this.actividad,
    this.idusuario,
    this.detalles,
    this.centroCosto,
    this.turnotareo,
    this.firmaSupervisor,
    this.key,
  }) {
    estadoLocal = 'P';
  }

  @HiveField(0)
  int itempretareaesparragosgrupo;
  @HiveField(1)
  DateTime fecha;
  @HiveField(2)
  DateTime horainicio;
  @HiveField(3)
  DateTime horafin;
  @HiveField(4)
  DateTime pausainicio;
  @HiveField(5)
  DateTime pausafin;
  @HiveField(6)
  int linea;
  @HiveField(7)
  int idcentrocosto;
  @HiveField(8)
  String codigosupervisor;
  @HiveField(9)
  String codigodigitador;
  @HiveField(10)
  int idusuario;
  @HiveField(11)
  int idestado;
  @HiveField(12)
  List<PreTareaEsparragoDetalleGrupoEntity> detalles;
  @HiveField(13)
  SubdivisionEntity sede;
  @HiveField(14)
  String pathUrl;
  @HiveField(15)
  String estadoLocal;
  @HiveField(16)
  String firmaSupervisor;
  @HiveField(17)
  CentroCostoEntity centroCosto;
  @HiveField(18)
  String turnotareo;
  @HiveField(19)
  PersonalEmpresaEntity supervisor;
  @HiveField(20)
  PersonalEmpresaEntity digitador;
  @HiveField(21)
  bool diasiguiente;
  @HiveField(22)
  int key;
  @HiveField(23)
  int idlabor;
  @HiveField(24)
  LaborEntity labor;
  @HiveField(25)
  int idactividad;
  @HiveField(26)
  ActividadEntity actividad;

  String get fechaHora {
    if (fecha == null || horainicio == null) {
      fecha = DateTime.now();
      horainicio = DateTime.now();
    }
    return DateFormat('dd').format(fecha) +
        "/" +
        DateFormat('MM', 'es').format(fecha) +
        "/" +
        DateFormat('yyyy').format(fecha) +
        "  " +
        DateFormat('hh:mm a').format(horainicio);
  }

  Color get colorEstado {
    switch (estadoLocal) {
      case 'P':
        return alertColor;
        break;
      case 'A':
        return successColor;
        break;
      case 'M':
        return infoColor;
        break;
      default:
        return alertColor;
        break;
    }
  }

  factory PreTareaEsparragoGrupoEntity.fromJson(Map<String, dynamic> json) =>
      PreTareaEsparragoGrupoEntity(
        itempretareaesparragosgrupo: json["itempretareaesparragosgrupo"] == null
            ? null
            : json["itempretareaesparragosgrupo"],
        fecha: json["fecha"] == null ? null : DateTime.parse(json["fecha"]),
        horainicio: json["horainicio"] == null
            ? null
            : DateTime.parse(json["horainicio"]),
        horafin:
            json["horafin"] == null ? null : DateTime.parse(json["horafin"]),
        pausainicio: json["pausainicio"] == null
            ? null
            : DateTime.parse(json["pausainicio"]),
        pausafin:
            json["pausafin"] == null ? null : DateTime.parse(json["pausafin"]),
        linea: json["linea"] == null ? null : json["linea"],
        idcentrocosto:
            json["idcentrocosto"] == null ? null : json["idcentrocosto"],
        codigosupervisor:
            json["codigosupervisor"] == null ? null : json["codigosupervisor"],
        codigodigitador:
            json["codigodigitador"] == null ? null : json["codigodigitador"],
        firmaSupervisor:
            json["firmasupervisor"] == null ? null : json["firmasupervisor"],
        idusuario: json["idusuario"] == null ? null : json["idusuario"],
        idlabor: json["idlabor"] == null ? null : json["idlabor"],
        idactividad: json["idactividad"] == null ? null : json["idactividad"],
        diasiguiente:
            json["diasiguiente"] == null ? null : json["diasiguiente"],
        turnotareo: json["turnotareo"] == null ? null : json["turnotareo"],
        key: json["key"] == null ? null : json["key"],
        centroCosto: json['Centro_Costo'] == null
            ? null
            : CentroCostoEntity.fromJson(json['Centro_Costo']),
        labor:
            json['Labor'] == null ? null : LaborEntity.fromJson(json['Labor']),
        actividad:
            json['Actividad'] == null ? null : ActividadEntity.fromJson(json['Actividad']),
        detalles: json['Pre_Tarea_Esparrago_Detalle_Grupo'] == null
            ? null
            : List<PreTareaEsparragoDetalleGrupoEntity>.from(
                json["Pre_Tarea_Esparrago_Detalle_Grupo"].map(
                    (x) => PreTareaEsparragoDetalleGrupoEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "itempretareaesparragosgrupo": itempretareaesparragosgrupo == null
            ? null
            : itempretareaesparragosgrupo,
        "fecha": fecha == null
            ? null
            : "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
        "horainicio": horainicio == null ? null : horainicio.toIso8601String(),
        "horafin": horafin == null ? null : horafin.toIso8601String(),
        "pausainicio":
            pausainicio == null ? null : pausainicio.toIso8601String(),
        "pausafin": pausafin == null ? null : pausafin.toIso8601String(),
        "linea": linea == null ? null : linea,
        "idcentrocosto": idcentrocosto == null ? null : idcentrocosto,
        "idlabor": idlabor == null ? null : idlabor,
        "idactividad": idactividad == null ? null : idactividad,
        "labor": labor == null ? null : labor.toJson(),
        "actividad": actividad == null ? null : actividad.toJson(),
        "codigosupervisor": codigosupervisor == null ? null : codigosupervisor,
        "codigodigitador": codigodigitador == null ? null : codigodigitador,
        "turnotareo": turnotareo == null ? null : turnotareo,
        "key": key == null ? null : key,
        "firmasupervisor": firmaSupervisor == null ? null : firmaSupervisor,
        "diasiguiente": diasiguiente == null ? null : diasiguiente,
        "idusuario": idusuario == null ? null : idusuario,
        "Pre_Tarea_Esparrago_Detalle_Grupo": detalles == null
            ? null
            : List<dynamic>.from(
                detalles.map((x) => x.toJson())),
      };
}

List<PreTareaEsparragoGrupoEntity> preTareaEsparragoGrupoEntityFromJson(
        String str) =>
    List<PreTareaEsparragoGrupoEntity>.from(
        json.decode(str).map((x) => PreTareaEsparragoGrupoEntity.fromJson(x)));

String preTareaEsparragoGrupoEntityToJson(
        List<PreTareaEsparragoGrupoEntity> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
