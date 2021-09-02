import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/colors.dart';
import 'package:flutter_tareo/core/dimens.dart';
import 'package:flutter_tareo/ui/widgets/app_bar_widget.dart';

class ListadoPersonasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: getAppBar('80 Personas', true),
      backgroundColor: secondColor,
      body: ListView(
        children: [
          itemActividad(size),
          itemActividad(size),
          itemActividad(size),
          itemActividad(size),
          itemActividad(size),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: IconButton(onPressed: ()=> Navigator.of(context).pushNamed('agregar_persona'), icon: Icon(Icons.add)),
      ),
    );
  }

  Widget itemActividad(Size size) {
    final items = [
      {'key': 1, 'value': 'Editar'},
      {'key': 2, 'value': 'Seleccionar'},
      {'key': 5, 'value': 'Eliminar'},
    ];

    return Container(
      padding: EdgeInsets.all(size.width * 0.05),
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
                      flex: 10,
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
                        child: Text('75 UNDs'),
                      ),
                      flex: 10,
                    ),
                    Flexible(child: Container(), flex: 1),
                    Flexible(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text('12:00 - 20:00'),
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
                        child: Text('PAUSA:     13:00 - 14:00'),
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
}
