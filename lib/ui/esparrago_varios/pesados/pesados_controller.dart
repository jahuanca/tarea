import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/utils/numbers.dart';
import 'package:flutter_tareo/di/control_lanzada/control_lanzada_binding.dart';
import 'package:flutter_tareo/di/listado_personas_pesado_binding.dart';
import 'package:flutter_tareo/di/personal_esparrago_pesado_binding.dart';
import 'package:flutter_tareo/di/nueva_pesado_binding.dart';
import 'package:flutter_tareo/di/nueva_pre_tarea_binding.dart';
import 'package:flutter_tareo/domain/entities/message_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_varios_entity.dart';
import 'package:flutter_tareo/domain/use_cases/others/export_esparrago_to_excel_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/others/send_resumen_varios_esparrago_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pesados/create_pesado_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pesados/delete_pesado_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pesados/get_all_pesado_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pesados/migrar_all_pesado_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pesados/update_pesado_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pesados/upload_file_of_tarea_use_case.dart';
import 'package:flutter_tareo/domain/utils/failure.dart';
import 'package:flutter_tareo/domain/utils/result_type.dart';
import 'package:flutter_tareo/ui/control_asistencia/utils/ids.dart';
import 'package:flutter_tareo/ui/esparrago_varios/control_lanzada/control_lanzada_page.dart';
import 'package:flutter_tareo/ui/pages/informacion_linea/informacion_linea_page.dart';
import 'package:flutter_tareo/ui/pages/listado_personas_pesado/listado_personas_pesado_page.dart';
import 'package:flutter_tareo/ui/pages/nueva_pesado/nueva_pesado_page.dart';
import 'package:flutter_tareo/ui/pages/nueva_tarea/nueva_tarea_page.dart';
import 'package:flutter_tareo/ui/pages/personal_esparrago_pesado/personal_esparrago_pesado_page.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:flutter_tareo/ui/utils/type_toast.dart';
import 'package:get/get.dart';
import 'package:image_editor_pro/image_editor_pro.dart';

class PesadosController extends GetxController {
  final CreatePesadoUseCase _createPesadoUseCase;
  final GetAllPesadoUseCase _getAllPesadoUseCase;
  final UpdatePesadoUseCase _updatePesadoUseCase;
  final DeletePesadoUseCase _deletePesadoUseCase;
  final MigrarAllPesadoUseCase _migrarAllPesadoUseCase;
  final UploadFileOfPesadoUseCase _uploadFileOfPesadoUseCase;
  final ExportEsparragoToExcelUseCase _exportEsparragoToExcelUseCase;
  final SendResumenVariosEsparragoUseCase _sendResumenVariosEsparragoUseCase;

  bool validando = BOOLEAN_FALSE_VALUE;
  Timer timer;

