
import 'package:flutter_tareo/domain/entities/usuario_entity.dart';
import 'package:flutter_tareo/domain/use_cases/login/save_token_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/login/save_user_use_case.dart';
import 'package:flutter_tareo/domain/use_cases/login/sign_in_use_case.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';
import 'package:flutter_tareo/ui/utils/validators_utils.dart';
import 'package:get/get.dart';

class LoginController extends GetxController{


  String errorUsuario, errorPassword;
  UsuarioEntity loginEntity= new UsuarioEntity();
  
  SignInUseCase _signInUseCase;
  SaveUserUseCase _saveUserUseCase;
  SaveTokenUseCase _saveTokenUseCase;

  bool validando=false;


  LoginController(this._saveTokenUseCase, this._saveUserUseCase, this._signInUseCase);

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
    /* if(statusEntity.success ?? false){
      await _saveTokenUseCase.execute(statusEntity.data?.token ?? '');
      UsuarioEntity user =await _getProfileUseCase.execute(statusEntity.data?.account ?? '');

      user.token=statusEntity.data?.token;
      await _saveUserUseCase.execute(user);
      goHome();
    }else{
      /* toastError('Error', statusEntity.title ?? ''); */
    } */
  }

  void goHome(){
    Get.offAndToNamed('navigation');
  }
}