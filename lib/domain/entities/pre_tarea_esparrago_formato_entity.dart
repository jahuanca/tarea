import 'package:flutter_tareo/domain/entities/cliente_entity.dart';
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
    this.fecha,
    this.hora,
    this.idestado,
    this.codigotk,
    this.idusuario,
    this.idlabor,
    this.labor,
    this.correlativo,
    this.idactividad,
    this.idcliente,
    this.cliente,
    this.actividad,
    this.imei,
    this.detalles,
    this.key,
    this.linea,
    this.sizeDetails,
  });

  @HiveField(0)
  int itemprestareaesparragoformato;
  @HiveField(1)
  int itempretareaesparrago;
  @HiveField(3)
  int idcliente;
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
  ClienteEntity cliente;
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
  /* @HiveField(16) */
  List<PreTareaEsparragoDetalleEntity> detalles;
  @HiveField(17)
  int correlativo;
  @HiveField(18)
  int key;
  @HiveField(19)
  int linea;
  @HiveField(20)
  int sizeDetails;

  bool get validadoParaAprobar{
    if(idcliente==null || hora==null){
      return false;
    }
    
    return true;
  }

  factory PreTareaEsparragoFormatoEntity.fromJson(Map<String, dynamic> json) =>
      PreTareaEsparragoFormatoEntity(
        itemprestareaesparragoformato: json['itemprestareaesparragoformato'],
        itempretareaesparrago: json['itempretareaproceso'],
        idcliente: json['idcliente'],
        idactividad: json['idactividad'],
        hora: DateTime?.parse(json['hora']),
        imei: json['imei'],
        linea: json['linea'],
        sizeDetails: json['sizeDetails'],
        idusuario: json['idusuario'],
        fecha: DateTime?.parse(json['fecha']),
        idlabor: json['idlabor'],
        correlativo: json['correlativo'],
        idestado: json['idestado'],
        key: json['key'],
        codigotk: json['codigotk'],
        cliente: json['cliente'] == null ? null : ClienteEntity.fromJson(json['cliente']),
        detalles: json['Pre_Tarea_Esparrago_Detalle'] == null
            ? null
            : List<PreTareaEsparragoDetalleEntity>.from(
                json["Pre_Tarea_Esparrago_Detalle"]
                    .map((x) => PreTareaEsparragoDetalleEntity.fromJson(x))),

      );

  Map<String, dynamic> toJson() => {
        'itemprestareaesparragoformato': itemprestareaesparragoformato,
        'itempretareaesparrago': itempretareaesparrago,
        'idcliente': idcliente,
        'idactividad': idactividad,
        'hora': hora?.toIso8601String(),
        'imei': imei,
        'linea': linea,
        'sizeDetails': sizeDetails,
        'idusuario': idusuario,
        'key': key,
        'fecha': fecha?.toIso8601String(),
        'correlativo': correlativo,
        'idlabor': idlabor,
        'idestado': idestado,
        'codigotk': codigotk,
        'cliente': cliente?.toJson(),
        "Pre_Tarea_Esparrago_Detalle": detalles == null
            ? null
            : List<dynamic>.from(detalles.map((x) => x.toJson())),
      };
}
