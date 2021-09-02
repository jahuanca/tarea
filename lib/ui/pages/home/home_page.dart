import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/colors.dart';
import 'package:flutter_tareo/core/dimens.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      //appBar: getAppBar('Inicio', true),
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
        child: IconButton(onPressed: ()=> Navigator.of(context).pushNamed('nueva_tarea'), icon: Icon(Icons.add)),
      ),
    );
  }

  Widget itemActividad(Size size) {
    final items = [
      {'key': 1, 'value': 'Seleccionar'},
      {'key': 2, 'value': 'Sincronizar'},
      {'key': 3, 'value': 'Eliminar'},
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
                        child: Text('12/08/21 14:12'),
                      ),
                      flex: 10,
                    ),
                    Flexible(child: Container(), flex: 1),
                    Flexible(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text('Nombre de actvidad'),
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
}
