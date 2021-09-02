
import 'package:flutter/material.dart';
import 'package:flutter_tareo/di/main_binding.dart';
import 'package:flutter_tareo/ui/pages/login/login_page.dart';
import 'package:flutter_tareo/ui/utils/routes.dart';
import 'package:get/get.dart';
 
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'login',
      routes: getAplicattionRoutes(),
      initialBinding: MainBinding(),
      home: LoginPage(),
    );
  }
}