import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tareo/di/agregar_persona_binding.dart';
import 'package:flutter_tareo/di/listado_personas_binding.dart';
import 'package:flutter_tareo/di/nueva_tarea_binding.dart';
import 'package:flutter_tareo/domain/entities/personal_tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/entities/tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/use_cases/migrar/migrar_all_tarea_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/migrar/upload_file_of_tarea_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/others/export_tarea_to_excel_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/personal_tarea_proceso/create_personal_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/personal_tarea_proceso/get_all_personal_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/tareas/create_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/tareas/delete_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/tareas/get_all_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/tareas/update_tarea_proceso_use_case.dart';
import 'package:flutter_tareo/ui/pages/agregar_persona/agregar_persona_page.dart';
import 'package:flutter_tareo/ui/pages/listado_personas/listado_personas_page.dart';
import 'package:flutter_tareo/ui/pages/nueva_tarea/nueva_tarea_page.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:get/get.dart';
import 'package:image_editor_pro/image_editor_pro.dart';

class TareasController extends GetxController {

  bool validando=false;

  final CreateTareaProcesoUseCase _createTareaProcesoUseCase;
  final GetAllTareaProcesoUseCase _getAllTareaProcesoUseCase;
  final UpdateTareaProcesoUseCase _updateTareaProcesoUseCase;
  final DeleteTareaProcesoUseCase _deleteTareaProcesoUseCase;
  final MigrarAllTareaUseCase _migrarAllTareaUseCase;
  final UploadFileOfTareaUseCase _uploadFileOfTareaUseCase;
  final ExportTareaToExcelUseCase _exportTareaToExcelUseCase;

  


  final GetAllPersonalTareaProcesoUseCase _getAllPersonalTareaProcesoUseCase;
  final CreatePersonalTareaProcesoUseCase _createPersonalTareaProcesoUseCase;

  TareasController(
      this._createTareaProcesoUseCase,
      this._getAllTareaProcesoUseCase,
      this._updateTareaProcesoUseCase,
      this._deleteTareaProcesoUseCase,
      this._migrarAllTareaUseCase,
      this._uploadFileOfTareaUseCase,
      this._exportTareaToExcelUseCase,
      this._getAllPersonalTareaProcesoUseCase,
      this._createPersonalTareaProcesoUseCase,
      );

  @override
  void onInit() async {
    super.onInit();
    await getTareas();
  }

  Future<void> getTareas() async {
    tareas = await _getAllTareaProcesoUseCase.execute();
    return;
  }

  void onChangedMenu(dynamic value, int key) async {
    int index=tareas.indexWhere((element) => element.key == key);
    switch (value.toInt()) {
      case 1:
        await _exportTareaToExcelUseCase.execute(key);
        break;
      case 2:
        goCopiar(index);
        break;
      case 3:
        goEliminar(key);
        break;
      default:
        break;
    }
  }

  Future<String> validarParaAprobar(int index) async {
    TareaProcesoEntity tarea = tareas[index];
    if (tarea.sizeDetails == null || tarea.sizeDetails == 0) {
      return 'No se puede aprobar una tarea que no tiene personal';
    } else {
      tarea.personal=await _getAllPersonalTareaProcesoUseCase.execute('personal_tarea_proceso_${tarea.key}');
      for (PersonalTareaProcesoEntity item in tarea?.personal) {
        if(item.validadoParaAprobar!=null){
          return item.validadoParaAprobar;
        }
      }
    }
    return null;
  }

  void goAprobar(int key) async {
    int index = tareas.indexWhere((element) => element.key == key);
    String mensaje = await validarParaAprobar(index);
    if (mensaje != null) {
      basicAlert(
        Get.overlayContext,
        'Alerta',
        mensaje,
        'Aceptar',
        () => Get.back(),
      );
    } else {
      basicDialog(
        Get.overlayContext,
        'Alerta',
        '¿Desea aprobar esta tarea?',
        'Si',
        'No',
        () async {
          Get.back();
          await getimageditor(index);
        },
        () => Get.back(),
      );
    }
  }

  Future<void> getimageditor(int index) async {
    Navigator.push(Get.overlayContext, MaterialPageRoute(builder: (context) {
      return ImageEditorPro(
        appBarColor: Color(0xFF009ee0),
        bottomBarColor: Colors.white,
      );
    })).then((geteditimage) async {
      if (geteditimage != null) {
        File _image = geteditimage[0];

        tareas[index].pathUrl = _image.path;
        tareas[index].estadoLocal = 'A';
        await _updateTareaProcesoUseCase.execute(
            tareas[index], tareas[index].key);

        update(['seleccionado']);
      }
    }).catchError((er) {
      print(er);
    });
  }

  Future<void> goAgregarPersona(int index) async {
    AgregarPersonaBinding().dependencies();
    final resultado = await Get.to<PersonalTareaProcesoEntity>(
        () => AgregarPersonaPage(),
        arguments: {
          'personal_seleccionado': tareas[index].personal,
          'tarea': tareas[index],
          'sede': tareas[index].sede
        });
    if (resultado != null) {
      /* tareas[index].personal.add(resultado); */
      tareas[index].sizeDetails = tareas[index].sizeDetails + 1;
      await _updateTareaProcesoUseCase.execute(
          tareas[index], tareas[index].key);
      update(['tareas']);
    }
  }

