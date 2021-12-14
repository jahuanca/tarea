
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tareo/domain/entities/personal_tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_detalle_grupo_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_detalle_varios_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_grupo_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tarea_esparrago_varios_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_uva_detalle_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_uva_entity.dart';
import 'package:flutter_tareo/domain/entities/tarea_proceso_entity.dart';
import 'package:flutter_tareo/domain/repositories/export_data_repository.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/listas.dart';
import 'package:flutter_tareo/ui/utils/string_formats.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ExportDataRepositoryImplementation extends ExportDataRepository{

  TargetPlatform platform;

  Future<bool> _checkPermission() async {
    if (this.platform == TargetPlatform.android) {
      
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  @override
  Future<void> exportToExcel(dynamic data) async{
    var excel = Excel.createExcel();
    //excel.rename('Sheet1', 'Data');
    Sheet sheetObject = excel['Data'];
    int initialRow=5;
    sheetObject.insertRowIterables(listaEncabezados(data.toJson()), 1);
    sheetObject.insertRowIterables(listaItem(data.toJson()), 2);
    sheetObject.insertRowIterables(listaEncabezados(data.toJson()), 4);
    for (var i = 0; i < data.detalles.length ; i++) {
      var d=data.detalles[i];
      sheetObject.insertRowIterables(listaItem(d.toJson()), i+ initialRow);
    }

    var fileBytes = excel.save();

    if(await _checkPermission()==false){
      print('No hay permisos');
      return;
    }

    this.platform = Theme.of(Get.overlayContext).platform;

    final directory = this.platform == TargetPlatform.android
        ? '/storage/emulated/0/Android/data/com.example.flutter_tareo/files'
        : (await getApplicationDocumentsDirectory()).path +
            Platform.pathSeparator +
            'Download';
    String ruta='$directory/${getTitulo(data)}';
    File(ruta)
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes);

    toastExito('Exito', 'Archivo ubicado en $ruta');
    return;
  }

  String getTitulo(dynamic data){
    String titulo='';
    switch (data.runtimeType) {
      case PreTareoProcesoEntity:
        titulo+='Arandano_';
        
        break;
      case PreTareoProcesoUvaEntity:
        titulo+='Uva_';
        break;
      case TareaProcesoEntity:
        titulo+='Tarea_';
        break;
      case PreTareaEsparragoVariosEntity:
        titulo+='Varios_';
        break;
      default:
        titulo+='Sin titulo';
        break;
    }
    String fecha=formatoFechaHora(data.fecha).replaceAll(RegExp('/'), '_');
    titulo+=fecha+'.xlsx';
    return titulo;
  }

  @override
  Future<void> exportToExcelPacking(int key) async{
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Data'];
    int initialRow=5;

    Box<PreTareoProcesoUvaEntity> tareas=await Hive.openBox('pre_tareos_uva_sincronizar');
    PreTareoProcesoUvaEntity data=tareas.get(key);
    await tareas.close();

    List<String> encabezados=listaEncabezados(data.toJson());
    encabezados.removeLast();
    sheetObject.insertRowIterables(encabezados, 1);
    sheetObject.insertRowIterables(listaItem(data.toJson()), 2);

    Box<PreTareoProcesoUvaDetalleEntity> boxDetalles=await Hive.openBox('uva_detalle_$key');
    List<PreTareoProcesoUvaDetalleEntity> detalles=await boxDetalles.values.toList();
    await tareas.close();
    sheetObject.insertRowIterables(listaEncabezados(detalles.first.toJson()), 4);
    for (var i = 0; i < detalles.length ; i++) {
      var d=detalles[i];
      sheetObject.insertRowIterables(listaItem(d.toJson()), i+ initialRow);
    }

    var fileBytes = excel.save();

    if(await _checkPermission()==false){
      print('No hay permisos');
      return;
    }

    this.platform = Theme.of(Get.overlayContext).platform;

    final directory = this.platform == TargetPlatform.android
        ? '/storage/emulated/0/Android/data/com.example.flutter_tareo/files'
        : (await getApplicationDocumentsDirectory()).path +
            Platform.pathSeparator +
            'Download';
    String ruta='$directory/${getTitulo(data)}';
    File(ruta)
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes);

    toastExito('Exito', 'Archivo ubicado en $ruta');
    return;
  }

  @override
  Future<void> exportToExcelSeleccion(int key) async{
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Data'];
    int initialRow=5;

    Box<PreTareaEsparragoGrupoEntity> tareas=await Hive.openBox('seleccion_sincronizar');
    PreTareaEsparragoGrupoEntity data=tareas.get(key);
    await tareas.close();

    List<String> encabezados=listaEncabezados(data.toJson());
    encabezados.removeLast();
    sheetObject.insertRowIterables(encabezados, 1);
    sheetObject.insertRowIterables(listaItem(data.toJson()), 2);

    Box<PreTareaEsparragoDetalleGrupoEntity> boxDetalles=await Hive.openBox('seleccion_detalles_$key');
    List<PreTareaEsparragoDetalleGrupoEntity> detalles=await boxDetalles.values.toList();
    await tareas.close();
    sheetObject.insertRowIterables(listaEncabezados(detalles.first.toJson()), 4);
    for (var i = 0; i < detalles.length ; i++) {
      var d=detalles[i];
      sheetObject.insertRowIterables(listaItem(d.toJson()), i+ initialRow);
    }

    var fileBytes = excel.save();

    if(await _checkPermission()==false){
      print('No hay permisos');
      return;
    }

    this.platform = Theme.of(Get.overlayContext).platform;

    final directory = this.platform == TargetPlatform.android
        ? '/storage/emulated/0/Android/data/com.example.flutter_tareo/files'
        : (await getApplicationDocumentsDirectory()).path +
            Platform.pathSeparator +
            'Download';
    String ruta='$directory/${getTitulo(data)}';
    File(ruta)
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes);

    toastExito('Exito', 'Archivo ubicado en $ruta');
    return;
  }

  @override
  Future<void> exportToExcelPesado(int key) async{
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Data'];
    int initialRow=5;

    Box<PreTareaEsparragoVariosEntity> tareas=await Hive.openBox('pesados_sincronizar');
    PreTareaEsparragoVariosEntity data=tareas.get(key);
    await tareas.close();

    List<String> encabezados=listaEncabezados(data.toJson());
    encabezados.removeLast();
    sheetObject.insertRowIterables(encabezados, 1);
    sheetObject.insertRowIterables(listaItem(data.toJson()), 2);

    Box<PreTareaEsparragoDetalleVariosEntity> boxDetalles=await Hive.openBox('pesado_detalles_$key');
    List<PreTareaEsparragoDetalleVariosEntity> detalles=await boxDetalles.values.toList();
    await tareas.close();
    sheetObject.insertRowIterables(listaEncabezados(detalles.first.toJson()), 4);
    for (var i = 0; i < detalles.length ; i++) {
      var d=detalles[i];
      sheetObject.insertRowIterables(listaItem(d.toJson()), i+ initialRow);
    }

    var fileBytes = excel.save();

    if(await _checkPermission()==false){
      print('No hay permisos');
      return;
    }

    this.platform = Theme.of(Get.overlayContext).platform;

    final directory = this.platform == TargetPlatform.android
        ? '/storage/emulated/0/Android/data/com.example.flutter_tareo/files'
        : (await getApplicationDocumentsDirectory()).path +
            Platform.pathSeparator +
            'Download';
    String ruta='$directory/${getTitulo(data)}';
    File(ruta)
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes);

    toastExito('Exito', 'Archivo ubicado en $ruta');
    return;
  }


  @override
  Future<void> exportToExcelTarea(int key) async{
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Data'];
    int initialRow=5;

    Box<TareaProcesoEntity> tareas=await Hive.openBox('tarea_proceso');
    TareaProcesoEntity data=tareas.get(key);
    await tareas.close();

    List<String> encabezados=listaEncabezados(data.toJson());
    encabezados.removeLast();
    sheetObject.insertRowIterables(encabezados, 1);
    sheetObject.insertRowIterables(listaItem(data.toJson()), 2);

    Box<PersonalTareaProcesoEntity> boxDetalles=await Hive.openBox('personal_tarea_proceso_$key');
    List<PersonalTareaProcesoEntity> detalles=await boxDetalles.values.toList();
    await tareas.close();
    sheetObject.insertRowIterables(listaEncabezados(detalles.first.toJson()), 4);
    for (var i = 0; i < detalles.length ; i++) {
      var d=detalles[i];
      sheetObject.insertRowIterables(listaItem(d.toJson()), i+ initialRow);
    }

    var fileBytes = excel.save();

    if(await _checkPermission()==false){
      print('No hay permisos');
      return;
    }

    this.platform = Theme.of(Get.overlayContext).platform;

    final directory = this.platform == TargetPlatform.android
        ? '/storage/emulated/0/Android/data/com.example.flutter_tareo/files'
        : (await getApplicationDocumentsDirectory()).path +
            Platform.pathSeparator +
            'Download';
    String ruta='$directory/${getTitulo(data)}';
    File(ruta)
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes);

    toastExito('Exito', 'Archivo ubicado en $ruta');
    return;
  }

}