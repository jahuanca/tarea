import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/utils/numbers.dart';
import 'package:flutter_tareo/di/listado_personas_pre_tareo_uva_binding.dart';
import 'package:flutter_tareo/di/nueva_pre_tarea_uva_binding.dart';
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_uva_entity.dart';
import 'package:flutter_tareo/domain/use_cases/others/export_packing_to_excel_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos_uva/create_pre_tareo_proceso_uva_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos_uva/delete_pre_tareo_proceso_uva_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos_uva/get_all_pre_tareo_proceso_uva_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos_uva/migrar_all_pre_tareo_uva_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos_uva/update_pre_tareo_proceso_uva_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos_uva/upload_file_of_pre_tareo_uva_use_case.dart';
import 'package:flutter_tareo/ui/control_asistencia/utils/ids.dart';
import 'package:flutter_tareo/ui/control_asistencia/utils/strings.dart';
import 'package:flutter_tareo/ui/pages/listado_personas_pre_tareo_uva/listado_personas_pre_tareo_uva_page.dart';
import 'package:flutter_tareo/ui/pages/nueva_pre_tarea_uva/nueva_pre_tarea_uva_page.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/constants.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:flutter_tareo/ui/utils/type_toast.dart';
import 'package:get/get.dart';
import 'package:image_editor_pro/image_editor_pro.dart';

class PreTareosUvaController extends GetxController {
  final CreatePreTareoProcesoUvaUseCase _createPreTareoProcesoUvaUseCase;
  final GetAllPreTareoProcesoUvaUseCase _getAllPreTareoProcesoUvaUseCase;
  final UpdatePreTareoProcesoUvaUseCase _updatePreTareoProcesoUvaUseCase;
  final DeletePreTareoProcesoUvaUseCase _deletePreTareoProcesoUvaUseCase;
  final MigrarAllPreTareoUvaUseCase _migrarAllPreTareoUvaUseCase;
  final UploadFileOfPreTareoUvaUseCase _uploadFileOfPreTareoUvaUseCase;
  final ExportPackingToExcelUseCase _exportPackingToExcelUseCase;

  bool validando = BOOLEAN_FALSE_VALUE;
  List<int> seleccionados = [];
  List<PreTareoProcesoUvaEntity> preTareosUva = [];

  PreTareosUvaController(
    this._createPreTareoProcesoUvaUseCase,
    this._getAllPreTareoProcesoUvaUseCase,
    this._updatePreTareoProcesoUvaUseCase,
    this._deletePreTareoProcesoUvaUseCase,
    this._migrarAllPreTareoUvaUseCase,
    this._uploadFileOfPreTareoUvaUseCase,
    this._exportPackingToExcelUseCase,
  );

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() async {
    await getTareas();
    super.onReady();
  }

  Future<void> getTareas() async {
    preTareosUva.clear();
    preTareosUva.addAll(await _getAllPreTareoProcesoUvaUseCase.execute());
    update([ALL_PAGE_ID]);
  }

  Future<void> onChangedMenu(dynamic value, int key) async {
    switch (value.toInt()) {
      case 1:
        break;
      case 2:
        goCopiar(key);
        break;
      case 3:
        goEliminar(key);
        break;
      case 4:
        await goExcel(key);
        break;
      default:
        break;
    }
  }

  Future<void> goExcel(int key) async {
    int indexElement = preTareosUva.indexWhere((e) => e.key == key);
    if (indexElement != ELEMENT_NOT_FOUND) {
      validando = BOOLEAN_TRUE_VALUE;
      update([VALIDANDO_ID]);
      await _exportPackingToExcelUseCase.execute(key);
      validando = BOOLEAN_FALSE_VALUE;
      update([VALIDANDO_ID]);
    } else {
      toast(
          type: TypeToast.ERROR,
          message: ERROR_NOT_FOUNT_ELEMENT_TO_EXPORT_STRING);
    }
  }

