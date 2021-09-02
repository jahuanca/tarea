
import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/colors.dart';
import 'package:flutter_tareo/ui/utils/preferencias_usuario.dart';
import 'package:flutter_tareo/ui/widgets/button_login_widget.dart';
import 'package:flutter_tareo/ui/widgets/button_social_widget.dart';
import 'package:flutter_tareo/ui/widgets/divider_widget.dart';
import 'package:flutter_tareo/ui/widgets/input_login_widget.dart';

class LoginPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    final Size size=MediaQuery.of(context).size;

    return SafeArea(
      child: Stack(
          children: [
            Scaffold(
              backgroundColor: (PreferenciasUsuario().modoDark) ? cardColorDark : cardColor,
                body: SingleChildScrollView(
                  child: Container(
                    width: size.width,
                    height: size.height- MediaQuery.of(context).padding.top,
                      child: Row(
                        children: [
                          Flexible(child: Container(), flex: 1),
                          Flexible(child: Container(
                            child: Column(
                              children: [
                                cabecera(),
                                ingreso(context),
                              ],
                            ),
                          ), flex: 8),
                          Flexible(child: Container(), flex: 1),
                        ],
                    ),
                  ),
                )
              
            ),
            /* GetBuilder<LoginController>(
              id: 'validando',
              builder: (_)=> _.validando ? Container(
                color: Colors.black45,
                child: Center(child: CircularProgressIndicator()),
              ) : Container(),
            ), */
          ],
      ),
    );
  }

  Widget cabecera(){
    return Flexible(
      child: Column(
        children: [
          Flexible(child: logoWithTexto(), flex: 3,),
          //Flexible(child: loginSociales(), flex: 3,),
          //Flexible(child: DividerWidget(), flex: 1,)
        ],
      ),
      flex: 2,
    );
  }

  Widget ingreso(BuildContext context){
    return Flexible(
      child: Column(
        children: [
          Flexible(child: formulario(context), flex: 4,),
          Flexible(child: registrate(), flex: 1,)
        ],
      ),
      flex: 4,
    );
  }

  Widget logoWithTexto(){
    return Container(
      child: Column(
        children: [
          Flexible(child: Container(
            padding: EdgeInsets.only(top: 20),
            child: ImageIcon(AssetImage('assets/images/ic_logo.png'), 
            color: (PreferenciasUsuario().modoDark) ? primaryColorDark : primaryColor, size: 120,),
          ), flex: 2),
          Flexible(child: Container(
            alignment: Alignment.center,
            child: Text('Inicie sesion para continuar'),
          ), flex: 1),
        ],
      ),
    );
  }

  /* Widget loginSociales(){
    return Container(
      child: Column(
        children: [
          Flexible(
            flex: 1,
            child: Center(child: ButtonSocialWidget(
              onTap: (){},
              texto: 'Conectate con google', icon: Icons.golf_course))),
          Flexible(
            flex: 1,
            child: Center(child: ButtonSocialWidget(texto: 'Conectate con outlook', icon: Icons.golf_course_outlined))),
        ],
      ),
    );
  } */

  Widget formulario(BuildContext context){
    return Container(
      child: Column(
        children: [
          Flexible(
            flex: 1,
            child: Center(
              child: InputLoginWidget(
                  texto: 'Usuario', 
                  maxLength: 80,
                  onChanged: null, 
                  error: null,
                  icon: Icons.mail),
              )),
          Flexible(
            flex: 1,
            child: Center(
              child: InputLoginWidget(
                  texto: 'Contraseña',
                  isObscure: true,
                  onChanged: null, 
                  error: null,
                  icon: Icons.lock),
            )),
          Flexible(
            flex: 1,
            child: Center(
              child: InputLoginWidget(
                  texto: 'Sede', 
                  maxLength: 80,
                  onChanged: null, 
                  error: null,
                  icon: Icons.mail),
              )),
          Flexible(
            flex: 1,
            child: Center(
              child: ButtonLogin(
                  onTap: ()=> Navigator.of(context).pushNamed('navigation'),
                  texto: 'Ingresar'),
              )
          ),
          Flexible(
            flex: 1,
            child: Center(
              child: ButtonSocialWidget(

                  onTap: (){},
                  texto: 'Sincronizar'),
              )
          )
        ],
      ),
    );
  }

  Widget registrate(){
    return Container(
      child: Column(
        children: [
          Flexible(child: Container(
            alignment: Alignment.center,
            child: Text('Version 1.0.0',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ), flex: 1),
          Flexible(child: GestureDetector(
              onTap: null,
              child: Container(
                child: Text('12/05/2021',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
          ), flex: 1),
        ],
      ),
    );
  }
}