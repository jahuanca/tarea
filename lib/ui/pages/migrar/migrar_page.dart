import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/colors.dart';
import 'package:flutter_tareo/core/dimens.dart';

class MigrarPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      //appBar: getAppBar('Inicio', true),
      backgroundColor: secondColor,
      body: ListView(
        children: [
          itemActividad(size, context),
          itemActividad(size, context),
          itemActividad(size, context),
          itemActividad(size, context),
          itemActividad(size, context),
        ],
      ),
    );
  }

  Widget itemActividad(Size size, BuildContext context) {
    final items = [
      {'key': 1, 'value': 'Seleccionar'},
      //aparece un formulario de nueva tarea con los datos cargados
      {'key': 6, 'value': 'Eliminar'},
    ];

    return Container(
      padding: EdgeInsets.symmetric(
          vertical: size.width * 0.03, horizontal: size.width * 0.05),
      child: Container(
        height: size.height * 0.27,
        decoration: BoxDecoration(
            color: cardColor,
            border: Border.all(),
            borderRadius: BorderRadius.circular(borderRadius)),
        child: Column(
          children: [
            Flexible(
              child: Container(),
              flex: 1,
            ),
            Flexible(
              child: Container(
                child: Row(
                  children: [
                    Flexible(child: Container(), flex: 1),
                    Flexible(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Container(
                            color: primaryColor,
                          ),
                        ),
                        flex: 1),
                    Flexible(child: Container(), flex: 1),
                    Flexible(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '12/08/21 14:12',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      flex: 10,
                    ),
                    Flexible(child: Container(), flex: 1),
                    Flexible(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Nombre de actividad',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      flex: 15,
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
              flex: 4,
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
              flex: 4,
            ),
            Flexible(
              child: Container(
                child: Row(
                  children: [
                    Flexible(child: Container(), flex: 1),
                    Flexible(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Text('5')),
                            Icon(
                              Icons.people,
                              color: Colors.black45,
                            )
                          ],
                        ),
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
                  ],
                ),
              ),
              flex: 4,
            ),
            Flexible(child: Container(), flex: 1),
            Flexible(
              child: Container(
                child: Row(
                  children: [
                    Flexible(child: Container(), flex: 1),
                    Flexible(
                      child: Container(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          backgroundColor: infoColor,
                          child: IconButton(
                              onPressed: null,//() => Navigator.of(context).pushNamed('listado_personas'),
                              icon: Icon(
                                Icons.sync_rounded,
                                color: Colors.white,
                              )),
                        ),
                      ),
                      flex: 7,
                    ),
                    Flexible(child: Container(), flex: 1),
                    Flexible(
                      child: Container(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          backgroundColor: successColor,
                          child: IconButton(
                            onPressed: ()=> Navigator.of(context).pushNamed('nueva_tarea'),
                            icon: Icon(Icons.remove_red_eye),
                            color: Colors.white,
                          ),
                        ),
                      ),
                      flex: 7,
                    ),
                    Flexible(child: Container(), flex: 1),
                  ],
                ),
              ),
              flex: 4,
            ),
            Flexible(
              child: Container(),
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }
}
