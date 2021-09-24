import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/entities/subdivision_entity.dart';
import 'package:flutter_tareo/domain/use_cases/agregar_persona/get_personal_empresa_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_personal_empresa_by_subdivision_use_case.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:get/get.dart';

class AgregarPersonaController extends GetxController {
  GetPersonalsEmpresaBySubdivisionUseCase _getPersonalsEmpresaBySubdivisionUseCase;
  int cantidadEnviada = 0;
  List<PersonalEmpresaEntity> personalEmpresa = [];
  bool validando = false;

  DateTime horaInicio, horaFin, inicioPausa, finPausa;

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
      if (Get.arguments['cantidad'] != null) {
        cantidadEnviada = Get.arguments['cantidad'] as int;
      }
      if (Get.arguments['personal'] != null) {
        personalEmpresa =
            Get.arguments['personal'] as List<PersonalEmpresaEntity>;
        if (personalEmpresa.length > 0) {
          personaSeleccionada = personalEmpresa.first;
          personalTareaProcesoEntity.personal = personaSeleccionada;
        }
      }else{
        if(Get.arguments['sede'] != null){
          validando=true;
          update(['validando']);
          personalEmpresa= await _getPersonalsEmpresaBySubdivisionUseCase.execute(
            (Get.arguments['sede'] as SubdivisionEntity).idsubdivision
          );
          if (personalEmpresa.length > 0) {
            personaSeleccionada = personalEmpresa.first;
            personalTareaProcesoEntity.personal = personaSeleccionada;
          }
          validando=false;
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
    if(personalTareaProcesoEntity.personal==null){
      toastError('Error', 'No existe persona seleccionada');
      return;
    }
    Get.back(result: personalTareaProcesoEntity);
  }

    void changeHoraInicio(){
    personalTareaProcesoEntity.horainicio=horaInicio;
    update(['hora_inicio']);
  }

  void changeHoraFin(){
    personalTareaProcesoEntity.horafin=horaFin;
    update(['hora_fin']);
  }

  void changeInicioPausa(){
    personalTareaProcesoEntity.pausainicio=inicioPausa;
    update(['inicio_pausa']);
  }

  void changeFinPausa(){
    personalTareaProcesoEntity.pausafin=finPausa;
    update(['fin_pausa']);
  }
}
