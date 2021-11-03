import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/entities/actividad_entity.dart';
import 'package:flutter_tareo/domain/entities/labor_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_detalle_entity.dart';
import 'package:hive/hive.dart';

part 'pre_tarea_esparrago_formato_entity.g.dart';

@HiveType(typeId: 26)
class PreTareaEsparragoFormatoEntity {
  PreTareaEsparragoFormatoEntity({
    this.itemprestareaesparragoformato,
    this.itempretareaesparrago,
    this.codigoempresa,
    this.fecha,
    this.hora,
    this.idestado,
    this.personal,
    this.codigotk,
    this.idusuario,
    this.idlabor,
    this.labor,
    this.correlativo,
    this.idactividad,
    this.actividad,
    this.imei,
    this.detalle,
  });

  @HiveField(0)
  int itemprestareaesparragoformato;
  @HiveField(1)
  int itempretareaesparrago;
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
  PreTareaEsparragoDetalleEntity detalle;
  @HiveField(17)
  int correlativo;

  bool get validadoParaAprobar{
    if(codigoempresa==null || hora==null){
      return false;
    }
    
    return true;
  }

  factory PreTareaEsparragoFormatoEntity.fromJson(Map<String, dynamic> json) =>
      PreTareaEsparragoFormatoEntity(
        itemprestareaesparragoformato: json['itemprestareaesparragoformato'],
        itempretareaesparrago: json['itempretareaproceso'],
        codigoempresa: json['codigoempresa'],
        idactividad: json['idactividad'],
        hora: DateTime?.parse(json['hora']),
        imei: json['imei'],
        idusuario: json['idusuario'],
        fecha: DateTime?.parse(json['fecha']),
        idlabor: json['idlabor'],
        correlativo: json['correlativo'],
        idestado: json['idestado'],
        codigotk: json['codigotk'],
        detalle: json['Pre_Tarea_Esparrago_Detalle'],

      );

  Map<String, dynamic> toJson() => {
        'itemprestareaesparragoformato': itemprestareaesparragoformato,
        'itempretareaesparrago': itempretareaesparrago,
        'codigoempresa': codigoempresa,
        'idactividad': idactividad,
        'hora': hora?.toIso8601String(),
        'imei': imei,
        'idusuario': idusuario,
        'fecha': fecha?.toIso8601String(),
        'correlativo': correlativo,
        'idlabor': idlabor,
        'idestado': idestado,
        'codigotk': codigotk,
        'Pre_Tarea_Esparrago_Detalle': detalle?.toJson(),
      };
}
