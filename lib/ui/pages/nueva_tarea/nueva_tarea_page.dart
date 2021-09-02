import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/colors.dart';
import 'package:flutter_tareo/core/dimens.dart';
import 'package:flutter_tareo/ui/widgets/app_bar_widget.dart';
import 'package:flutter_tareo/ui/widgets/dropdown_label_widget.dart';
import 'package:flutter_tareo/ui/widgets/input_label_widget.dart';
import 'package:flutter_tareo/ui/widgets/separador_widget.dart';

class NuevaTareaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: getAppBar('Nueva tarea', true),
      backgroundColor: secondColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.check),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: Column(
            children: [
              InputLabelWidget(label: 'Fecha', hintText: 'Fecha'),
              SizedBox(
                height: size.height * 0.01,
              ),
              DropdownLabelWidget(
                  label: 'Sede',
                  labelText: 'name',
                  labelValue: '_id',
                  initialValue: '1',
                  onChanged: (value) {},
                  items: [
                    {
                      'name': 'Sede 1',
                      '_id': '1',
                    },
                    {
                      'name': 'Sede 2',
                      '_id': '2',
                    },
                  ]),
              DropdownLabelWidget(
                  label: 'Centro de costo',
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
              DropdownLabelWidget(
                  label: 'Actividad',
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
              DropdownLabelWidget(
                  label: 'Labor',
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
              DropdownLabelWidget(
                  label: 'Supervisor',
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
              SizedBox(
                height: size.height * 0.05,
              ),
              SeparadorWidget(size: size, titulo: 'Personas'),
              SizedBox(
                height: size.height * 0.05,
              ),
              _agregarMultimedia(size, context),
              SizedBox(
                height: size.height * 0.05,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _agregarMultimedia(Size size, BuildContext context) {
    return GestureDetector(
      onTap: ()=> Navigator.of(context).pushNamed('agregar_persona'),
      child: Container(
        height: size.height * 0.1,
        decoration: BoxDecoration(
            border: Border.all(
              color: primaryColor,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            color: primaryColor.withAlpha(50)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(child: Container(), flex: 1),
            Flexible(
                child: Container(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.person_add,
                    size: 25,
                  ),
                ),
                flex: 2),
            Flexible(child: Container(), flex: 1),
            Flexible(
                child: Container(
                  alignment: Alignment.center,
                  child: Text('AÑADIR PERSONAS'),
                ),
                flex: 2),
            Flexible(child: Container(), flex: 1),
          ],
        ),
      ),
    );
  }
}
