
import 'package:flutter/material.dart';
import 'package:flutter_tareo/di/main_binding.dart';
import 'package:flutter_tareo/ui/pages/login/login_page.dart';
import 'package:flutter_tareo/ui/utils/routes.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
 
 
class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''),
        Locale('es', ''),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'login',
      routes: getAplicattionRoutes(),
      initialBinding: MainBinding(),
      home: LoginPage(),
    );
  }
}