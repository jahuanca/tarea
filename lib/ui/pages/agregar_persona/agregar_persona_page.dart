import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/colors.dart';
import 'package:flutter_tareo/ui/pages/agregar_persona/agregar_persona_controller.dart';
import 'package:flutter_tareo/ui/widgets/app_bar_widget.dart';
import 'package:flutter_tareo/ui/widgets/button_login_widget.dart';
import 'package:flutter_tareo/ui/widgets/date_picker_widget.dart';
import 'package:flutter_tareo/ui/widgets/dropdown_search_widget.dart';
import 'package:flutter_tareo/ui/widgets/input_label_widget.dart';
import 'package:get/get.dart';

class AgregarPersonaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GetBuilder<AgregarPersonaController>(
      init: AgregarPersonaController(),
      builder: (_) => Scaffold(
        appBar: getAppBar('Agregar persona', [
          
        ], true),
        backgroundColor: secondColor,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            child: Column(
              children: [
                if(_.cantidadEnviada==0)
                DropdownSearchWidget(
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
                if(_.cantidadEnviada!=0)
                Container(
                  padding: EdgeInsets.only(top: 30, bottom: 30),
                  child: InputLabelWidget(
                    enabled: false,
                    hintText: '4 personas',
                  ),
                ),
                InputLabelWidget(
                  enabled: false,
                  onTap: () async {
                    await DatePickerWidget(
                      onlyDate: true,
                      minDate: DateTime.now().subtract(Duration(days: 10)),
                      dateSelected: DateTime.now(),
                      onChanged: () {},
                    ).selectTime(context, new DateTime.now());
                  },
                  hintText: 'Hora inicio',
                  label: 'Hora inicio',
                ),
                InputLabelWidget(
                  enabled: false,
                    onTap: ()async{
                            await DatePickerWidget(
                          onlyDate: true,
                          minDate: DateTime.now().subtract(Duration(days: 10)),
                          dateSelected: DateTime.now(),
                          onChanged: () {},
                        ).selectTime(context, new DateTime.now());
                      },
                  hintText: 'Hora fin',
                  label: 'Hora fin',
                ),
                InputLabelWidget(
                  enabled: false,
                    onTap: ()async{
                            await DatePickerWidget(
                          onlyDate: true,
                          minDate: DateTime.now().subtract(Duration(days: 10)),
                          dateSelected: DateTime.now(),
                          onChanged: () {},
                        ).selectTime(context, new DateTime.now());
                      },
                    label: 'Inicio de pausa', hintText: 'Inicio de pausa'),

                InputLabelWidget(
                  enabled: false,
                    onTap: ()async{
                            await DatePickerWidget(
                          onlyDate: true,
                          minDate: DateTime.now().subtract(Duration(days: 10)),
                          dateSelected: DateTime.now(),
                          onChanged: () {},
                        ).selectTime(context, new DateTime.now());
                      },
                  label: 'Fin de pausa', hintText: 'Fin de pausa'),
                InputLabelWidget(
                  hintText: 'Cantidad',
                  textInputType: TextInputType.number,
                  label: 'Cantidad',
                ),              
                DropdownSearchWidget(
                    label: 'Unidad de avance',
                    labelText: 'name',
                    labelValue: '_id',
                    initialValue: '1',
                    onChanged: (value) {},
                    items: [
                      {
                        'name': 'Unidad 1',
                        '_id': '1',
                      },
                      {
                        'name': 'Unidad 2',
                        '_id': '2',
                      },
                    ]),
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
      ),
    );
  }
}