  Future<void> goListadoPersonas(int key) async {
    int index=tareas.indexWhere((e) => e.key == key);
    ListadoPersonasBinding().dependencies();
    final resultado = await Get.to<List<num>>(() => ListadoPersonasPage(),
        arguments: {
          'tarea': tareas[index],
          'index': index,
          'sede': tareas[index].sede
        });

    if (resultado != null) {
      validando=true;
      update(['validando']);
      tareas[index].sizeDetails = resultado.first;
      tareas[index].cantidadAvance = resultado.last;
      await _updateTareaProcesoUseCase.execute(
          tareas[index], tareas[index].key);
      validando=false;
      update(['validando', 'tareas']);
    }
  }

  Future<void> delete(int index) async {
    await _deleteTareaProcesoUseCase.execute(tareas[index].key);
    tareas.removeAt(index);
  }

  List<int> seleccionados = [];
  List<TareaProcesoEntity> tareas = [];

  void seleccionar(int index) {
    int i = seleccionados.indexWhere((element) => element == index);
    if (i == -1) {
      seleccionados.add(index);
    } else {
      seleccionados.removeAt(i);
    }
    update(['seleccionado']);
  }

  Future<void> goNuevaTarea() async {
    NuevaTareaBinding().dependencies();
    final result = await Get.to<TareaProcesoEntity>(() => NuevaTareaPage());
    if (result != null) {
      result.idusuario = PreferenciasUsuario().idUsuario;
      int id = await _createTareaProcesoUseCase.execute(result);
      result.key = id;
      tareas.add(result);
      update(['tareas']);
    }
  }

  Future<void> editarTarea(int index) async {
    NuevaTareaBinding().dependencies();
    final result = await Get.to<TareaProcesoEntity>(() => NuevaTareaPage(),
        arguments: {'tarea': tareas[index]});
    if (result != null) {
      result.idusuario = PreferenciasUsuario().idUsuario;
      tareas[index] = result;
      await _updateTareaProcesoUseCase.execute(
          tareas[index], tareas[index].key);
      update(['tareas']);
    }
  }

  Future<void> copiarTarea(int index) async {
    NuevaTareaBinding().dependencies();
    final result = await Get.to<TareaProcesoEntity>(() => NuevaTareaPage(),
        arguments: {'tarea': tareas[index], 'copiando': true});
    if (result != null) {
      List<PersonalTareaProcesoEntity> personalCopiar=[];
      personalCopiar.addAll(
      await _getAllPersonalTareaProcesoUseCase.execute('personal_tarea_proceso_${tareas[index].key}')
      ?? []);
      result.idusuario = PreferenciasUsuario().idUsuario;
      result.sizeDetails=personalCopiar.length;
      int id = await _createTareaProcesoUseCase.execute(result);
      result.key = id;
      tareas.add(result);

      for (var p in personalCopiar) {
        p.horainicio=result.horainicio;
        p.horafin=result.horafin;
        p.pausainicio=result.pausainicio;
        p.pausafin=result.pausafin;
        await _createPersonalTareaProcesoUseCase.execute('personal_tarea_proceso_${id}', p);
      }
      
      update(['tareas', 'seleccionado']);
    }
  }

  Future<void> goEliminar(int key) async{
    int index=tareas.indexWhere((e) => e.key==key);
    if(index==-1) toastError('Error', 'No se pudo eliminar la tarea.');
    await basicDialog(
      Get.overlayContext,
      'Alerta',
      '¿Esta seguro de eliminar esta tarea?',
      'Si',
      'No',
      () async {
        await delete(index);
        update(['tareas']);
        Get.back();
      },
      () => Get.back(),
    );
  }

  Future<void> goCopiar(int index) async{
    basicDialog(
      Get.overlayContext,
      'Alerta',
      '¿Esta seguro de copiar la siguiente tarea?',
      'Si',
      'No',
      () async {
        Get.back();
        await copiarTarea(index);
      },
      () => Get.back(),
    );
  }

  void goEditar(int key) {
    int index = tareas.indexWhere((element) => element.key == key);
    basicDialog(
      Get.overlayContext,
      'Alerta',
      '¿Esta seguro de editar la siguiente tarea?',
      'Si',
      'No',
      () async {
        Get.back();
        await editarTarea(index);
      },
      () => Get.back(),
    );
  }

  void goMigrar(int key) {
    int index=tareas.indexWhere((element) => element.key == key);
    if (tareas[index].estadoLocal == 'A') {
      basicDialog(
        Get.overlayContext,
        'Alerta',
        '¿Desea migrar esta tarea?',
        'Si',
        'No',
        () async {
          Get.back();
          await migrar(index);
        },
        () => Get.back(),
      );
    } else {
      basicAlert(
        Get.overlayContext,
        'Alerta',
        'Esta tarea aun no ha sido aprobada',
        'Aceptar',
        () => Get.back(),
      );
    }
  }

  Future<void> migrar(int index) async {
    validando = true;
    update(['validando']);
    TareaProcesoEntity tareaMigrada =
        await _migrarAllTareaUseCase.execute(tareas[index].key);
    if (tareaMigrada != null) {
      toastExito('Exito', 'Tarea migrada con exito');
      tareas[index].estadoLocal = 'M';
      tareas[index].itemtareoproceso = tareaMigrada.itemtareoproceso;
      await _updateTareaProcesoUseCase.execute(tareas[index], tareas[index].key);
      tareaMigrada = await _uploadFileOfTareaUseCase.execute(
          tareas[index], File(tareas[index].pathUrl));
      tareas[index].firmaSupervisor = tareaMigrada?.firmaSupervisor;
      await _updateTareaProcesoUseCase.execute(tareas[index], tareas[index].key);
    }
    validando = false;

    update(['validando', 'tareas']);
  }
}
