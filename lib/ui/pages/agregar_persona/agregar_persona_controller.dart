import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/entities/subdivision_entity.dart';
import 'package:flutter_tareo/domain/entities/tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_personal_empresa_by_subdivision_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/personal_tarea_proceso/create_personal_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/personal_tarea_proceso/update_personal_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:flutter_tareo/ui/utils/validators_utils.dart';
import 'package:get/get.dart';

class AgregarPersonaController extends GetxController {
  GetPersonalsEmpresaBySubdivisionUseCase
      _getPersonalsEmpresaBySubdivisionUseCase;
  int cantidadEnviada = 0;
  List<PersonalEmpresaEntity> personalEmpresa = [];
  List<PersonalTareaProcesoEntity> personalSeleccionado = [];
  bool validando = false;
  bool actualizando = false;
  bool editando = false;

  TareaProcesoEntity tareaSeleccionada;

  PersonalEmpresaEntity personaSeleccionada;
  PersonalTareaProcesoEntity nuevoPersonal =
      new PersonalTareaProcesoEntity();
  CreatePersonalTareaProcesoUseCase _createPersonalTareaProcesoUseCase;
  UpdatePersonalTareaProcesoUseCase _updatePersonalTareaProcesoUseCase;

  String errorHoraInicio,
      errorHoraFin,
      errorPausaInicio,
      errorPausaFin,
      errorPersonal,
      errorCantidadHoras,
      errorCantidadRendimiento,
      errorCantidadAvance;

  String textoCantidadHoras = '---Sin calcular---';

  AgregarPersonaController(
    this._getPersonalsEmpresaBySubdivisionUseCase,
    this._createPersonalTareaProcesoUseCase,
    this._updatePersonalTareaProcesoUseCase,
  );


  void extraerDetalles(){
    /*nuevoPersonal.cantidadavance = 0;
    nuevoPersonal.cantidadrendimiento = 0;
    nuevoPersonal.turno = tareaSeleccionada.turnotareo;
    nuevoPersonal.esjornal = tareaSeleccionada.esjornal;
    nuevoPersonal.esrendimiento = tareaSeleccionada.esrendimiento;
    nuevoPersonal.diasiguiente = tareaSeleccionada.diasiguiente;*/

    nuevoPersonal.horainicio = tareaSeleccionada.horainicio;
    nuevoPersonal.horafin = tareaSeleccionada.horafin;
    nuevoPersonal.pausainicio = tareaSeleccionada.pausainicio;
    nuevoPersonal.pausafin = tareaSeleccionada.pausafin;
    nuevoPersonal.cantidadavance = 0;
    nuevoPersonal.cantidadrendimiento = 0;
    nuevoPersonal.turno = tareaSeleccionada.turnotareo;
    nuevoPersonal.esjornal = tareaSeleccionada.esjornal;
    nuevoPersonal.esrendimiento = tareaSeleccionada.esrendimiento;
    nuevoPersonal.diasiguiente = tareaSeleccionada.diasiguiente;

    changeCantidadAvance(nuevoPersonal.cantidadavance!=null ? nuevoPersonal.cantidadavance.toString() :  '0');
    changeRendimiento(nuevoPersonal.esjornal ?? false);
    changeCantidadRendimiento(nuevoPersonal.cantidadrendimiento!=null ? nuevoPersonal.cantidadrendimiento.toString() :  '0');
    changeTurno(nuevoPersonal.turno!=null ? nuevoPersonal.turno.toString() :  'D');
    changeDiaSiguiente(nuevoPersonal.diasiguiente ?? false);
    
    calcularCantidadHoras();
    update([
          'hora_inicio',
          'hora_fin',
          'pausa_inicio',
          'pausa_fin',
          'turno',
          'dia_siguiente',
          'rendimiento'
        ]);
  }

  @override
  void onInit() async {
    super.onInit();
    if (Get.arguments != null) {
      if (Get.arguments['tarea'] != null) {
        tareaSeleccionada = Get.arguments['tarea'] as TareaProcesoEntity;

        extraerDetalles();
        
      }
      if (Get.arguments['cantidad'] != null) {
        cantidadEnviada = Get.arguments['cantidad'] as int;
        actualizando = true;
      }

      if (Get.arguments['personal_tarea_proceso'] != null) {
        nuevoPersonal = Get.arguments['personal_tarea_proceso'] as PersonalTareaProcesoEntity;
        editando = true;
        
      }

      if (Get.arguments['personal_seleccionado'] != null) {
        personalSeleccionado = Get.arguments['personal_seleccionado']
            as List<PersonalTareaProcesoEntity>;
      }


      if (Get.arguments['personal'] != null) {
        personalEmpresa =
            Get.arguments['personal'] as List<PersonalEmpresaEntity>;
        if (personalEmpresa.length > 0) {
          if(editando){
            personaSeleccionada=nuevoPersonal.personal;
          }else{
            personaSeleccionada = personalEmpresa.first;
            nuevoPersonal.codigoempresa=personalEmpresa.first.codigoempresa;
          }
          changePersonal(nuevoPersonal.codigoempresa ?? 'null');
        }
      } else {
        if (Get.arguments['sede'] != null) {
          validando = true;
          update(['validando']);
          personalEmpresa =
              await _getPersonalsEmpresaBySubdivisionUseCase.execute(
                  (Get.arguments['sede'] as SubdivisionEntity).idsubdivision);
          if (personalEmpresa.length > 0) {
            personaSeleccionada = personalEmpresa.first;
            nuevoPersonal.personal = personaSeleccionada;
          }
          validando = false;
        }
      }
    }

    update(['personal', 'validando']);
  }

