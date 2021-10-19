// To parse this JSON data, do
//
//     final preTareoProcesoEntity = preTareoProcesoEntityFromJson(jsonString);

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_tareo/core/colors.dart';
import 'package:flutter_tareo/domain/entities/labores_cultivo_packing_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_detalle_entity.dart';
import 'package:flutter_tareo/domain/entities/subdivision_entity.dart';
import 'package:flutter_tareo/domain/entities/centro_costo_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'pre_tareo_proceso_entity.g.dart';

@HiveType(typeId: 14)
class PreTareoProcesoEntity {
  PreTareoProcesoEntity({
    this.itempretareaproceso,
    this.fecha,
    this.horainicio,
    this.horafin,
    this.pausainicio,
    this.pausafin,
    this.linea,
    this.item,
    this.idcentrocosto,
    this.codigoempresasupervisor,
    this.codigoempresadigitador,
    this.fechamod,
    this.activo,
    this.idusuario,
    this.laboresCultivoPacking,
    this.detalles,
    this.centroCosto,
    this.turnotareo,
    this.diasiguiente,
  }){
    detalles ??= [];
    estadoLocal='P';
  }

  @HiveField(0)
  int itempretareaproceso;
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
  int item;
  @HiveField(8)
  int idcentrocosto;
  @HiveField(9)
  String codigoempresasupervisor;
  @HiveField(10)
  String codigoempresadigitador;
  @HiveField(11)
  DateTime fechamod;
  @HiveField(12)
  bool activo;
  @HiveField(13)
  int idusuario;
  @HiveField(14)
  LaboresCultivoPackingEntity laboresCultivoPacking;
  @HiveField(15)
  List<PreTareoProcesoDetalleEntity> detalles;
  @HiveField(16)
  SubdivisionEntity sede;
  @HiveField(17)
  String pathUrl;
  @HiveField(18)
  String estadoLocal;
  @HiveField(19)
  String firmaSupervisor;
  @HiveField(20)
  CentroCostoEntity centroCosto;
  @HiveField(21)
  String turnotareo;
  @HiveField(22)
  PersonalEmpresaEntity supervisor;
  @HiveField(23)
  PersonalEmpresaEntity digitador;
  @HiveField(24)
  bool diasiguiente;

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

  factory PreTareoProcesoEntity.fromJson(Map<String, dynamic> json) =>
      PreTareoProcesoEntity(
        itempretareaproceso: json["itempretareaproceso"] == null
            ? null
            : json["itempretareaproceso"],
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
        item: json["item"] == null ? null : json["item"],
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
        idusuario: json["idusuario"] == null ? null : json["idusuario"],
        turnotareo: json["turnotareo"] == null ? null : json["turnotareo"],
        diasiguiente: json["diasiguiente"] == null ? null : json["diasiguiente"],
        laboresCultivoPacking: json["Labores_Cultivo_Packing"] == null
            ? null
            : LaboresCultivoPackingEntity.fromJson(
                json["Labores_Cultivo_Packing"]),
        centroCosto: json['Centro_Costo'] == null ? null : CentroCostoEntity.fromJson(json['Centro_Costo']),
        detalles: json['Pre_Tareo_Proceso_Detalles'] == null
            ? null
            : List<PreTareoProcesoDetalleEntity>.from(
                json["Pre_Tareo_Proceso_Detalles"]
                    .map((x) => PreTareoProcesoDetalleEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "itempretareaproceso":
            itempretareaproceso == null ? null : itempretareaproceso,
        "fecha": fecha == null
            ? null
            : "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
        "horainicio": horainicio == null ? null : horainicio.toIso8601String(),
        "horafin": horafin == null ? null : horafin.toIso8601String(),
        "pausainicio":
            pausainicio == null ? null : pausainicio.toIso8601String(),
        "pausafin": pausafin == null ? null : pausafin.toIso8601String(),
        "linea": linea == null ? null : linea,
        "item": item == null ? null : item,
        "idcentrocosto": idcentrocosto == null ? null : idcentrocosto,
        "codigoempresasupervisor":
            codigoempresasupervisor == null ? null : codigoempresasupervisor,
        "codigoempresadigitador":
            codigoempresadigitador == null ? null : codigoempresadigitador,
        "fechamod": fechamod == null ? null : fechamod.toIso8601String(),
        "activo": activo == null ? null : activo,
        "idusuario": idusuario == null ? null : idusuario,
        "turnotareo": turnotareo == null ? null : turnotareo,
        "diasiguiente": diasiguiente == null ? null : diasiguiente,
        "Labores_Cultivo_Packing": laboresCultivoPacking == null
            ? null
            : laboresCultivoPacking.toJson(),
        "Pre_Tareo_Proceso_Detalles": detalles == null
            ? null
            : List<dynamic>.from(detalles.map((x) => x.toJson())),
      };
}

List<PreTareoProcesoEntity> preTareoProcesoEntityFromJson(String str) =>
    List<PreTareoProcesoEntity>.from(
        json.decode(str).map((x) => PreTareoProcesoEntity.fromJson(x)));

String preTareoProcesoEntityToJson(List<PreTareoProcesoEntity> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
