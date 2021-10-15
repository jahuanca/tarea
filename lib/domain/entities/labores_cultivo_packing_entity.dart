import 'dart:convert';

import 'package:flutter_tareo/domain/entities/actividad_entity.dart';
import 'package:flutter_tareo/domain/entities/cultivo_entity.dart';
import 'package:flutter_tareo/domain/entities/labor_entity.dart';
import 'package:flutter_tareo/domain/entities/presentacion_linea_entity.dart';

import 'package:hive/hive.dart';

part 'labores_cultivo_packing_entity.g.dart';

@HiveType(typeId: 17)

class LaboresCultivoPackingEntity {
    LaboresCultivoPackingEntity({
        this.item,
        this.idcultivo,
        this.idlabor,
        this.idactividad,
        this.fechamod,
        this.activo,
        this.idpresentacion,
        this.labor,
        this.cultivo,
        this.actividad,
        this.presentacionLinea,
    });

    @HiveField(0)
    int item;
    @HiveField(1)
    int idcultivo;
    @HiveField(2)
    int idlabor;
    @HiveField(3)
    int idactividad;
    @HiveField(4)
    DateTime fechamod;
    @HiveField(5)
    bool activo;
    @HiveField(6)
    int idpresentacion;
    @HiveField(7)
    LaborEntity labor;
    @HiveField(8)
    CultivoEntity cultivo;
    @HiveField(9)
    ActividadEntity actividad;
    @HiveField(10)
    PresentacionLineaEntity presentacionLinea;

    factory LaboresCultivoPackingEntity.fromJson(Map<String, dynamic> json) => LaboresCultivoPackingEntity(
        item: json["item"] == null ? null : json["item"],
        idcultivo: json["idcultivo"] == null ? null : json["idcultivo"],
        idlabor: json["idlabor"] == null ? null : json["idlabor"],
        idactividad: json["idactividad"] == null ? null : json["idactividad"],
        fechamod: json["fechamod"] == null ? null : DateTime.parse(json["fechamod"]),
        activo: json["activo"] == null ? null : json["activo"],
        idpresentacion: json["idpresentacion"] == null ? null : json["idpresentacion"],
        labor: json["Labor"] == null ? null : LaborEntity.fromJson(json["Labor"]),
        cultivo: json["Cultivo"] == null ? null : CultivoEntity.fromJson(json["Cultivo"]),
        actividad: json["Actividad"] == null ? null : ActividadEntity.fromJson(json["Actividad"]),
        presentacionLinea: json["Presentacion_Linea"] == null ? null : PresentacionLineaEntity.fromJson(json["Presentacion_Linea"]),
    );

    Map<String, dynamic> toJson() => {
        "item": item == null ? null : item,
        "idcultivo": idcultivo == null ? null : idcultivo,
        "idlabor": idlabor == null ? null : idlabor,
        "idactividad": idactividad == null ? null : idactividad,
        "fechamod": fechamod == null ? null : fechamod.toIso8601String(),
        "activo": activo == null ? null : activo,
        "idpresentacion": idpresentacion == null ? null : idpresentacion,
        "Labor": labor == null ? null : labor.toJson(),
        "Cultivo": cultivo == null ? null : cultivo.toJson(),
        "Actividad": actividad == null ? null : actividad.toJson(),
        "Presentacion_Linea": presentacionLinea == null ? null : presentacionLinea.toJson(),
    };
}

List<LaboresCultivoPackingEntity> laboresCultivoPackingEntityFromJson(String str) => List<LaboresCultivoPackingEntity>.from(json.decode(str).map((x) => LaboresCultivoPackingEntity.fromJson(x)));

String laboresCultivoPackingEntityToJson(List<LaboresCultivoPackingEntity> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

