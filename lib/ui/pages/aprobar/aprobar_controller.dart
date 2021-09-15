
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:get/get.dart';
import 'package:image_editor_pro/image_editor_pro.dart';

class AprobarController extends GetxController{

  List<int> seleccionados=[];

  void seleccionar(int index){
    int i=seleccionados.indexWhere((element) => element==index);
    if(i==-1){
      seleccionados.add(index);
    }else{
      seleccionados.removeAt(i);
    }
    update(['seleccionado']);
  }

  Future<void> getimageditor() async{
    Navigator.push(Get.overlayContext, MaterialPageRoute(
        builder: (context){
          return ImageEditorPro(
            appBarColor: Color(0xFF009ee0),
            bottomBarColor: Colors.white,
          );
        }
    )).then((geteditimage)async{
      if(geteditimage != null){
        /* File _image =  geteditimage[0]; */
        
        //files.add(new PlatformFile(name: _image.path.split('/').last, bytes: _image.readAsBytesSync(), path: _image.path));
        
        //await Get.to(()=> AddDescripcionPage());

        update(['files']);
      }
    }).catchError((er){print(er);});
    
  }

  void goAprobar(){
    basicDialog(
      Get.overlayContext, 
      'Alerta', 
      '¿Desea aprobar esta tarea?', 
      'Si', 
      'No', 
      ()async{
        Get.back();
        await getimageditor();
        /* LocalStorageRepository().clearAllData(); */
        
      }, 
      ()=> Get.back(),
    );
  }
}