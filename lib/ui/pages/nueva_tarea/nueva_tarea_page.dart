import 'package:dropdown_below/dropdown_below.dart';
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
              InputLabelWidget(
                  label: 'Inicio de pausa', hintText: 'Inicio de pausa'),
              SizedBox(
                height: size.height * 0.01,
              ),
              InputLabelWidget(label: 'Fin de pausa', hintText: 'Fin de pausa'),
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

  Widget itemActividad(Size size) {
    final items = [
      {'key': 1, 'value': 'Editar'},
      {'key': 2, 'value': 'Seleccionar'},
      {'key': 4, 'value': 'Eliminar'},
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: size.width * 0.025),
      child: Container(
        height: size.height * 0.2,
        decoration: BoxDecoration(
            color: cardColor,
            border: Border.all(),
            borderRadius: BorderRadius.circular(borderRadius)),
        child: Column(
          children: [
            Flexible(
              child: Container(
                child: Row(
                  children: [
                    Flexible(child: Container(), flex: 1),
                    Flexible(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text('1'),
                      ),
                      flex: 5,
                    ),
                    Flexible(child: Container(), flex: 1),
                    Flexible(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text('Jose Antonio Huanca'),
                      ),
                      flex: 20,
                    ),
                    Flexible(child: Container(), flex: 1),
                    Flexible(
                        child: Container(
                          child: DropdownBelow(
                            itemWidth: 200,
                            itemTextstyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                            boxTextstyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: cardColor),
                            boxPadding: EdgeInsets.fromLTRB(13, 12, 0, 12),
                            boxHeight: 45,
                            boxWidth: 150,
                            icon: Icon(
                              Icons.more_horiz,
                              color: primaryColor,
                            ),
                            value: 1,
                            items: items == null
                                ? []
                                : items
                                    .map((e) => DropdownMenuItem(
                                        value: e['key'],
                                        child: Text(e['value'])))
                                    .toList(),
                            onChanged: (value) {},
                          ),
                        ),
                        flex: 5),
                    Flexible(child: Container(), flex: 1),
                  ],
                ),
              ),
              flex: 1,
            ),
            Flexible(
              child: Container(
                child: Row(
                  children: [
                    Flexible(child: Container(), flex: 1),
                    Flexible(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text('Nombre labor'),
                      ),
                      flex: 10,
                    ),
                    Flexible(child: Container(), flex: 1),
                    Flexible(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text('Centro de costo'),
                      ),
                      flex: 10,
                    ),
                    Flexible(child: Container(), flex: 1),
                  ],
                ),
              ),
              flex: 1,
            ),
            Flexible(
              child: Container(
                child: Row(
                  children: [
                    Flexible(child: Container(), flex: 1),
                    Flexible(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text('5 personas'),
                      ),
                      flex: 10,
                    ),
                    Flexible(child: Container(), flex: 1),
                    Flexible(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text('SEDE'),
                      ),
                      flex: 10,
                    ),
                    Flexible(child: Container(), flex: 1),
                    Flexible(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text('Migrado'),
                      ),
                      flex: 10,
                    ),
                    Flexible(child: Container(), flex: 1),
                  ],
                ),
              ),
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _agregarMultimedia(Size size, BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed('listado_personas'),
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
                  child: Text('80 PERSONAS'),
                ),
                flex: 2),
            Flexible(
              flex: 2,
              child: Row(
                children: [
                  Flexible(
                      child: Container(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.search,
                          size: 25,
                        ),
                      ),
                      flex: 1),
                  Flexible(
                      child: Container(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.person_add,
                          size: 25,
                        ),
                      ),
                      flex: 1),
                ],
              ),
            ),
            Flexible(child: Container(), flex: 1),
          ],
        ),
      ),
    );
  }
}
