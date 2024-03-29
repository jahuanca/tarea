import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:hive/hive.dart';

part 'personal_tarea_proceso_entity.g.dart';

@HiveType(typeId: 5)
class PersonalTareaProcesoEntity {
  PersonalTareaProcesoEntity({
    this.item,
    this.itemtareoproceso,
    this.codigoempresa,
    this.transferidosap,
    this.horainicio,
    this.horafin,
    this.pausainicio,
    this.pausafin,
    this.fechainicio,
    this.fechafin,
    this.turno,
    this.diasiguiente,
    this.fechamod,
    this.cantidadHoras,
    this.cantidadrendimiento,
    this.cantidadavance,
    this.idestado,
    this.idusuario,
    this.esrendimiento,
    this.esjornal,
    this.idactividad,
    this.personal,
    this.key,
  });

  @HiveField(0)
  int item;
  @HiveField(1)
  int itemtareoproceso;
  @HiveField(2)
  String codigoempresa;
  @HiveField(3)
  bool transferidosap;
  @HiveField(4)
  DateTime horainicio;
  @HiveField(5)
  DateTime horafin;
  @HiveField(6)
  DateTime pausainicio;
  @HiveField(7)
  DateTime pausafin;
  @HiveField(8)
  DateTime fechainicio;
  @HiveField(9)
  DateTime fechafin;
  @HiveField(10)
  String turno;
  @HiveField(11)
  bool diasiguiente;
  @HiveField(12)
  DateTime fechamod;
  @HiveField(13)
  double cantidadHoras;
  @HiveField(14)
  double cantidadrendimiento;
  @HiveField(15)
  double cantidadavance;
  @HiveField(16)
  int idestado;
  @HiveField(17)
  int idusuario;
  @HiveField(18)
  PersonalEmpresaEntity personal;
  @HiveField(19)
  bool esrendimiento;
  @HiveField(20)
  bool esjornal;
  @HiveField(21)
  bool idactividad;
  @HiveField(22)
  int key;

  String get validadoParaAprobar{
    if(codigoempresa==null || horainicio==null || horafin==null){
      return 'Complete todo los datos';
    }

    /* if(esrendimiento && cantidadavance==0){
      return 'Tiene registros de tipo rendimiento y cantidad de avance 0';
    } */
    
    return null;
  }

  factory PersonalTareaProcesoEntity.fromJson(Map<String, dynamic> json) =>
      PersonalTareaProcesoEntity(
        item: json['item'],
        key: json['key'],
        itemtareoproceso: json['itemtareoproceso'],
        codigoempresa: json['codigoempresa'],
        transferidosap: json['transferidosap'],
        horainicio: DateTime?.tryParse(json['horainicio']),
        horafin: DateTime?.tryParse(json['horafin']),
        pausainicio: DateTime?.tryParse(json['pausainicio']),
        pausafin: DateTime?.tryParse(json['pausafin']),
        fechainicio: DateTime?.tryParse(json['fechainicio']),
        fechafin: DateTime?.tryParse(json['fechafin']),
        turno: json['turno'],
        diasiguiente: json['diasiguiente'],
        esjornal: json['esjornal'],
        esrendimiento: json['esrendimiento'],
        idactividad: json['idactividad'],
        fechamod: DateTime?.tryParse(json['fechamod']),
        cantidadHoras: json['cantidadhoras'],
        cantidadrendimiento: json['cantidadrendimiento'],
        cantidadavance: json['cantidadavance'],
        idestado: json['idestado'],
        idusuario: json['idusuario'],
      );

  Map<String, dynamic> toJson() => {
        'item': item,
        'key': key,
        'itemtareoproceso': itemtareoproceso,
        'codigoempresa': codigoempresa,
        'transferidosap': transferidosap,
        'horainicio': horainicio?.toIso8601String(),
        'horafin': horafin?.toIso8601String(),
        'pausainicio': pausainicio?.toIso8601String(),
        'pausafin': pausafin?.toIso8601String(),
        'fechainicio': fechainicio?.toIso8601String(),
        'fechafin': fechafin?.toIso8601String(),
        'turno': turno,
        'diasiguiente': diasiguiente,
        'idactividad': idactividad,
        'esjornal': esjornal,
        'esrendimiento': esrendimiento,
        'fechamod': fechamod?.toIso8601String(),
        'cantidadhoras': cantidadHoras,
        'cantidadrendimiento': cantidadrendimiento,
        'cantidadavance': cantidadavance,
        'idestado': idestado,
        'idusuario': idusuario,
      };
}