  Future<void> changePersonal(String id) async {
    personaSeleccionada =
        personalEmpresa?.firstWhere((e) => e.codigoempresa == id);
    int index = personalSeleccionado.indexWhere((e) => e.codigoempresa == id);
    if (index != -1) {
      nuevoPersonal.personal = personaSeleccionada;
      nuevoPersonal.personal.codigoempresa =
          personaSeleccionada.codigoempresa;
      mostrarDialog('Personal ya registrado');
      errorPersonal = 'Personal ya se encuentra registrado.';
    } else {
      errorPersonal = null;
      nuevoPersonal.personal = personaSeleccionada;
      nuevoPersonal.personal.codigoempresa =
          personaSeleccionada.codigoempresa;
    }
    update(['personal']);
  }

  void deleteInicioPausa() {
    nuevoPersonal.pausainicio = null;
    update(['inicio_pausa']);
  }

  void deleteFinPausa() {
    nuevoPersonal.pausafin = null;
    update(['fin_pausa']);
  }

  void guardar() async {
    String mensaje = validar();
    if (mensaje != null) {
      toastError('Error', mensaje);
      return;
    }
    if (actualizando) {
      List<PersonalTareaProcesoEntity> personalRespuesta = [];
      for (final p in personalEmpresa) {
        PersonalTareaProcesoEntity d = PersonalTareaProcesoEntity(
          personal: p,
          codigoempresa: p.codigoempresa,
          idusuario: PreferenciasUsuario().idUsuario,
          horainicio: nuevoPersonal.horainicio,
          horafin: nuevoPersonal.horafin,
          pausainicio: nuevoPersonal.pausainicio,
          pausafin: nuevoPersonal.pausafin,
          cantidadHoras: nuevoPersonal.cantidadHoras,
          cantidadavance: nuevoPersonal.cantidadavance,
          cantidadrendimiento: nuevoPersonal.cantidadrendimiento,
        );
        //await _updatePersonalTareaProcesoUseCase.execute('personal_tarea_proceso_${tareaSeleccionada.key}', d.key, detalle)
        personalRespuesta.add(d);
      }
      Get.back(result: personalRespuesta);
      return;
    }


    if (nuevoPersonal.personal == null) {
      toastError('Error', 'No existe persona seleccionada');
      return;
    }
    nuevoPersonal.codigoempresa =
        nuevoPersonal.personal.codigoempresa;
    nuevoPersonal.idusuario = PreferenciasUsuario().idUsuario;
    Get.back(result: nuevoPersonal);
  }

  Future<void> changeRendimiento(bool value) async {
    if (value) {
      nuevoPersonal.esjornal = true;
      nuevoPersonal.esrendimiento = false;
      errorCantidadRendimiento = null;
    } else {
      nuevoPersonal.esjornal = false;
      nuevoPersonal.esrendimiento = true;
    }
    update(['rendimiento', 'actividades', 'cantidad_rendimiento']);
  }

  Future<void> changeDiaSiguiente(bool value) async {
    nuevoPersonal.diasiguiente = value;
    update(['dia_siguiente']);
  }

  void changeTurno(String value) {
    nuevoPersonal.turno = value;
    update(['turno']);
  }

  void changeCantidadRendimiento(String value) {
    errorCantidadRendimiento = validatorUtilText(
        value,
        'Rendmiento',
        nuevoPersonal.esrendimiento
            ? {
                'required': '',
              }
            : null);

    if (errorCantidadRendimiento != null) {
      update(['cantidad_rendimiento']);
      return;
    }

    double rendimiento = double.tryParse(value);
    if (rendimiento != null) {
      nuevoPersonal.cantidadrendimiento = rendimiento;
      errorCantidadRendimiento = null;
    } else {
      if ([null, ''].contains(value) &&
          nuevoPersonal.esrendimiento) {
        errorCantidadRendimiento = null;
        nuevoPersonal.cantidadrendimiento = null;
      } else {
        errorCantidadRendimiento = 'El valor ingresado no es un número';
      }
    }

    update(['cantidad_rendimiento']);
  }

