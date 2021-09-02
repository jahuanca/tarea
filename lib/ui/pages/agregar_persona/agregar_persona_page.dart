import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/colors.dart';
import 'package:flutter_tareo/ui/widgets/app_bar_widget.dart';
import 'package:flutter_tareo/ui/widgets/button_login_widget.dart';
import 'package:flutter_tareo/ui/widgets/dropdown_label_widget.dart';
import 'package:flutter_tareo/ui/widgets/input_label_widget.dart';

class AgregarPersonaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: getAppBar('Agregar persona'),
      backgroundColor: secondColor,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: Column(
            children: [
              DropdownLabelWidget(
                  label: 'Personas',
                  labelText: 'name',
                  labelValue: '_id',
                  initialValue: '1',
                  onChanged: (value) {},
                  items: [
                    {
                      'name': 'Centro 1',
                      '_id': '1',
                    },
                    {
                      'name': 'Centro 2',
                      '_id': '2',
                    },
                  ]),
              InputLabelWidget(
                hintText: 'Hora inicio',
                label: 'Hora inicio',
              ),
              InputLabelWidget(
                hintText: 'Hora fin',
                label: 'Hora fin',
              ),
              InputLabelWidget(
                  label: 'Inicio de pausa', hintText: 'Inicio de pausa'),
              
              InputLabelWidget(label: 'Fin de pausa', hintText: 'Fin de pausa'),
              InputLabelWidget(
                hintText: 'Cantidad',
                label: 'Cantidad',
              ),
              //TODO: unidad de avance debe ser lista
              InputLabelWidget(
                hintText: 'Unidad de avance',
                label: 'Unidad de avance',
              ),
              InputLabelWidget(
                hintText: 'Avance',
                label: 'Avance',
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              ButtonLogin(texto: 'Guardar'),
              SizedBox(
                height: size.height * 0.05,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
