import 'dart:developer';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_tareo/di/agregar_persona_binding.dart';
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/entities/subdivision_entity.dart';
import 'package:flutter_tareo/domain/entities/tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_personal_empresa_by_subdivision_use_case.dart';
import 'package:flutter_tareo/ui/pages/agregar_persona/agregar_persona_page.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:get/get.dart';

class ListadoPersonasController extends GetxController {
  List<int> seleccionados = [];
  List<PersonalEmpresaEntity> personal = [];
  List<PersonalTareaProcesoEntity> personalSeleccionado = [];
  GetPersonalsEmpresaBySubdivisionUseCase _getPersonalsEmpresaBySubdivisionUseCase;
  bool validando=false;

  ListadoPersonasController(this._getPersonalsEmpresaBySubdivisionUseCase);

  @override
  void onInit() async{
    super.onInit();
    if (Get.arguments != null) {
      if (Get.arguments['personal_seleccionado'] != null) {
        personalSeleccionado = Get.arguments['personal_seleccionado']
            as List<PersonalTareaProcesoEntity>;
        update(['personal_seleccionado']);
      }

      if (Get.arguments['personal'] != null) {
        personal = Get.arguments['personal'] as List<PersonalEmpresaEntity>;
        update(['personal']);
      }else{
        validando=true;
        update(['validando']);
        personal= await _getPersonalsEmpresaBySubdivisionUseCase.execute(
          (Get.arguments['sede'] as SubdivisionEntity).idsubdivision
        );
        validando=false;
        update(['validando']);
      }
    }
    print(personal.length);
  }

  void seleccionar(int index) {
    int i = seleccionados.indexWhere((element) => element == index);
    if (i == -1) {
      seleccionados.add(index);
    } else {
      seleccionados.removeAt(i);
    }
    update(['seleccionado']);
  }

  Future<bool> onWillPop()async{
    Get.back(result: personalSeleccionado);
    return true;
  }

  void goNuevoPersonaTareaProceso() async {
    AgregarPersonaBinding().dependencies();
    final result = await Get.to<PersonalTareaProcesoEntity>(
        () => AgregarPersonaPage(),
        arguments: {'personal': personal});
    if (result != null) {
      personalSeleccionado.add(result);
      update(['personal_seleccionado']);
      seleccionados.clear();
      update(['seleccionados']);
    }
  }

  Future<void> changeOptionsGlobal(dynamic index) async {
    switch (index) {
      case 3:
        AgregarPersonaBinding().dependencies();
        final result = await Get.to<PersonalTareaProcesoEntity>(
            () => AgregarPersonaPage(),
            arguments: {'cantidad': seleccionados.length, 'personal' : personal});
        if (result != null) {
          personalSeleccionado.add(result);
          update(['personal_seleccionado']);
          seleccionados.clear();
          update(['seleccionados']);
        }
        break;
      default:
    }
  }

  void goLectorCode() {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            "#ff6666", "Cancelar", false, ScanMode.BARCODE)
        .listen((barcode) {
      print(barcode);

      /// barcode to be used
      if (barcode != null) {
        int indexEncontrado=personalSeleccionado.indexWhere((e) => e.personal.codigoempresa == barcode.toString());
        if(indexEncontrado!=-1){
          log('ya se encuentra registrado');
          return;
        }
        int index = personal.indexWhere((e) => e.codigoempresa == barcode.toString());
        if (index != -1) {
          log('se agrego');
          personalSeleccionado.add(new PersonalTareaProcesoEntity(
            personal: personal[index],
          ));
          update(['personal_seleccionado']);
        }
        else{
          log('no se eucnetra en la lista');
        }
      }
    });
  }
}
