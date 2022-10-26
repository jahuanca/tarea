// To parse this JSON data, do
//
//     final personalPreTareaEsparragoEntity = personalPreTareaEsparragoEntityFromJson(jsonString);

import 'dart:convert';
import 'package:flutter_tareo/domain/entities/calibre_entity.dart';
import 'package:flutter_tareo/domain/entities/cliente_entity.dart';
import 'package:flutter_tareo/domain/entities/labor_entity.dart';
import 'package:flutter_tareo/domain/entities/via_envio_entity.dart';
import 'package:flutter_tareo/ui/utils/string_formats.dart';
import 'package:hive/hive.dart';
part 'personal_pre_tarea_esparrago_entity.g.dart';

@HiveType(typeId: 35)
class PersonalPreTareaEsparragoEntity {
    PersonalPreTareaEsparragoEntity({
        this.idSQLite,
        this.itempersonalpretareaesparrago,
        this.fecha,
        this.hora,
        this.idestado,
        this.itempretareaesparragovarios,
        this.codigotkcaja,
        this.idlabor,
        this.idcliente,
        this.idvia,
        this.correlativocaja,
        this.codigotkmesa,
        this.mesa,
        this.linea,
        this.correlativomesa,
        this.idusuario,
        this.fechamod,
        this.key,
        this.esperandoCierre,
        this.cliente,
        this.labor,
        this.calibre,
        this.viaEnvio,
        this.idcalibre,
        this.idSQLitePreTareaEsparrago,
    });


    @HiveField(0)
    int itempersonalpretareaesparrago;
    @HiveField(1)
    DateTime fecha;
    @HiveField(2)
    DateTime hora;
    @HiveField(3)
    int idestado;
    @HiveField(4)
    int itempretareaesparragovarios;
    @HiveField(5)
    String codigotkcaja;
    @HiveField(6)
    int idlabor;
    @HiveField(7)
    int idcliente;
    @HiveField(8)
    int idvia;
    @HiveField(9)
    int correlativocaja;
    @HiveField(10)
    String codigotkmesa;
    @HiveField(11)
    String mesa;
    @HiveField(12)
    String linea;
    @HiveField(13)
    int correlativomesa;
    @HiveField(14)
    int idusuario;
    @HiveField(15)
    DateTime fechamod;
    @HiveField(16)
    int key;
    @HiveField(17)
    bool esperandoCierre;
    @HiveField(18)
    ClienteEntity cliente;
    @HiveField(19)
    LaborEntity labor;
    @HiveField(20)
    CalibreEntity calibre;
    @HiveField(21)
    ViaEnvioEntity viaEnvio;
    @HiveField(22)
    int idcalibre;
    @HiveField(23)
    int idSQLite;
    @HiveField(24)
    int idSQLitePreTareaEsparrago;

    String keyString() {
      return '${formatoFechaExplore(fecha, 0, 0)}!${idcliente}!${idlabor}!${mesa}!${linea}';
    }

    factory PersonalPreTareaEsparragoEntity.fromJson(Map<String, dynamic> json) => PersonalPreTareaEsparragoEntity(
        itempersonalpretareaesparrago: json["itempersonalpretareaesparrago"] == null ? null : json["itempersonalpretareaesparrago"],
        fecha: json["fecha"] == null ? null : DateTime.parse(json["fecha"]),
        hora: json["hora"] == null ? null : DateTime.parse(json["hora"]),
        idSQLitePreTareaEsparrago: json["idSQLitePreTareaEsparrago"] == null ? null : json["idSQLitePreTareaEsparrago"],
        idestado: json["idestado"] == null ? null : json["idestado"],
        esperandoCierre: json["esperandoCierre"] == null ? null : json["esperandoCierre"],
        itempretareaesparragovarios: json["itempretareaesparragovarios"] == null ? null : json["itempretareaesparragovarios"],
        codigotkcaja: json["codigotkcaja"] == null ? null : json["codigotkcaja"],
        key: json["key"] == null ? null : json["key"],
        idlabor: json["idlabor"] == null ? null : json["idlabor"],
        idcliente: json["idcliente"] == null ? null : json["idcliente"],
        idcalibre: json["idcalibre"] == null ? null : json["idcalibre"],
        idvia: json["idvia"] == null ? null : json["idvia"],
        correlativocaja: json["correlativocaja"] == null ? null : json["correlativocaja"],
        codigotkmesa: json["codigotkmesa"] == null ? null : json["codigotkmesa"],
        mesa: json["mesa"] == null ? null : json["mesa"],
        linea: json["linea"] == null ? null : json["linea"],
        correlativomesa: json["correlativomesa"] == null ? null : json["correlativomesa"],
        idusuario: json["idusuario"] == null ? null : json["idusuario"],
        cliente: json['Cliente'] == null ? null : ClienteEntity.fromJson(json['Cliente']),
        labor: json['Labor'] == null ? null : LaborEntity.fromJson(json['Labor']),
        calibre: json['Calibre'] == null ? null : CalibreEntity.fromJson(json['Calibre']),
        viaEnvio: json['ViaEnvio'] == null ? null : ViaEnvioEntity.fromJson(json['ViaEnvio']),
        fechamod: json["fechamod"] == null ? null : DateTime.parse(json["fechamod"]),
    );