  void goAprobar(int key) async {
    int indexElement = preTareosUva.indexWhere((e) => e.key == key);
    if (indexElement != ELEMENT_NOT_FOUND) {
      String mensaje = await _validarParaAprobar(indexElement);
      if (mensaje != null) {
        basicAlert(
          context: Get.overlayContext,
          message: mensaje,
          onPressed: () => Get.back(),
        );
      } else {
        basicDialog(
          context: Get.overlayContext,
          message: '¿Desea aprobar esta actividad?',
          onPressed: () async {
            Get.back();
            await _getimageditor(indexElement);
          },
          onCancel: () => Get.back(),
        );
      }
    } else {
      toast(
          type: TypeToast.ERROR,
          message: ERROR_NOT_FOUNT_ELEMENT_TO_CHECK_STRING);
    }
  }

  Future<void> _getimageditor(int index) async {
    Navigator.push(Get.overlayContext, MaterialPageRoute(builder: (context) {
      return ImageEditorPro(
        appBarColor: Color(0xFF009ee0),
        bottomBarColor: Colors.white,
      );
    })).then((geteditimage) async {
      if (geteditimage != null) {
        File _image = geteditimage[0];

        preTareosUva[index].pathUrl = _image.path;
        preTareosUva[index].estadoLocal = 'A';
        await _updatePreTareoProcesoUvaUseCase.execute(
            preTareosUva[index], preTareosUva[index].key);
        update(['$ELEMENT_OF_LIST_ID${preTareosUva[index].key}']);
      }
    }).catchError((er) {
      print(er);
    });
  }

  Future<String> _validarParaAprobar(int index) async {
    PreTareoProcesoUvaEntity tarea = preTareosUva[index];
    if (tarea.sizeDetails == null || tarea.sizeDetails == EMPTY_ARRAY_LENGTH) {
      return 'No se puede aprobar una actividad que no tiene personal';
    }
    return null;
  }

  Future<void> goMigrar(int key) async {
    int indexElement = preTareosUva.indexWhere((e) => e.key == key);
    if (indexElement != ELEMENT_NOT_FOUND) {
      if (preTareosUva[indexElement].estadoLocal == 'A') {
        basicDialog(
          context: Get.overlayContext,
          message: '¿Desea migrar esta actividad?',
          onPressed: () async {
            Get.back();
            await _migrar(indexElement);
          },
          onCancel: () => Get.back(),
        );
      } else {
        basicAlert(
          context: Get.overlayContext,
          message: 'Esta tarea aun no ha sido aprobada',
          onPressed: () => Get.back(),
        );
      }
    } else {
      toast(
          type: TypeToast.ERROR,
          message: ERROR_NOT_FOUNT_ELEMENT_TO_MIGRATE_STRING);
    }
  }

  Future<void> _migrar(int index) async {
    validando = BOOLEAN_TRUE_VALUE;
    update([VALIDANDO_ID]);
    PreTareoProcesoUvaEntity tareaMigrada =
        await _migrarAllPreTareoUvaUseCase.execute(preTareosUva[index].key);
    if (tareaMigrada != null) {
      toast(type: TypeToast.SUCCESS, message: 'Tarea migrada con exito');
      preTareosUva[index].estadoLocal = 'M';
      preTareosUva[index].itempretareaprocesouva =
          tareaMigrada.itempretareaprocesouva;
      await _updatePreTareoProcesoUvaUseCase.execute(
          preTareosUva[index], preTareosUva[index].key);
      tareaMigrada = await _uploadFileOfPreTareoUvaUseCase.execute(
          preTareosUva[index], File(preTareosUva[index].pathUrl));
      preTareosUva[index].firmaSupervisor = tareaMigrada?.firmaSupervisor;
      await _updatePreTareoProcesoUvaUseCase.execute(
          preTareosUva[index], preTareosUva[index].key);
    }
    validando = BOOLEAN_FALSE_VALUE;
    update(['$ELEMENT_OF_LIST_ID${preTareosUva[index].key}']);
  }

  /* Future<void> goMigrarPreTareo(int index) async {
    await _migrarAllPreTareoUseCase.execute(preTareos[index]);
  } */

  Future<void> goListadoPersonas(int key) async {
    List<PreTareoProcesoUvaEntity> otras = [];
    int indexElement = preTareosUva.indexWhere((e) => e.key == key);
    if (indexElement != ELEMENT_NOT_FOUND) {
      otras.addAll(preTareosUva);
      otras.removeAt(indexElement);
      ListadoPersonasPreTareoUvaBinding().dependencies();
      int resultado =
          await Get.to<int>(() => ListadoPersonasPreTareoUvaPage(), arguments: {
        'otras': otras,
        'tarea': preTareosUva[indexElement],
        'index': indexElement,
      });

      if (resultado != null) {
        preTareosUva[indexElement].sizeDetails = resultado;
        update(['$ELEMENT_OF_LIST_ID${preTareosUva[indexElement].key}']);
      }
    }
  }

