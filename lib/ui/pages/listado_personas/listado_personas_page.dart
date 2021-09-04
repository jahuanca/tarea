import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/colors.dart';
import 'package:flutter_tareo/core/dimens.dart';
import 'package:flutter_tareo/ui/pages/listado_personas/listado_personas_controller.dart';
import 'package:flutter_tareo/ui/widgets/app_bar_widget.dart';
import 'package:get/get.dart';

class ListadoPersonasPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GetBuilder<ListadoPersonasController>(
      init: ListadoPersonasController(),
      builder: (_) => Scaffold(
        appBar: getAppBar('80 Personas', [
          IconButton(onPressed: (){}, icon: Icon(Icons.qr_code)),
          IconButton(onPressed: (){}, icon: Icon(Icons.search)),
        ], true),
        backgroundColor: secondColor,
        body: GetBuilder<ListadoPersonasController>(
            id: 'seleccionado',
            builder: (_) => Column(
              children: [
                if (_.seleccionados.length > 0)
                  Flexible(
                    flex: 1,
                    child: AnimatedContainer(
                        child: _opcionesSeleccionados(),
                        duration: Duration(seconds: 1)),
                  ),
                Flexible(
                  flex: 8,
                  child: Container(
                    child: ListView.builder(
                      itemCount: 5,
                      itemBuilder: (BuildContext context, int index) =>
                          itemActividad(size, context, index),
                    ),
                  ),
                ),
              ],
            ),
          ),
        floatingActionButton: FloatingActionButton(
          child: IconButton(onPressed: ()=> Navigator.of(context).pushNamed('agregar_persona'), icon: Icon(Icons.add)),
        ),
      ),
    );
  }

  Widget itemActividad(Size size, context, index) {
    final items = [
      {'key': 1, 'value': 'Editar'},
      {'key': 2, 'value': 'Seleccionar'},
      {'key': 5, 'value': 'Eliminar'},
    ];

    return GetBuilder<ListadoPersonasController>(
      id: 'seleccionado',
      builder: (_) => GestureDetector(
        onLongPress: () => _.seleccionar(index),
        child: Container(
          decoration: BoxDecoration(
            color:
                (_.seleccionados.contains(index)) ? Colors.blue : secondColor,
            border: (_.seleccionados.contains(index))
                ? Border.all()
                : Border.all(color: Colors.transparent),
          ),
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
                              onChanged: (value) {
                                
                              },
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
      ),
    ));
  }

  Widget _opcionesSeleccionados() {
    final items = [
      {'key': 1, 'value': 'Seleccionar todos'},
      {'key': 2, 'value': 'Quitar todos'},
      {'key': 3, 'value': 'Actualizar datos'},
    ];

    return GetBuilder<ListadoPersonasController>(
      id: 'seleccionado',
      builder: (_) => Container(
        decoration: BoxDecoration(color: Colors.white, border: Border.all()),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(child: Container(), flex: 1),
            Flexible(
              child: Container(
                child: Text(
                  '${_.seleccionados.length} seleccionados',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),
              flex: 12,
            ),
            Flexible(child: Container(), flex: 6),
            Flexible(
              child: Container(
                alignment: Alignment.center,
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
                              value: e['key'], child: Text(e['value'])))
                          .toList(),
                  onChanged: _.changeOptionsGlobal,
                ),
              ),
              flex: 4,
            ),
            Flexible(child: Container(), flex: 1),
          ],
        ),
      ),
    );
  }
}