    Map<String, dynamic> toJson() => {
        "itempersonalpretareaesparrago": itempersonalpretareaesparrago == null ? null : itempersonalpretareaesparrago,
        "fecha": fecha == null ? null : "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
        "hora": hora == null ? null : hora.toIso8601String(),
        "idestado": idestado == null ? null : idestado,
        "key": key == null ? null : key,
        "idSQLitePreTareaEsparrago": idSQLitePreTareaEsparrago== null ? null : idSQLitePreTareaEsparrago,
        "esperandoCierre": esperandoCierre == null ? null : esperandoCierre,
        "itempretareaesparragovarios": itempretareaesparragovarios == null ? null : itempretareaesparragovarios,
        "codigotkcaja": codigotkcaja == null ? null : codigotkcaja,
        "idlabor": idlabor == null ? null : idlabor,
        "idcliente": idcliente == null ? null : idcliente,
        "idcalibre": idcalibre == null ? null : idcalibre,
        "idvia": idvia == null ? null : idvia,
        "correlativocaja": correlativocaja == null ? null : correlativocaja,
        "codigotkmesa": codigotkmesa == null ? null : codigotkmesa,
        "mesa": mesa == null ? null : mesa,
        "linea": linea == null ? null : linea,
        'Cliente': cliente?.toJson(),
        'Labor': labor?.toJson(),
        'Calibre': calibre?.toJson(),
        'ViaEnvio': viaEnvio?.toJson(),
        "correlativomesa": correlativomesa == null ? null : correlativomesa,
        "idusuario": idusuario == null ? null : idusuario,
        "fechamod": fechamod == null ? null : fechamod.toIso8601String(),
    };

    Map<String, dynamic> toDB() => {
        "itempersonalpretareaesparrago": itempersonalpretareaesparrago == null ? null : itempersonalpretareaesparrago,
        "fecha": fecha == null ? null : "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
        "hora": hora == null ? null : hora.toIso8601String(),
        "idestado": idestado == null ? null : idestado,
        "id_pre_tarea_esparrago": idSQLitePreTareaEsparrago== null ? null : idSQLitePreTareaEsparrago,
        "key": key == null ? null : key,
        "esperandoCierre": esperandoCierre == null ? null : esperandoCierre,
        "itempretareaesparragovarios": itempretareaesparragovarios == null ? null : itempretareaesparragovarios,
        "codigotkcaja": codigotkcaja == null ? null : codigotkcaja,
        "idlabor": idlabor == null ? null : idlabor,
        "idcliente": idcliente == null ? null : idcliente,
        "idcalibre": idcalibre == null ? null : idcalibre,
        "idvia": idvia == null ? null : idvia,
        "correlativocaja": correlativocaja == null ? null : correlativocaja,
        "codigotkmesa": codigotkmesa == null ? null : codigotkmesa,
        "mesa": mesa == null ? null : mesa,
        "linea": linea == null ? null : linea,
        "correlativomesa": correlativomesa == null ? null : correlativomesa,
        "idusuario": idusuario == null ? null : idusuario,
        "fechamod": fechamod == null ? null : fechamod.toIso8601String(),
    };
}


List<PersonalPreTareaEsparragoEntity> personalPreTareaEsparragoEntityFromJson(String str) => List<PersonalPreTareaEsparragoEntity>.from(json.decode(str).map((x) => PersonalPreTareaEsparragoEntity.fromJson(x)));

String personalPreTareaEsparragoEntityToJson(List<PersonalPreTareaEsparragoEntity> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));