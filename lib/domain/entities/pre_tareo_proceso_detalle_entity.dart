import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:hive/hive.dart';

part 'pre_tareo_proceso_detalle_entity.g.dart';

@HiveType(typeId: 18)
class PreTareoProcesoDetalleEntity {
  PreTareoProcesoDetalleEntity({
    this.item,
    this.itempretareaproceso,
    this.codigoempresa,
    this.hora,
    this.numcaja,
    this.imei,
    this.fecha,
    this.idestado,
    this.idusuario,
    this.personal,
    this.codigotk,
  });

  @HiveField(0)
  int item;
  @HiveField(1)
  int itempretareaproceso;
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

  bool get validadoParaAprobar{
    if(codigoempresa==null || hora==null){
      return false;
    }
    
    return true;
  }

  factory PreTareoProcesoDetalleEntity.fromJson(Map<String, dynamic> json) =>
      PreTareoProcesoDetalleEntity(
        item: json['item'],
        itempretareaproceso: json['itempretareaproceso'],
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
        'item': item,
        'itempretareaproceso': itempretareaproceso,
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
