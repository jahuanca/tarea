import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/entities/actividad_entity.dart';
import 'package:flutter_tareo/domain/entities/labor_entity.dart';
import 'package:hive/hive.dart';

part 'pre_tarea_esparrago_detalle_entity.g.dart';

@HiveType(typeId: 27)
class PreTareaEsparragoDetalleEntity {
  PreTareaEsparragoDetalleEntity({
    this.itempretareaesparragodetalle,
    this.itemprestareaesparragoformato,
    this.codigoempresa,
    this.fecha,
    this.hora,
    this.idestado,    
    this.personal,
    this.codigotk,
    this.correlativo,
    this.idusuario,
    this.idlabor,
    this.linea,
    this.labor,
    this.idactividad,
    this.actividad,
    this.imei,
    this.idcliente,
  });

  @HiveField(0)
  int itempretareaesparragodetalle;
  @HiveField(1)
  int itemprestareaesparragoformato;
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
  int linea;
  @HiveField(17)
  int idcliente;

  bool get validadoParaAprobar{
    if(codigoempresa==null || hora==null){
      return false;
    }
    
    return true;
  }

  factory PreTareaEsparragoDetalleEntity.fromJson(Map<String, dynamic> json) =>
      PreTareaEsparragoDetalleEntity(
        itempretareaesparragodetalle: json['itempretareaesparragodetalle'],
        itemprestareaesparragoformato: json['itemprestareaesparragoformato'],
        codigoempresa: json['codigoempresa'],
        idactividad: json['idactividad'],
        hora: DateTime?.parse(json['hora']),
        imei: json['imei'],
        idusuario: json['idusuario'],
        linea: json['linea'],
        idcliente: json['idcliente'],
        correlativo: json['correlativo'],
        fecha: DateTime?.parse(json['fecha']),
        idlabor: json['idlabor'],
        idestado: json['idestado'],
        codigotk: json['codigotk'],

      );

  Map<String, dynamic> toJson() => {
        'itempretareaesparragodetalle': itempretareaesparragodetalle,
        'itemprestareaesparragoformato': itemprestareaesparragoformato,
        'codigoempresa': codigoempresa,
        'idactividad': idactividad,
        'hora': hora?.toIso8601String(),
        'imei': imei,
        'idcliente': idcliente,
        'idusuario': idusuario,
        'correlativo': correlativo,
        'linea': linea,
        'fecha': fecha?.toIso8601String(),
        
        'idlabor': idlabor,
        'idestado': idestado,
        'codigotk': codigotk,
      };
}
