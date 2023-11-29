import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tareo/core/utils/numbers.dart';
import 'package:flutter_tareo/ui/home/utils/strings_contants.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/constants.dart';
import 'package:flutter_tareo/ui/utils/type_toast.dart';
import 'package:get/get.dart';
import 'package:honeywell_scanner/honeywell_scanner.dart';
import 'package:sunmi_barcode_plugin/sunmi_barcode_plugin.dart';

abstract class GetxScannerController extends GetxController
    implements ScannerCallBack {
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  SunmiBarcodePlugin _sunmiBarcodePlugin;
  HoneywellScanner _honeywellScanner;

  @override
  void onInit() async {
    await _initNotifications();
    await _initHoneyScanner();
    await _initScanner();
    super.onInit();
  }

  @override
  void onDecoded(String result) async {
    await setCodeBar(result, true);
  }

  @override
  void onError(Exception error) {
    toast(type: TypeToast.ERROR, message: error.toString());
  }

  Future<void> _initNotifications() async {
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android: android, iOS: iOS);
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await _flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: _onSelectNotification);
  }

  Future<dynamic> _onSelectNotification(String json) async {
    return;
  }

  void _initHoneyScanner() {
    _honeywellScanner = HoneywellScanner();
    _honeywellScanner.setScannerCallBack(this);
    _honeywellScanner.setProperties(getPropertiesHoneyWell);
    _honeywellScanner.startScanner();
  }

  Future<void> _initPlatformState() async {
    try {
      await _sunmiBarcodePlugin.getScannerModel();
    } on PlatformException {
      print('Failed to get model version.');
    }
  }

  Future<void> _initScanner() async {
    _sunmiBarcodePlugin = SunmiBarcodePlugin();
    if (await _sunmiBarcodePlugin.isScannerAvailable()) {
      _initPlatformState();
      _sunmiBarcodePlugin.onBarcodeScanned().listen((event) async {
        await setCodeBar(event, BOOLEAN_TRUE_VALUE);
      });
    } else {
      _initHoneyScanner();
    }
  }

  Future<void> setCodeBar(dynamic barcode,
      [bool byLector = BOOLEAN_FALSE_VALUE]) async {}

  void goLectorCode() {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            "#ff6666", CANCEL_STRING, BOOLEAN_FALSE_VALUE, ScanMode.DEFAULT)
        .listen((barcode) async {
      print(barcode);
      await setCodeBar(barcode);
    });
  }

  void showToast(bool isSuccess, String message) {
    toast(
        type: isSuccess ? TypeToast.SUCCESS : TypeToast.ERROR,
        message: message);
  }

  Future<void> showNotification(bool success, String mensaje) async {
    final android = AndroidNotificationDetails(
        'channel id', 'channel name', 'channel description',
        priority: Priority.high, importance: Importance.max);
    final iOS = IOSNotificationDetails();
    final platform = NotificationDetails(android: android, iOS: iOS);
    false;

    await _flutterLocalNotificationsPlugin.show(
      0,
      success ? 'Exito' : 'Error',
      mensaje,
      platform,
      payload: '',
    );
  }
}
