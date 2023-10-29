import 'dart:convert';
import 'dart:io';

import 'package:flutter_tareo/core/utils/detalles.dart';
import 'package:flutter_tareo/core/utils/strings.dart';
import 'package:flutter_tareo/core/utils/tarea.dart';
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_uva_detalle_entity.dart';
import 'package:flutter_tareo/domain/entities/pre_tareo_proceso_uva_entity.dart';
import 'package:flutter_tareo/domain/use_cases/listado_personas_pre_tareo_uva/create_uva_all_detalle_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/pre_tareos_uva/create_pre_tareo_proceso_uva_use_case.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:sqflite/sqflite.dart';

class HerramientasController extends GetxController {
  bool validando = false;
  String texto = '';

  final CreatePreTareoProcesoUvaUseCase _createPreTareoProcesoUvaUseCase;
  final CreateUvaAllDetalleUseCase _createUvaAllDetalleUseCase;

  HerramientasController(
      this._createPreTareoProcesoUvaUseCase, this._createUvaAllDetalleUseCase);

  int cantidad = 0;

  Future<void> cantidadSQLITE() async {
    Database database = await openDatabase(
        join(await getDatabasesPath(), 'tareo_esparrago.db'));

    final List<Map<String, dynamic>> maps =
        await database.query(TABLE_NAME_PERSONAL_PRE_TAREA_ESPARRAGO);
    await database.close();
    cantidad = maps.length ?? 0;
    update(['cantidad']);
  }

  Future<void> sqlite() async {
    validando = true;
    update(['validando']);

    validando = false;
    update(['validando']);
  }

  Future<void> importarData() async {
    validando = true;
    texto = 'Creando tarea';
    update(['validando']);
    PreTareoProcesoUvaEntity data =
        new PreTareoProcesoUvaEntity.fromJson(TAREAJSON);
    data.estadoLocal = 'PC';
    texto = 'Creando detalles';
    update(['validando']);
    await _createPreTareoProcesoUvaUseCase.execute(data);
    /* for (var i = 0; i < DETALLESJSON.length; i++) {
      texto = 'Creando detalles $i de ${DETALLESJSON.length}';
      update(['validando']);
      var d=DETALLESJSON[i]; */
    await _createUvaAllDetalleUseCase.execute('uva_detalle_${data.key}',
        preTareoProcesoUvaDetalleEntityFromJson(jsonEncode(DETALLESJSON)));
    /* } */
    validando = false;
    update(['validando']);
  }

  Future<void> createBackupFile() async {
    validando = true;
    texto = 'Pidiendo permiso';
    update(['validando']);
    await Future.delayed(Duration(seconds: 1));

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    // the downloads folder path
    /* Directory tempDir = await DownloadsPathProvider.downloadsDirectory; */

    /* String tempPath = tempDir.path; */
    texto = 'Creando archivo';
    update(['validando']);
    await Future.delayed(Duration(seconds: 1));
    String tempPath = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
    ;
    var filePath = tempPath + '/backup_barcode.json';

    File backupFile = File('${filePath}');

    update(['validando']);
    try {
      texto = 'Leyendo base de datos';
      update(['validando']);
      Box<PreTareoProcesoUvaEntity> dataHive =
          await Hive.openBox<PreTareoProcesoUvaEntity>(
        'pre_tareos_uva_sincronizar',
      );
      texto = 'Obteniendo no migrados';
      update(['validando']);
      List<PreTareoProcesoUvaEntity> lista =
          dataHive.values.where((e) => e?.estadoLocal != 'M').toList();
      for (var i = 0; i < lista.length; i++) {
        texto = 'Escribiendo ${(i + 1)} de ${lista.length}';
        update(['validando']);
        await backupFile.writeAsString(jsonEncode(lista[i]),
            mode: FileMode.append);
      }
      validando = false;
      toastExito('Exito', 'Exportado en ${filePath}');
      update(['validando']);
      return;
    } catch (e) {
      validando = false;
      print(e.toString());
      toastError('Error', e.toString());
      update(['validando']);
    }
  }
}
