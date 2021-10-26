import 'package:flutter/cupertino.dart';
import 'package:flutter_tareo/core/colors.dart';
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/entities/subdivision_entity.dart';
import 'package:flutter_tareo/domain/entities/actividad_entity.dart';
import 'package:flutter_tareo/domain/entities/labor_entity.dart';
import 'package:flutter_tareo/domain/entities/centro_costo_entity.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';

part 'tarea_proceso_entity.g.dart';

@HiveType(typeId: 0)
class TareaProcesoEntity {
  TareaProcesoEntity({
    this.itemtareoproceso,
    this.codigoempresa,
    this.fecha,
    this.idactividad,
    this.idlabor,
    this.idcentrocosto,
    this.turnotareo,
    this.fechamod,
    this.idusuario,
    this.idestado,
    this.escampo,
    this.espacking,
    this.horainicio,
    this.horafin,
    this.pausainicio,
    this.pausafin,
    this.personal,
    this.diasiguiente,
    this.esjornal,
    this.esrendimiento,
    this.pathUrl,
    this.estadoLocal,
    this.key,
  }) {
    if (personal == null) {
      personal = [];
      estadoLocal='P';
    }
  }

  @HiveField(0)
  int itemtareoproceso;
  @HiveField(1)
  String codigoempresa;
  @HiveField(2)
  DateTime fecha;
  @HiveField(3)
  int idactividad;
  @HiveField(4)
  int idlabor;
  @HiveField(5)
  int idcentrocosto;
  @HiveField(6)
  String turnotareo;
  @HiveField(7)
  DateTime fechamod;
  @HiveField(8)
  int idusuario;
  @HiveField(9)
  int idestado;
  @HiveField(10)
  bool escampo;
  @HiveField(11)
  bool espacking;
  @HiveField(12)
  DateTime horainicio;
  @HiveField(13)
  DateTime horafin;
  @HiveField(14)
  DateTime pausainicio;
  @HiveField(15)
  DateTime pausafin;
  @HiveField(16)
  ActividadEntity actividad;
  @HiveField(17)
  LaborEntity labor;
  @HiveField(18)
  PersonalEmpresaEntity supervisor;
  @HiveField(19)
  SubdivisionEntity sede;
  @HiveField(20)
  List<PersonalTareaProcesoEntity> personal;
  @HiveField(21)
  bool diasiguiente;
  @HiveField(22)
  CentroCostoEntity centroCosto;
  @HiveField(23)
  bool esjornal;
  @HiveField(24)
  bool esrendimiento;
  @HiveField(25)
  String pathUrl;
  @HiveField(26)
  String estadoLocal;
  @HiveField(27)
  String firmaSupervisor;
  @HiveField(28)
  int key;

  String get fechaHora{
    if(fecha==null || horainicio==null){
      fecha=DateTime.now();
      horainicio=DateTime.now();
    }
    return DateFormat('dd').format(fecha) +
      "/" +
      DateFormat('MM', 'es').format(fecha) +
      "/" +
      DateFormat('yyyy').format(fecha) +
      "  " +
      DateFormat('hh:mm a').format(horainicio);
  }

  Color get colorEstado{
    switch (estadoLocal) {
      case 'P':
        return alertColor;
        break;
      case 'A':
        return successColor;
        break;
      case 'M':
        return infoColor;
        break;
      default:
        return primaryColor;
        break;
    }
  }

  factory TareaProcesoEntity.fromJson(Map<String, dynamic> json) =>
      TareaProcesoEntity(
        itemtareoproceso: json['itemtareoproceso'],
        codigoempresa: json['codigoempresa'],
        fecha: DateTime.parse(json['fecha']),
        idactividad: json['idactividad'],
        idlabor: json['idlabor'],
        idcentrocosto: json['idcentrocosto'],
        turnotareo: json['turnotareo'],
        fechamod: DateTime.parse(json['fechamod']),
        idusuario: json['idusuario'],
        idestado: json['idestado'],
        escampo: json['escampo'],
        espacking: json['espacking'],
        diasiguiente: json['diasiguiente'],
        esjornal: json['esjornal'],
        key: json['key'],
        esrendimiento: json['esrendimiento'],
        pathUrl: json['fileUrl'],
        horainicio: DateTime.parse(json['horainicio']),
        horafin: DateTime.parse(json['horafin']),
        pausainicio: DateTime.parse(json['pausainicio']),
        pausafin: DateTime.parse(json['pausafin']),
        estadoLocal: json['estadoLocal'],
        personal: json['personal']==null ? null : List<PersonalTareaProcesoEntity>.from(json["personal"].map((x) => PersonalTareaProcesoEntity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'itemtareoproceso': itemtareoproceso,
        'codigoempresa': codigoempresa,
        'estadoLocal': estadoLocal,
        'fecha': fecha?.toIso8601String(),
        'idactividad': idactividad,
        'idlabor': idlabor,
        'idcentrocosto': idcentrocosto,
        'turnotareo': turnotareo,
        'fechamod': fechamod?.toIso8601String(),
        'idusuario': idusuario,
        'idestado': idestado,
        'escampo': escampo,
        'espacking': espacking,
        'diasiguiente': diasiguiente,
        'esjornal': esjornal,
        'key': key,
        'esrendimiento': esrendimiento,
        'fileUrl': pathUrl,
        'horainicio': horainicio?.toIso8601String(),
        'horafin': horafin?.toIso8601String(),
        'pausainicio': pausainicio?.toIso8601String(),
        'pausafin': pausafin?.toIso8601String(),
        "personal": personal == null ? null : List<dynamic>.from(personal.map((x) => x.toJson())),
      };
}