  Future<void> _delete(int key) async {
    int indexElement = preTareosUva.indexWhere((e) => e.key == key);
    if (indexElement != ELEMENT_NOT_FOUND) {
      await _deletePreTareoProcesoUvaUseCase
          .execute(preTareosUva[indexElement].key);
      preTareosUva.removeAt(indexElement);
      update([ALL_LIST_ID]);
    } else {
      toast(
          type: TypeToast.ERROR,
          message: ERROR_NOT_FOUNT_ELEMENT_TO_DELETE_STRING);
    }
  }

  void seleccionar(int index) {
    int i = seleccionados.indexWhere((element) => element == index);
    if (i == -1) {
      seleccionados.add(index);
    } else {
      seleccionados.removeAt(i);
    }
    update([EVENT_CHOOSE_ELEMENT_ID]);
  }

  Future<void> goNuevaPreTarea() async {
    NuevaPreTareaUvaBinding().dependencies();
    final result =
        await Get.to<PreTareoProcesoUvaEntity>(() => NuevaPreTareaUvaPage());
    if (result != null) {
      int id = await _createPreTareoProcesoUvaUseCase.execute(result);
      result.key = id;
      preTareosUva.insert(FIRST_INDEX_ARRAY_VALUE, result);
      update([ALL_LIST_ID]);
    }
  }

  Future<void> _editarTarea(int key) async {
    int indexElement = preTareosUva.indexWhere((e) => e.key == key);
    if (indexElement != ELEMENT_NOT_FOUND) {
      NuevaPreTareaUvaBinding().dependencies();
      final result = await Get.to<PreTareoProcesoUvaEntity>(
          () => NuevaPreTareaUvaPage(),
          arguments: {'tarea': preTareosUva[indexElement]});
      if (result != null) {
        result.idusuario = PreferenciasUsuario().idUsuario;
        preTareosUva[indexElement] = result;
        await _updatePreTareoProcesoUvaUseCase.execute(
            preTareosUva[indexElement], key);
        //FIXME: buscar actualizar solo el elemento que se edito
        update([ALL_LIST_ID]);
      }
    } else {
      toast(
          type: TypeToast.ERROR,
          message: ERROR_NOT_FOUNT_ELEMENT_TO_EDIT_STRING);
    }
  }

  Future<void> _copiarTarea(int key) async {
    int indexElement = preTareosUva.indexWhere((e) => e.key == key);
    if (indexElement != ELEMENT_NOT_FOUND) {
      NuevaPreTareaUvaBinding().dependencies();
      final result = await Get.to<PreTareoProcesoUvaEntity>(
          () => NuevaPreTareaUvaPage(),
          arguments: {'tarea': preTareosUva[indexElement]});
      if (result != null) {
        result.idusuario = PreferenciasUsuario().idUsuario;
        int id = await _createPreTareoProcesoUvaUseCase.execute(result);
        result.key = id;
        preTareosUva.add(result);
        update([ALL_LIST_ID]);
      }
    } else {
      toast(
          type: TypeToast.ERROR,
          message: ERROR_NOT_FOUNT_ELEMENT_TO_COPY_STRING);
    }
  }

  void goEliminar(int key) {
    basicDialog(
      context: Get.overlayContext,
      message: '¿Esta seguro de eliminar esta tarea?',
      onPressed: () async {
        await _delete(key);
        Get.back();
      },
      onCancel: () => Get.back(),
    );
  }

  void goCopiar(int key) {
    basicDialog(
      context: Get.overlayContext,
      message: '¿Esta seguro de copiar la siguiente tarea?',
      onPressed: () async {
        Get.back();
        await _copiarTarea(key);
      },
      onCancel: () => Get.back(),
    );
  }

  void goEditar(int key) {
    basicDialog(
      context: Get.overlayContext,
      message: '¿Esta seguro de editar la actividad?',
      onPressed: () async {
        Get.back();
        await _editarTarea(key);
      },
      onCancel: () => Get.back(),
    );
  }
}
