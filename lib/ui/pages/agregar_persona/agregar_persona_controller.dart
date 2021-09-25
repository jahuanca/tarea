import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/entities/subdivision_entity.dart';
import 'package:flutter_tareo/domain/entities/tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_personal_empresa_by_subdivision_use_case.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:get/get.dart';

class AgregarPersonaController extends GetxController {
  GetPersonalsEmpresaBySubdivisionUseCase
      _getPersonalsEmpresaBySubdivisionUseCase;
  int cantidadEnviada = 0;
  List<PersonalEmpresaEntity> personalEmpresa = [];
  bool validando = false;
  bool actualizando = false;

  DateTime horaInicio, horaFin, inicioPausa, finPausa;
  TareaProcesoEntity tareaSeleccionada;

  PersonalEmpresaEntity personaSeleccionada;
  PersonalTareaProcesoEntity personalTareaProcesoEntity =
      new PersonalTareaProcesoEntity();

  AgregarPersonaController(this._getPersonalsEmpresaBySubdivisionUseCase);

  //TODO: horaInicio, horaFin, inicioPausa y finPausa se heredan de la tarea.
  //TODO:  agregar check de dia siguiente
  //TODO: cantidad se autocalculada: horaFin - horaInicio - (finPausa - inicioPausa) en horas

  @override
  void onInit() async {
    super.onInit();
    if (Get.arguments != null) {
      if (Get.arguments['tarea'] != null) {
        tareaSeleccionada = Get.arguments['tarea'] as TareaProcesoEntity;
        personalTareaProcesoEntity.horainicio = tareaSeleccionada.horainicio;
        personalTareaProcesoEntity.horafin = tareaSeleccionada.horafin;
        personalTareaProcesoEntity.pausainicio = tareaSeleccionada.pausainicio;
        personalTareaProcesoEntity.pausafin = tareaSeleccionada.pausafin;
        update(['hora_inicio', 'hora_fin', 'pausa_inicio', 'pausa_fin']);
      }
      if (Get.arguments['cantidad'] != null) {
        cantidadEnviada = Get.arguments['cantidad'] as int;
        actualizando = true;
      }
      if (Get.arguments['personal'] != null) {
        personalEmpresa =
            Get.arguments['personal'] as List<PersonalEmpresaEntity>;
        if (personalEmpresa.length > 0) {
          personaSeleccionada = personalEmpresa.first;
          personalTareaProcesoEntity.personal = personaSeleccionada;
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
            personalTareaProcesoEntity.personal = personaSeleccionada;
          }
          validando = false;
        }
      }
    }

    update(['personal', 'validando']);
  }

  void changePersonal(String id) {
    personaSeleccionada =
        personalEmpresa.firstWhere((e) => e.codigoempresa == id);
    personalTareaProcesoEntity.personal = personaSeleccionada;
  }

  void guardar() {
    if (actualizando) {
      List<PersonalTareaProcesoEntity> personalRespuesta=[];
      for (final p in personalEmpresa) {
        personalRespuesta.add(
          PersonalTareaProcesoEntity(
            personal: p,
            horainicio: personalTareaProcesoEntity.horainicio, 
            horafin: personalTareaProcesoEntity.horafin, 
            pausainicio: personalTareaProcesoEntity.pausainicio, 
            pausafin: personalTareaProcesoEntity.pausafin,
          )
        );
      }

      Get.back(result: personalRespuesta);
      return;
    }

    if (personalTareaProcesoEntity.personal == null) {
      toastError('Error', 'No existe persona seleccionada');
      return;
    }
    Get.back(result: personalTareaProcesoEntity);
  }

  void changeHoraInicio() {
    personalTareaProcesoEntity.horainicio = horaInicio;
    update(['hora_inicio']);
  }

  void changeHoraFin() {
    personalTareaProcesoEntity.horafin = horaFin;
    update(['hora_fin']);
  }

  void changeInicioPausa() {
    personalTareaProcesoEntity.pausainicio = inicioPausa;
    update(['inicio_pausa']);
  }

  void changeFinPausa() {
    personalTareaProcesoEntity.pausafin = finPausa;
    update(['fin_pausa']);
  }
}
