import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/entities/actividad_entity.dart';
import 'package:flutter_tareo/domain/entities/labor_entity.dart';
import 'package:flutter_tareo/domain/entities/presentacion_linea_entity.dart';
import 'package:hive/hive.dart';

part 'pre_tareo_proceso_uva_detalle_entity.g.dart';

@HiveType(typeId: 20)
class PreTareoProcesoUvaDetalleEntity {
  PreTareoProcesoUvaDetalleEntity({
    this.itempretareoprocesouvadetalle,
    this.itempretareaprocesouva,
    this.codigoempresa,
    this.hora,
    this.numcaja,
    this.imei,
    this.fecha,
    this.idestado,
    this.idusuario,
    this.personal,
    this.codigotk,
    this.labor,
    this.actividad,
    this.presentacion,
  });

  @HiveField(0)
  int itempretareoprocesouvadetalle;
  @HiveField(1)
  int itempretareaprocesouva;
  @HiveField(2)
  String codigoempresa;
  @HiveField(3)
  DateTime hora;
  @HiveField(4)
  int numcaja;
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
  @HiveField(13)
  int idpresentacion;
  @HiveField(14)
  ActividadEntity actividad;
  @HiveField(15)
  LaborEntity labor;
  @HiveField(16)
  PresentacionLineaEntity presentacion;

  bool get validadoParaAprobar{
    if(codigoempresa==null || hora==null){
      return false;
    }
    
    return true;
  }

  factory PreTareoProcesoUvaDetalleEntity.fromJson(Map<String, dynamic> json) =>
      PreTareoProcesoUvaDetalleEntity(
        itempretareoprocesouvadetalle: json['item'],
        itempretareaprocesouva: json['itempretareaproceso'],
        codigoempresa: json['codigoempresa'],
        hora: DateTime?.parse(json['hora']),
        numcaja: json['numcaja'],
        imei: json['imei'],
        fecha: DateTime?.parse(json['fecha']),
        idestado: json['idestado'],
        idusuario: json['idusuario'],
        codigotk: json['codigotk'],

      );

  Map<String, dynamic> toJson() => {
        'item': itempretareoprocesouvadetalle,
        'itempretareaproceso': itempretareaprocesouva,
        'codigoempresa': codigoempresa,
        'hora': hora?.toIso8601String(),
        'numcaja': numcaja,
        'imei': imei,
        'fecha': fecha?.toIso8601String(),
        'idestado': idestado,
        'idusuario': idusuario,
        'codigotk': codigotk,
      };
}