  void changeCantidadAvance(String value) {
    print(value);
    if ([null, ''].contains(value)) {
      errorCantidadAvance = null;
      update(['cantidad_avance']);
      return;
    }
    double avance = double.tryParse(value);
    if (avance != null) {
      nuevoPersonal.cantidadavance = avance;
      errorCantidadAvance = null;
    } else {
      errorCantidadAvance = 'El valor ingresado no es un número';
    }

    update(['cantidad_avance']);
  }

  void calcularCantidadHoras() {
    int cantidadHoras;
    int cantidadMinutos;
    if (nuevoPersonal.horainicio == null ||
        nuevoPersonal.horafin == null) {
      return;
    }
    DateTime hInicio = nuevoPersonal.horainicio;
    DateTime hFin = nuevoPersonal.horafin;

    if (hFin.isBefore(hInicio)) {
      hFin.add(Duration(days: 1));
    }

    cantidadMinutos = hFin.difference(hInicio).inMinutes;
    if (nuevoPersonal.pausainicio != null &&
        nuevoPersonal.pausafin != null) {
      DateTime pInicio = nuevoPersonal.pausainicio;
      DateTime pFin = nuevoPersonal.pausafin;

      if (pFin.isBefore(pInicio)) {
        pFin.add(Duration(days: 1));
      }

      cantidadMinutos -= pFin.difference(pInicio).inMinutes;
    }

    nuevoPersonal.cantidadHoras = cantidadMinutos / 60;
    cantidadHoras = (cantidadMinutos / 60).truncate();
    cantidadMinutos = cantidadMinutos % 60;

    textoCantidadHoras = '$cantidadHoras h $cantidadMinutos min';
    update(['cantidad_horas']);
  }

  void changeHoraInicio() {
    errorHoraInicio = (nuevoPersonal.horainicio == null)
        ? 'Debe elegir una hora de inicio'
        : null;
    calcularCantidadHoras();
    update(['hora_inicio', 'inicio_pausa', 'fin_pausa']);
  }

  void changeHoraFin() {
    errorHoraFin = (nuevoPersonal.horafin == null)
        ? 'Debe elegir una hora de fin'
        : null;
    calcularCantidadHoras();
    update(['hora_fin', 'inicio_pausa', 'fin_pausa']);
  }

  void changeInicioPausa() {
    /* if (personalTareaProcesoEntity.pausainicio != null) {
      if (personalTareaProcesoEntity.pausainicio
              .isBefore(personalTareaProcesoEntity.horainicio) ||
          personalTareaProcesoEntity.pausainicio
              .isAfter(personalTareaProcesoEntity.horafin)) {
        mostrarDialog(
            'La hora seleccionada no se encuentra en el rango de inicio y fin');
        personalTareaProcesoEntity.pausainicio = null;
      }
      update(['inicio_pausa']);
    } */
    update(['inicio_pausa']);
    calcularCantidadHoras();
  }

  void changeFinPausa() {
    /* if (personalTareaProcesoEntity.pausafin != null) {
      if (personalTareaProcesoEntity.pausafin
              .isBefore(personalTareaProcesoEntity.horainicio) ||
          personalTareaProcesoEntity.pausafin
              .isAfter(personalTareaProcesoEntity.horafin)) {
        mostrarDialog(
            'La hora seleccionada no se encuentra en el rango de inicio y fin');
        personalTareaProcesoEntity.pausafin = null;
      }
      if (personalTareaProcesoEntity.pausainicio != null &&
          personalTareaProcesoEntity.pausafin
              .isAfter(personalTareaProcesoEntity.pausainicio)) {
        mostrarDialog('La hora debe ser mayor a la hora de pausa');
        personalTareaProcesoEntity.pausafin = null;
      }
      update(['fin_pausa']);
    } */
    update(['fin_pausa']);
    calcularCantidadHoras();
  }

  void mostrarDialog(String mensaje) {
    basicAlert(
      Get.overlayContext,
      'Alerta',
      mensaje,
      'Aceptar',
      () => Get.back(),
    );
  }

  String validar() {
    changeHoraInicio();
    changeHoraFin();
    changePersonal(personaSeleccionada.codigoempresa);
    changeCantidadRendimiento(
        nuevoPersonal.cantidadrendimiento.toString());

    if (errorPersonal != null) return errorPersonal;
    if (errorHoraInicio != null) return errorHoraInicio;
    if (errorHoraFin != null) return errorHoraFin;

    if (nuevoPersonal.pausainicio != null &&
        nuevoPersonal.pausafin == null) {
      errorPausaFin = 'Debe ingresar la hora de fin de pausa';
      return errorPausaFin;
    }
    errorPausaFin = null;
    if (nuevoPersonal.pausafin != null &&
        nuevoPersonal.pausainicio == null) {
      errorPausaInicio = 'Debe ingresar la hora de inicio de pausa';
      return errorPausaInicio;
    }
    errorPausaInicio = null;

    return null;
  }
}
