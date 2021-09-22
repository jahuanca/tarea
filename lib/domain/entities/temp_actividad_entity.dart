// To parse this JSON data, do
//
//     final tempActividadEntity = tempActividadEntityFromJson(jsonString);

import 'dart:convert';
import 'package:hive/hive.dart';

part 'temp_actividad_entity.g.dart';
@HiveType(typeId : 1)
class TempActividadEntity {
    TempActividadEntity({
        this.actividad,
        this.descAct,
        this.indJoRe,
        this.sociedad,
        this.fechamod,
        this.horamod,
    });

    @HiveField(0)
    String actividad;
    @HiveField(1)
    String descAct;
    @HiveField(2)
    String indJoRe;
    @HiveField(3)
    String sociedad;
    @HiveField(4)
    DateTime fechamod;
    @HiveField(5)
    DateTime horamod;

    factory TempActividadEntity.fromJson(Map<String, dynamic> json) => TempActividadEntity(
        actividad: json["ACTIVIDAD"],
        descAct: json["DESC_ACT"],
        indJoRe: json["IND_JO_RE"],
        sociedad: json["SOCIEDAD"],
        fechamod: DateTime.parse(json["Fechamod"]),
        horamod: DateTime.parse(json["Horamod"]),
    );

    Map<String, dynamic> toJson() => {
        "ACTIVIDAD": actividad,
        "DESC_ACT": descAct,
        "IND_JO_RE": indJoRe,
        "SOCIEDAD": sociedad,
        "Fechamod": "${fechamod.year.toString().padLeft(4, '0')}-${fechamod.month.toString().padLeft(2, '0')}-${fechamod.day.toString().padLeft(2, '0')}",
        "Horamod": horamod.toIso8601String(),
    };
}


List<TempActividadEntity> tempActividadEntityFromJson(String str) => List<TempActividadEntity>.from(json.decode(str).map((x) => TempActividadEntity.fromJson(x)));

String tempActividadEntityToJson(List<TempActividadEntity> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));