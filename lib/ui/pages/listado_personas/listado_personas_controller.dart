import 'dart:convert';
import 'dart:developer';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tareo/di/agregar_persona_binding.dart';
import 'package:flutter_tareo/domain/entities/personal_empresa_entity.dart';
import 'package:flutter_tareo/domain/entities/personal_tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/entities/subdivision_entity.dart';
import 'package:flutter_tareo/domain/entities/tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_personal_empresa_by_subdivision_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/tareas/update_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/ui/pages/agregar_persona/agregar_persona_page.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:get/get.dart';

class ListadoPersonasController extends GetxController {
  List<int> seleccionados = [];
  List<PersonalEmpresaEntity> personal = [];
  List<PersonalTareaProcesoEntity> personalSeleccionado = [];
  int indexTarea;
  TareaProcesoEntity tarea;
  GetPersonalsEmpresaBySubdivisionUseCase _getPersonalsEmpresaBySubdivisionUseCase;
  UpdateTareaProcesoUseCase _updateTareaProcesoUseCase;
  bool validando=false;
  bool editando=false;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  ListadoPersonasController(this._getPersonalsEmpresaBySubdivisionUseCase, this._updateTareaProcesoUseCase);

  @override
  void onInit() async{
    super.onInit();
    if (Get.arguments != null) {
      if (Get.arguments['tarea'] != null) {
        tarea=Get.arguments['tarea'] as TareaProcesoEntity;
        personalSeleccionado = tarea.personal;
        update(['personal_seleccionado']);
      }

      if(Get.arguments['index'] !=null){
        editando=true;
        indexTarea=Get.arguments['index'] as int;
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
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android: android, iOS: iOS);

    await flutterLocalNotificationsPlugin.initialize(initSettings, onSelectNotification: _onSelectNotification);
  }

  Future<void> _showNotification(bool success, String mensaje) async {
    final android = AndroidNotificationDetails(
      'channel id',
      'channel name',
      'channel description',
      priority: Priority.high,
      importance: Importance.max
    );
    final iOS = IOSNotificationDetails();
    final platform = NotificationDetails(android: android, iOS: iOS);
    false;
    final isSuccess = true;

    await flutterLocalNotificationsPlugin.show(
      0,
      success ? 'Exito' : 'Error',
      mensaje,
      platform,
      payload: '',
    );
  }

  Future<dynamic> _onSelectNotification(String json) async {
    return;
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

    personalSeleccionado.forEach((e) {
      if(e.horainicio==null){
        toastError('Error', 'Existe un personal con datos vacios. Por favor, ingreselos.');
        return false;
      }
    });

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
        final result = await Get.to<List<PersonalTareaProcesoEntity>>(
            () => AgregarPersonaPage(),
            arguments: {'cantidad': seleccionados.length, 'personal' : personal});
        if (result != null) {
          for(int i=0; i<seleccionados.length; i++){
            personalSeleccionado[seleccionados[i]]=result[i];
          }
          update(['personal_seleccionado']);
          seleccionados.clear();
          update(['seleccionados']);
        }
        break;
      default:
    }
  }

  Future<void> changeOptions(dynamic index) async {
    switch (index) {
      case 1:
        AgregarPersonaBinding().dependencies();
        final result = await Get.to<PersonalTareaProcesoEntity>(
            () => AgregarPersonaPage(),
            arguments: {'cantidad': seleccionados.length, 'personal' : personal});
        if (result != null) {
          personalSeleccionado[index]=result;
          update(['personal_seleccionado']);
        }
        break;
      case 2:
        goEliminar(index);
        
        break;
      default:
        break;
    }
  }

  void goEliminar(int index){

    basicDialog(
      Get.overlayContext, 
      'Alerta', 
      '¿Esta eliminar el personal?', 
      'Si', 
      'No', 
      ()async{
        Get.back();
        personalSeleccionado.removeAt(index);
        await _updateTareaProcesoUseCase.execute(tarea, indexTarea);
        update(['seleccionado']);
      }, 
      ()=> Get.back(),
    );
  }

  void goLectorCode() {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            "#ff6666", "Cancelar", false, ScanMode.DEFAULT)
        .listen((barcode) {
      print(barcode);

      if (barcode != null) {
        int indexEncontrado=personalSeleccionado.indexWhere((e) => e.personal.codigoempresa == barcode.toString());
        if(indexEncontrado!=-1){
          _showNotification(false, 'Ya se encuentra registrado');
          return;
        }
        int index = personal.indexWhere((e) => e.codigoempresa == barcode.toString());
        if (index != -1) {
          _showNotification(true, 'Registrado con exito');
          personalSeleccionado.add(new PersonalTareaProcesoEntity(
            personal: personal[index],
          ));
          update(['personal_seleccionado']);
        }
        else{
          _showNotification(false, 'No se encuentra en la lista');
        }
      }
    });
  }
}
