import 'package:flutter_tareo/domain/entities/cliente_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/entities/actividad_entity.dart';
import 'package:flutter_tareo/domain/entities/labor_entity.dart';
import 'package:hive/hive.dart';

part 'pre_tarea_esparrago_detalle_varios_entity.g.dart';

@HiveType(typeId: 22)
class PreTareaEsparragoDetalleVariosEntity {
  PreTareaEsparragoDetalleVariosEntity({
    this.itempretareaesparragodetallevarios,
    this.itempretareaesparragovarios,
    this.codigoempresa,
    this.fecha,
    this.hora,
    this.idestado,
    this.personal,
    this.codigotk,
    this.correlativo,
    this.idusuario,
    this.idlabor,
    this.labor,
    this.idactividad,
    this.actividad,
    this.imei,
    this.key,
    this.linea,
    this.esCaja,
    this.idcliente,
    this.cliente,
    this.itemtipotk,
  });

  @HiveField(0)
  int itempretareaesparragodetallevarios;
  @HiveField(1)
  int itempretareaesparragovarios;
  @HiveField(2)
  int correlativo;
  @HiveField(3)
  String codigoempresa;
  @HiveField(4)
  DateTime hora;
  @HiveField(5)
  String imei;
  @HiveField(6)
  DateTime fecha;
  @HiveField(7)
  int idestado;
  @HiveField(8)
  int idusuario;
  @HiveField(9)
  PersonalEmpresaEntity personal;
  @HiveField(10)
  String codigotk;
  @HiveField(11)
  int idlabor;
  @HiveField(12)
  int idactividad;
  @HiveField(14)
  ActividadEntity actividad;
  @HiveField(15)
  LaborEntity labor;
  @HiveField(16)
  int key;
  @HiveField(17)
  int linea;
  @HiveField(18)
  bool esCaja;
  @HiveField(19)
  int idcliente;
  @HiveField(20)
  ClienteEntity cliente;
  @HiveField(21)
  int itemtipotk;

  bool get validadoParaAprobar {
    if (codigoempresa == null || hora == null) {
      return false;
    }

    return true;
  }

  factory PreTareaEsparragoDetalleVariosEntity.fromJson(
          Map<String, dynamic> json) =>
      PreTareaEsparragoDetalleVariosEntity(
        itempretareaesparragodetallevarios:
            json['itempretareaesparragodetallevarios'],
        itempretareaesparragovarios: json['itempretareaproceso'],
        codigoempresa: json['codigoempresa'],
        idactividad: json['idactividad'],
        hora: DateTime?.parse(json['hora']),
        imei: json['imei'],
        key: json['key'],
        idcliente: json['idcliente'],
        cliente: json['Cliente'] == null ? null : ClienteEntity.fromJson(json['Cliente']),
        linea: json['linea'],
        idusuario: json['idusuario'],
        correlativo: json['correlativo'],
        esCaja: json['esCaja'],
        fecha: DateTime?.parse(json['fecha']),
        idlabor: json['idlabor'],
        idestado: json['idestado'],
        codigotk: json['codigotk'],
        itemtipotk: json['itemtipotk'],
      );

  Map<String, dynamic> toJson() => {
        'itempretareaesparragodetallevarios':
            itempretareaesparragodetallevarios,
        'itempretareaesparragovarios': itempretareaesparragovarios,
        'codigoempresa': codigoempresa,
        'itemtipotk': itemtipotk,
        'idactividad': idactividad,
        'hora': hora?.toIso8601String(),
        'imei': imei,
        'key': key,
        'idusuario': idusuario,
        'correlativo': correlativo,
        'esCaja': esCaja,
        'linea': linea,
        'fecha': fecha?.toIso8601String(),
        'idlabor': idlabor,
        'idestado': idestado,
        'idcliente': idcliente,
        'Cliente': cliente?.toJson(),
        'codigotk': codigotk,
      };
}
