// To parse this JSON data, do
//
//     final tempActividadEntity = tempActividadEntityFromJson(jsonString);

import 'dart:convert';

List<TempActividadEntity> tempActividadEntityFromJson(String str) => List<TempActividadEntity>.from(json.decode(str).map((x) => TempActividadEntity.fromJson(x)));

String tempActividadEntityToJson(List<TempActividadEntity> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TempActividadEntity {
    TempActividadEntity({
        this.actividad,
        this.descAct,
        this.indJoRe,
        this.sociedad,
        this.fechamod,
        this.horamod,
    });

    String actividad;
    String descAct;
    String indJoRe;
    Sociedad sociedad;
    DateTime fechamod;
    DateTime horamod;

    factory TempActividadEntity.fromJson(Map<String, dynamic> json) => TempActividadEntity(
        actividad: json["ACTIVIDAD"],
        descAct: json["DESC_ACT"],
        indJoRe: json["IND_JO_RE"],
        sociedad: sociedadValues.map[json["SOCIEDAD"]],
        fechamod: DateTime.parse(json["Fechamod"]),
        horamod: DateTime.parse(json["Horamod"]),
    );

    Map<String, dynamic> toJson() => {
        "ACTIVIDAD": actividad,
        "DESC_ACT": descAct,
        "IND_JO_RE": indJoRe,
        "SOCIEDAD": sociedadValues.reverse[sociedad],
        "Fechamod": "${fechamod.year.toString().padLeft(4, '0')}-${fechamod.month.toString().padLeft(2, '0')}-${fechamod.day.toString().padLeft(2, '0')}",
        "Horamod": horamod.toIso8601String(),
    };
}

enum Sociedad { PE10, PE20 }

final sociedadValues = EnumValues({
    "PE10": Sociedad.PE10,
    "PE20": Sociedad.PE20
});

class EnumValues<T> {
    Map<String, T> map;
    Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        if (reverseMap == null) {
            reverseMap = map.map((k, v) => new MapEntry(v, k));
        }
        return reverseMap;
    }
}
