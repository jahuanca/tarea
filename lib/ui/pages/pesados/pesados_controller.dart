import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tareo/di/listado_personas_pesado_binding.dart';
import 'package:flutter_tareo/di/listado_personas_pre_tarea_esparrago_binding.dart';
import 'package:flutter_tareo/di/nueva_pesado_binding.dart';
import 'package:flutter_tareo/di/nueva_pre_tarea_binding.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_varios_entity.dart';
import 'package:flutter_tareo/domain/use_cases/others/export_pesado_to_excel_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/others/send_resumen_varios_esparrago_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pesados/create_pesado_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pesados/delete_pesado_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pesados/get_all_pesado_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pesados/migrar_all_pesado_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pesados/update_pesado_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pesados/upload_file_of_tarea_use_case.dart';
import 'package:flutter_tareo/ui/pages/informacion_linea/informacion_linea_page.dart';
import 'package:flutter_tareo/ui/pages/listado_personas_pesado/listado_personas_pesado_page.dart';
import 'package:flutter_tareo/ui/pages/listado_personas_pre_tarea_esparrago/listado_personas_pre_tarea_esparrago_page.dart';
import 'package:flutter_tareo/ui/pages/nueva_pesado/nueva_pesado_page.dart';
import 'package:flutter_tareo/ui/pages/nueva_tarea/nueva_tarea_page.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:get/get.dart';
import 'package:image_editor_pro/image_editor_pro.dart';

class PesadosController extends GetxController {
  final CreatePesadoUseCase _createPesadoUseCase;
  final GetAllPesadoUseCase _getAllPesadoUseCase;
  final UpdatePesadoUseCase _updatePesadoUseCase;
  final DeletePesadoUseCase _deletePesadoUseCase;
  final MigrarAllPesadoUseCase _migrarAllPesadoUseCase;
  final UploadFileOfPesadoUseCase _uploadFileOfPesadoUseCase;
  final ExportPesadoToExcelUseCase _exportDataToExcelUseCase;
  final SendResumenVariosEsparragoUseCase _sendResumenVariosEsparragoUseCase;

  bool validando = false;
  Timer timer;

  PesadosController(
      this._createPesadoUseCase,
      this._getAllPesadoUseCase,
      this._updatePesadoUseCase,
      this._deletePesadoUseCase,
      this._migrarAllPesadoUseCase,
      this._uploadFileOfPesadoUseCase,
      this._sendResumenVariosEsparragoUseCase,
      this._exportDataToExcelUseCase);

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
    validando=true;
    update(['validando']);
    await sendResumenVarios();
    timer= new Timer.periodic(Duration(minutes: 5), (Timer t) => sendResumenVarios());
    await getTareas();
    validando=false;
    update(['validando']);
  }

  @override
  void onClose(){
    timer.cancel();
    super.onClose();
    
  }

  Future<void> sendResumenVarios()async{
    await _sendResumenVariosEsparragoUseCase.execute();
  }

  Future<void> getTareas() async {
    pesados = [];
    pesados = await _getAllPesadoUseCase.execute();
    update(['tareas']);
    return;
  }

  void onChangedMenu(dynamic value, int key) async {
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
        goExcel(key);
        break;
      default:
        break;
    }
  }

  void goExcel(int key) async {
    await _exportDataToExcelUseCase.execute(key);
  }

  void goAprobar(int key) async {
    int index = pesados.indexWhere((element) => element.key == key);
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
        '¿Desea aprobar esta actividad?',
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

  Future<void> goDatosEnLinea() async{
    bool resultado= await basicDialog(
        Get.overlayContext,
        'Alerta',
        '¿Desea ver los datos en linea?',
        'Si',
        'No',
        () async => Get.back(result: true),
        () async => Get.back(result: false),
      );

    if(resultado){
      Get.to(()=> InformacionLinea());
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
        Get.overlayContext,
        'Alerta',
        '¿Desea migrar esta actividad?',
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
    PreTareaEsparragoVariosEntity tareaMigrada =
        await _migrarAllPesadoUseCase.execute(pesados[index].key);
    if (tareaMigrada != null) {
      toastExito('Exito', 'Tarea migrada con exito');
      pesados[index].estadoLocal = 'M';
      pesados[index].itempretareaesparragosvarios =
          tareaMigrada.itempretareaesparragosvarios;
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

    if (resultado != null && resultado.length==3) {
      pesados[index].sizeDetails = resultado[0];
      /* pesados[index].sizeTipoCaja = resultado[1];
      pesados[index].sizeTipoPersona = resultado[2]; */
      /* await _updatePesadoUseCase.execute(pesados[index], pesados[index].key); */
      update(['tareas']);
    }
  }


  Future<void> goListadoPersonasPreTareaEsparrago(int index) async {
    List<PreTareaEsparragoVariosEntity> otras = [];
    otras.addAll(pesados);
    otras.removeAt(index);
    ListadoPersonasPreTareaEsparragoBinding().dependencies();
    final resultado =
        await Get.to<int>(() => ListadoPersonasPreTareaEsparragoPage(), arguments: {
      'otras': otras,
      'tarea': pesados[index],
      'index': index,
    });

    if (resultado != null) {
      pesados[index].sizeDetails = resultado;
      /* pesados[index].sizeTipoCaja = resultado[1];
      pesados[index].sizeTipoPersona = resultado[2]; */
      /* await _updatePesadoUseCase.execute(pesados[index], pesados[index].key); */
      update(['tareas']);
    }
  }



  Future<void> delete(int index) async {
    await _deletePesadoUseCase.execute(pesados[index].key);
    pesados.removeAt(index);
    update(['tareas']);
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
      await _createPesadoUseCase.execute(result);
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
      validando=true;
      update(['validando']);
      result.idusuario = PreferenciasUsuario().idUsuario;
      pesados.add(result);
      await _createPesadoUseCase.execute(pesados.last);
      validando=false;
      update(['tareas','validando']);
    }
  }

  void goEliminar(int key) {
    int index = pesados.indexWhere((element) => element.key == key);
    basicDialog(
      Get.overlayContext,
      'Alerta',
      '¿Esta seguro de eliminar este pesado?',
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

  void goCopiar(int key) {
    int index = pesados.indexWhere((element) => element.key == key);
    basicDialog(
      Get.overlayContext,
      'Alerta',
      '¿Esta seguro de copiar la siguiente tarea?',
      'Si',
      'No',
      () async {
        Get.back();
        await copiarPesado(index);
      },
      () => Get.back(),
    );
  }

  void goEditar(int index) {
    basicDialog(
      Get.overlayContext,
      'Alerta',
      '¿Esta seguro de editar la actividad?',
      'Si',
      'No',
      () async {
        Get.back();
        await editarPesado(index);
      },
      () => Get.back(),
    );
  }
}
