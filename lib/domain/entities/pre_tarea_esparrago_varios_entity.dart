
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_tareo/core/colors.dart';
import 'package:flutter_tareo/domain/entities/personal_pre_tarea_esparrago_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_detalle_varios_entity.dart';
import 'package:flutter_tareo/domain/entities/subdivision_entity.dart';
import 'package:flutter_tareo/domain/entities/centro_costo_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/entities/tipo_tarea_entity.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'pre_tarea_esparrago_varios_entity.g.dart';

@HiveType(typeId: 21)
class PreTareaEsparragoVariosEntity {
  PreTareaEsparragoVariosEntity({
    this.itempretareaesparragosvarios,
    this.fecha,
    this.horainicio,
    this.horafin,
    this.pausainicio,
    this.pausafin,
    this.linea,
    this.idcentrocosto,
    this.codigosupervisor,
    this.codigodigitador,
    this.idusuario,
    this.detalles,
    this.centroCosto,
    this.turnotareo,
    this.diasiguiente,
    this.firmaSupervisor,
    this.key,
    this.idestado,
    this.sizeDetails,
    this.idtipotarea,
    this.tipoTarea,
    this.sizeTipoCaja,
    this.sizeTipoPersona,
    this.imei,
    this.fechamod,
  }){
    estadoLocal='P';
  }

  @HiveField(0)
  int itempretareaesparragosvarios;
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
  /* @HiveField(12) */
  /* List<PreTareaEsparragoDetalleVariosEntity> detalles; */
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
  int sizeDetails;
  @HiveField(24)
  int idtipotarea;
  @HiveField(25)
  TipoTareaEntity tipoTarea;
  @HiveField(26)
  int sizeTipoPersona;
  @HiveField(27)
  int sizeTipoCaja;
  @HiveField(28)
  String imei;
  @HiveField(29)
  DateTime fechamod;
  List<PersonalPreTareaEsparragoEntity> detalles;

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

  factory PreTareaEsparragoVariosEntity.fromJson(Map<String, dynamic> json) =>
      PreTareaEsparragoVariosEntity(
        itempretareaesparragosvarios: json["itempretareaesparragosvarios"] == null
            ? null
            : json["itempretareaesparragosvarios"],
        fecha: json["fecha"] == null ? null : DateTime.parse(json["fecha"]),
        fechamod: json["fechamod"] == null ? null : DateTime.parse(json["fechamod"]),
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
        codigosupervisor: json["codigosupervisor"] == null
            ? null
            : json["codigosupervisor"],
        codigodigitador: json["codigodigitador"] == null
            ? null
            : json["codigodigitador"],
        firmaSupervisor: json["firmasupervisor"] == null ? null : json["firmasupervisor"],
        sizeTipoPersona: json["sizeTipoPersona"] == null ? null : json["sizeTipoPersona"],
        sizeTipoCaja: json["sizeTipoCaja"] == null ? null : json["sizeTipoCaja"],
        idusuario: json["idusuario"] == null ? null : json["idusuario"],
        idtipotarea: json["idtipotarea"] == null ? null : json["idtipotarea"],
        tipoTarea: json["tipoTarea"] == null ? null : json["tipoTarea"],
        diasiguiente: json["diasiguiente"] == null ? null : json["diasiguiente"],
        turnotareo: json["turnotareo"] == null ? null : json["turnotareo"],
        key: json["key"] == null ? null : json["key"],
        imei: json["imei"] == null ? null : json["imei"],
        sizeDetails: json["sizeDetails"] == null ? null : json["sizeDetails"],
        centroCosto: json['Centro_Costo'] == null ? null : CentroCostoEntity.fromJson(json['Centro_Costo']),
        detalles: json['Personal_Pre_Tarea_Esparrago'] == null
            ? null
            : List<PersonalPreTareaEsparragoEntity>.from(
                json["Personal_Pre_Tarea_Esparrago"]
                    .map((x) => PersonalPreTareaEsparragoEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "itempretareaesparragosvarios":
            itempretareaesparragosvarios == null ? null : itempretareaesparragosvarios,
        "fecha": fecha == null
            ? null
            : "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
        "horainicio": horainicio == null ? null : horainicio.toIso8601String(),
        "horafin": horafin == null ? null : horafin.toIso8601String(),
        "fechamod": fechamod == null ? null : fechamod.toIso8601String(),
        "pausainicio":
            pausainicio == null ? null : pausainicio.toIso8601String(),
        "pausafin": pausafin == null ? null : pausafin.toIso8601String(),
        "linea": linea == null ? null : linea,
        "imei": imei == null ? null : imei,
        "idcentrocosto": idcentrocosto == null ? null : idcentrocosto,
        "sizeTipoPersona": sizeTipoPersona == null ? null : sizeTipoPersona,
        "sizeTipoCaja": sizeTipoCaja == null ? null : sizeTipoCaja,
        "codigosupervisor":
            codigosupervisor == null ? null : codigosupervisor,
        "codigodigitador":
            codigodigitador == null ? null : codigodigitador,
        "turnotareo": turnotareo == null ? null : turnotareo,
        "key": key == null ? null : key,
        "idtipotarea": idtipotarea == null ? null : idtipotarea,
        "tipoTarea": tipoTarea == null ? null : tipoTarea,
        "sizeDetails": sizeDetails == null ? null : sizeDetails,
        "firmasupervisor": firmaSupervisor == null ? null : firmaSupervisor,
        "diasiguiente": diasiguiente == null ? null : diasiguiente,
        "idusuario": idusuario == null ? null : idusuario,
        
        "Personal_Pre_Tarea_Esparrago": detalles == null
            ? null
            : List<dynamic>.from(detalles.map((x) => x.toJson())),
      };
}

List<PreTareaEsparragoVariosEntity> preTareaEsparragoVariosEntityFromJson(String str) =>
    List<PreTareaEsparragoVariosEntity>.from(
        json.decode(str).map((x) => PreTareaEsparragoVariosEntity.fromJson(x)));

String preTareaEsparragoVariosEntityToJson(List<PreTareaEsparragoVariosEntity> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
