// To parse this JSON data, do
//
//     final preTareoProcesoEntity = preTareoProcesoEntityFromJson(jsonString);

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_tareo/core/colors.dart';
import 'package:flutter_tareo/domain/entities/cultivo_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_uva_detalle_entity.dart';
import 'package:flutter_tareo/domain/entities/subdivision_entity.dart';
import 'package:flutter_tareo/domain/entities/presentacion_linea_entity.dart';
import 'package:flutter_tareo/domain/entities/centro_costo_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'pre_tareo_proceso_uva_entity.g.dart';

@HiveType(typeId: 19)
class PreTareoProcesoUvaEntity {
  PreTareoProcesoUvaEntity({
    this.itempretareaprocesouva,
    this.fecha,
    this.horainicio,
    this.horafin,
    this.pausainicio,
    this.pausafin,
    this.linea,
    this.idcentrocosto,
    this.codigoempresasupervisor,
    this.codigoempresadigitador,
    this.fechamod,
    this.activo,
    this.idusuario,
    this.detalles,
    this.centroCosto,
    this.presentacion,
    this.turnotareo,
    this.diasiguiente,
    this.firmaSupervisor,
    this.idcultivo,
    this.cultivo,
    this.key,
  }){
    estadoLocal='P';
  }

  @HiveField(0)
  int itempretareaprocesouva;
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
  String codigoempresasupervisor;
  @HiveField(9)
  String codigoempresadigitador;
  @HiveField(10)
  DateTime fechamod;
  @HiveField(11)
  bool activo;
  @HiveField(12)
  int idusuario;
  @HiveField(13)
  List<PreTareoProcesoUvaDetalleEntity> detalles;
  @HiveField(14)
  SubdivisionEntity sede;
  @HiveField(15)
  String pathUrl;
  @HiveField(16)
  String estadoLocal;
  @HiveField(17)
  String firmaSupervisor;
  @HiveField(18)
  CentroCostoEntity centroCosto;
  @HiveField(19)
  String turnotareo;
  @HiveField(20)
  PersonalEmpresaEntity supervisor;
  @HiveField(21)
  PersonalEmpresaEntity digitador;
  @HiveField(22)
  bool diasiguiente;
  @HiveField(23)
  PresentacionLineaEntity presentacion;
  @HiveField(24)
  int idcultivo;
  @HiveField(25)
  CultivoEntity cultivo;
  @HiveField(26)
  int key;

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

  factory PreTareoProcesoUvaEntity.fromJson(Map<String, dynamic> json) =>
      PreTareoProcesoUvaEntity(
        itempretareaprocesouva: json["itempretareaprocesouva"] == null
            ? null
            : json["itempretareaprocesouva"],
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
        codigoempresasupervisor: json["codigoempresasupervisor"] == null
            ? null
            : json["codigoempresasupervisor"],
        codigoempresadigitador: json["codigoempresadigitador"] == null
            ? null
            : json["codigoempresadigitador"],
        fechamod:
            json["fechamod"] == null ? null : DateTime.parse(json["fechamod"]),
        activo: json["activo"] == null ? null : json["activo"],
        firmaSupervisor: json["firmasupervisor"] == null ? null : json["firmasupervisor"],
        idusuario: json["idusuario"] == null ? null : json["idusuario"],
        idcultivo: json["idcultivo"] == null ? null : json["idcultivo"],
        diasiguiente: json["diasiguiente"] == null ? null : json["diasiguiente"],
        turnotareo: json["turnotareo"] == null ? null : json["turnotareo"],
        key: json["key"] == null ? null : json["key"],
        centroCosto: json['Centro_Costo'] == null ? null : CentroCostoEntity.fromJson(json['Centro_Costo']),
        presentacion: json['Presentacion_Linea'] == null ? null : PresentacionLineaEntity.fromJson(json['Presentacion_Linea']),
        cultivo: json['Cultivo'] == null ? null : CultivoEntity.fromJson(json['Cultivo']),
        detalles: json['Pre_Tareo_Proceso_Detalles'] == null
            ? null
            : List<PreTareoProcesoUvaDetalleEntity>.from(
                json["Pre_Tareo_Proceso_Detalles"]
                    .map((x) => PreTareoProcesoUvaDetalleEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "itempretareaprocesouva":
            itempretareaprocesouva == null ? null : itempretareaprocesouva,
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
        "codigoempresasupervisor":
            codigoempresasupervisor == null ? null : codigoempresasupervisor,
        "codigoempresadigitador":
            codigoempresadigitador == null ? null : codigoempresadigitador,
        "fechamod": fechamod == null ? null : fechamod.toIso8601String(),
        "activo": activo == null ? null : activo,
        "turnotareo": turnotareo == null ? null : turnotareo,
        "key": key == null ? null : key,
        "firmasupervisor": firmaSupervisor == null ? null : firmaSupervisor,
        "diasiguiente": diasiguiente == null ? null : diasiguiente,
        "idusuario": idusuario == null ? null : idusuario,
        "idcultivo": idcultivo == null ? null : idcultivo,
        
        "Pre_Tareo_Proceso_Uva_Detalles": detalles == null
            ? null
            : List<dynamic>.from(detalles.map((x) => x.toJson())),
      };
}

List<PreTareoProcesoUvaEntity> preTareoProcesoUvaEntityFromJson(String str) =>
    List<PreTareoProcesoUvaEntity>.from(
        json.decode(str).map((x) => PreTareoProcesoUvaEntity.fromJson(x)));

String preTareoProcesoUvaEntityToJson(List<PreTareoProcesoUvaEntity> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