  PesadosController(
      this._createPesadoUseCase,
      this._getAllPesadoUseCase,
      this._updatePesadoUseCase,
      this._deletePesadoUseCase,
      this._migrarAllPesadoUseCase,
      this._uploadFileOfPesadoUseCase,
      this._sendResumenVariosEsparragoUseCase,
      this._exportEsparragoToExcelUseCase);

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
    validando = true;
    update(['validando']);
    await sendResumenVarios();
    try {
      timer = new Timer.periodic(
          Duration(minutes: 3), (Timer t) => sendResumenVarios());
    } catch (e) {
      toast(type: TypeToast.ERROR, title: 'UI: timer', message: e.toString());
    }
    await getTareas();
    validando = false;
    update(['validando']);
  }

  @override
  void onClose() {
    timer.cancel();
    super.onClose();
  }

  Future<void> sendResumenVarios() async {
    try {
      await _sendResumenVariosEsparragoUseCase.execute();
    } catch (e) {
      toast(
          type: TypeToast.ERROR,
          title: 'UI: sendresumenvarios',
          message: e.toString());
    }
  }

  Future<void> getTareas() async {
    validando = BOOLEAN_TRUE_VALUE;
    update([VALIDANDO_ID]);
    pesados = [];
    try {
      pesados = (switchResult(await _getAllPesadoUseCase.execute()) ?? []);
    } catch (e) {
      toast(
          type: TypeToast.ERROR, title: 'UI: getTareas', message: e.toString());
    }
    update(['tareas']);
    validando = BOOLEAN_FALSE_VALUE;
    update([VALIDANDO_ID]);
    return;
  }

  Future<void> onChangedMenu(dynamic value, int key, int idDB) async {
    switch (value.toInt()) {
      case 1:
        break;
      case 2:
        //goCopiar(key);
        break;
      case 3:
        goEliminar(key);
        break;
      case 4:
        await goExcel(idDB);
        break;
      default:
        break;
    }
  }

  Future<void> goExcel(int idDB) async {
    validando = true;
    update(['validando']);
    await _exportEsparragoToExcelUseCase.execute(idDB);
    validando = false;
    update(['validando']);
  }

  void goAprobar(int key) async {
    int index = pesados.indexWhere((element) => element.key == key);
    String mensaje = await validarParaAprobar(index);
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
          await getimageditor(index);
        },
        onCancel: () => Get.back(),
      );
    }
  }

  Future<void> goDatosEnLinea() async {
    bool resultado = await basicDialog(
      context: Get.overlayContext,
      message: '¿Desea ver los datos en linea?',
      onPressed: () async => Get.back(result: BOOLEAN_TRUE_VALUE),
      onCancel: () async => Get.back(result: BOOLEAN_FALSE_VALUE),
    );

    if (resultado) {
      Get.to(() => InformacionLinea());
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

        pesados[index].pathUrl = _image.path;
        pesados[index].estadoLocal = 'A';
        await _updatePesadoUseCase.execute(pesados[index], pesados[index].key);

        update(['seleccionado']);
      }
    }).catchError((er) {
      print(er);
    });
  }

  Future<String> validarParaAprobar(int index) async {
    PreTareaEsparragoVariosEntity tarea = pesados[index];
    if (tarea.sizeDetails == null || tarea.sizeDetails == 0) {
      return 'No se puede aprobar una actividad que no tiene personal';
    }
    return null;
  }

  Future<void> goMigrar(int key) async {
    int index = pesados.indexWhere((element) => element.key == key);
    if (pesados[index].estadoLocal == 'A') {
      basicDialog(
        context: Get.overlayContext,
        message: '¿Desea migrar esta actividad?',
        onPressed: () async {
          Get.back();
          await migrar(index);
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
  }

  Future<void> migrar(int index) async {
    validando = true;
    update(['validando']);
    PreTareaEsparragoVariosEntity tareaMigrada =
        await _migrarAllPesadoUseCase.execute(pesados[index].key);
    if (tareaMigrada != null) {
      toast(type: TypeToast.SUCCESS, message: 'Tarea migrada con exito');
      pesados[index].estadoLocal = 'M';
      pesados[index].itempretareaesparragovarios =
          tareaMigrada.itempretareaesparragovarios;
      await _updatePesadoUseCase.execute(pesados[index], pesados[index].key);
      tareaMigrada = await _uploadFileOfPesadoUseCase.execute(
          pesados[index], File(pesados[index].pathUrl));
      pesados[index].firmaSupervisor = tareaMigrada?.firmaSupervisor;
      await _updatePesadoUseCase.execute(pesados[index], pesados[index].key);
    }
    validando = false;
    update(['validando', 'tareas']);
  }

  Future<void> goListadoPersonas(int index) async {
    List<PreTareaEsparragoVariosEntity> otras = [];
    otras.addAll(pesados);
    otras.removeAt(index);
    ListadoPersonasPesadoBinding().dependencies();
    final resultado =
        await Get.to<List<int>>(() => ListadoPersonasPesadoPage(), arguments: {
      'otras': otras,
      'tarea': pesados[index],
      'index': index,
    });

    if (resultado != null && resultado.length == 3) {
      pesados[index].sizeDetails = resultado[0];
      /* pesados[index].sizeTipoCaja = resultado[1];
      pesados[index].sizeTipoPersona = resultado[2]; */
      /* await _updatePesadoUseCase.execute(pesados[index], pesados[index].key); */
      update(['tareas']);
    }
  }

  Future<void> goControlLanzada(int index) async {
    List<PreTareaEsparragoVariosEntity> otras = [];
    otras.addAll(pesados);
    otras.removeAt(index);
    ControlLanzadaBinding().dependencies();
    final resultado = await Get.to<int>(() => ControlLanzadaPage(), arguments: {
      'otras': otras,
      'tarea': pesados[index],
      'index': index,
    });
    if (resultado != null) {
      pesados[index].sizeDetails = resultado;
      update(['tareas']);
    }
  }

  Future<void> goListadoPersonasPreTareaEsparrago(int index) async {
    List<PreTareaEsparragoVariosEntity> otras = [];
    otras.addAll(pesados);
    otras.removeAt(index);
    PersonalEsparragoPesadoBinding().dependencies();
    final resultado =
        await Get.to<int>(() => PersonalEsparragoPesadoPage(), arguments: {
      'otras': otras,
      'tarea': pesados[index],
      'index': index,
    });

    if (resultado != null) {
      pesados[index].sizeDetails = resultado;
      update(['tareas']);
    }
  }

  Future<void> delete(int index) async {
    validando = BOOLEAN_TRUE_VALUE;
    update([VALIDANDO_ID]);
    final result =
        switchResult(await _deletePesadoUseCase.execute(pesados[index]));
    validando = BOOLEAN_FALSE_VALUE;
    update([VALIDANDO_ID]);
    if (result != null) {
      pesados.removeAt(index);
      update(['tareas']);
    }
  }

  List<int> seleccionados = [];
  List<PreTareaEsparragoVariosEntity> pesados = [];

  void seleccionar(int index) {
    int i = seleccionados.indexWhere((element) => element == index);
    if (i == -1) {
      seleccionados.add(index);
    } else {
      seleccionados.removeAt(i);
    }
    update(['seleccionado']);
  }

  Future<void> goNuevaPesado() async {
    NuevaPesadoBinding().dependencies();
    final result =
        await Get.to<PreTareaEsparragoVariosEntity>(() => NuevaPesadoPage());
    if (result != null) {
      pesados.insert(0, result);
      update(['tareas']);
    }
  }

  Future<void> editarPesado(int key) async {
    NuevaPesadoBinding().dependencies();
    int index = pesados.indexWhere((element) => element.key == key);
    final result = await Get.to<PreTareaEsparragoVariosEntity>(
        () => NuevaPesadoPage(),
        arguments: {'tarea': pesados[index]});
    if (result != null) {
      result.idusuario = PreferenciasUsuario().idUsuario;
      pesados[index] = result;
      await _updatePesadoUseCase.execute(pesados[index], pesados[index].key);
      update(['tareas']);
    }
  }

  Future<void> copiarPesado(int index) async {
    NuevaPreTareaBinding().dependencies();
    final result = await Get.to<PreTareaEsparragoVariosEntity>(
        () => NuevaTareaPage(),
        arguments: {'tarea': pesados[index]});
    if (result != null) {
      validando = true;
      update(['validando']);
      result.idusuario = PreferenciasUsuario().idUsuario;
      pesados.add(result);
      await _createPesadoUseCase.execute(pesados.last);
      validando = false;
      update(['tareas', 'validando']);
    }
  }

  Future<void> goEliminar(int key) async {
    int index = pesados.indexWhere((element) => element.key == key);
    await basicDialog(
      context: Get.overlayContext,
      message: '¿Esta seguro de eliminar este pesado?',
      onPressed: () async {
        await delete(index);
        update(['tareas']);
        Get.back();
      },
      onCancel: () => Get.back(),
    );
  }

  void goCopiar(int key) {
    int index = pesados.indexWhere((element) => element.key == key);
    basicDialog(
      context: Get.overlayContext,
      message: '¿Esta seguro de copiar la siguiente tarea?',
      onPressed: () async {
        Get.back();
        await copiarPesado(index);
      },
      onCancel: () => Get.back(),
    );
  }

  Future<void> goEditar(int key) async {
    await basicDialog(
      context: Get.overlayContext,
      message: '¿Esta seguro de editar la actividad?',
      onPressed: () async {
        Get.back();
        await editarPesado(key);
      },
      onCancel: () => Get.back(),
    );
  }

  Future<void> goLanzada(int id) async {
    int index = pesados.indexWhere((e) => e.itempretareaesparragovarios == id);
    ControlLanzadaBinding().dependencies();
    Get.to(() => ControlLanzadaPage(),
        arguments: {'item': pesados[index].itempretareaesparragovarios});
  }

  dynamic switchResult(ResultType<dynamic, Failure> result) {
    if (result is Success) {
      return result.data;
    }
    if (result is Error) {
      toast(
          type: TypeToast.ERROR,
          message: (result.error as MessageEntity).message);
    }
  }
}