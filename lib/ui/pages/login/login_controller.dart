
import 'package:flutter_tareo/di/sincronizar_binding.dart';
import 'package:flutter_tareo/domain/entities/subdivision_entity.dart';
import 'package:flutter_tareo/domain/entities/usuario_entity.dart';
import 'package:flutter_tareo/domain/use_cases/login/save_token_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/login/save_user_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/login/sign_in_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/nueva_tarea/get_subdivisions_use_case.dart';
import 'package:flutter_tareo/ui/pages/sincronizar/sincronizar_page.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/validators_utils.dart';
import 'package:get/get.dart';
import 'package:package_info/package_info.dart';



class LoginController extends GetxController{

  String errorUsuario, errorPassword;
  String version='x.x.x';
  
  UsuarioEntity loginEntity= new UsuarioEntity();
  
  SignInUseCase _signInUseCase;
  SaveUserUseCase _saveUserUseCase;
  SaveTokenUseCase _saveTokenUseCase;
  GetSubdivisonsUseCase _getSubdivisonsUseCase;


  bool validando=false;
  List<SubdivisionEntity> sedes=[];
  SubdivisionEntity sedeSelected;


  LoginController(this._saveTokenUseCase, this._saveUserUseCase, this._signInUseCase, this._getSubdivisonsUseCase);

  @override
  void onInit()async{
    super.onInit();

    sedes=await _getSubdivisonsUseCase.execute();
    update(['sedes']);
  }

  @override
  void onReady()async{
    super.onReady();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    update(['version']);

  }

  String validar(){
    onValidationUsuario(loginEntity.alias ?? '');
    onValidationPassword(loginEntity.password ?? '');
    if(errorUsuario!=null) return errorUsuario;
    if(errorPassword!=null) return errorPassword;
    return null;
  }

  void onValidationUsuario(String value){
    errorUsuario=validatorUtilText(value, 'Usuario', 
      {
        'required' : '',
      }
    );
    if(errorUsuario==null){
      loginEntity.alias=value;
    }else{
      loginEntity.alias=null;
    }
    update(['usuario']);
  }

  void onValidationPassword(String value){
    errorPassword=validatorUtilText(value, 'Contraseña', 
      {
        'required' : '',
      }
    );
    if(errorPassword==null){
      loginEntity.password=value;
    }else{
      loginEntity.password=null;
    }
    update(['password']);
  }

  Future<void> ingresar()async{
    String mensaje=validar();
    if(mensaje!=null){
      toastError('Error', mensaje);
      return;
    }
    validando=true;
    update(['validando']);
    UsuarioEntity usuarioEntity= await _signInUseCase.execute(loginEntity);
    validando=false;
    update(['validando']);
    if(usuarioEntity!=null){
      await _saveTokenUseCase.execute(usuarioEntity.token);
      await _saveUserUseCase.execute(usuarioEntity);
      goHome();
    }
  }

  void goHome(){
    Get.offAndToNamed('navigation');
  }

  void goSincronizar(){
    SincronizarBinding().dependencies();
    Get.to( ()=> SincronizarPage());
  }
}