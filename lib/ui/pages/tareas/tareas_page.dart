import 'package:dropdown_below/dropdown_below.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/colors.dart';
import 'package:flutter_tareo/core/dimens.dart';
import 'package:flutter_tareo/ui/pages/tareas/tareas_controller.dart';
import 'package:flutter_tareo/ui/widgets/empty_data_widget.dart';
import 'package:get/get.dart';

class TareasPage extends StatelessWidget {
  final TareasController controller = Get.find<TareasController>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GetBuilder<TareasController>(
      init: controller,
      builder: (_) => Stack(
        children: [
          Scaffold(
            //appBar: getAppBar('Inicio', true),
            backgroundColor: secondColor,
            body: GetBuilder<TareasController>(
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
                    child: RefreshIndicator(
                      onRefresh: _.getTareas,
                      child: GetBuilder<TareasController>(
                        id: 'tareas',
                        builder: (_) => _.tareas.isEmpty
                            ? EmptyDataWidget(
                                titulo: 'No existen tareas.',
                                size: size,
                                onPressed: _.getTareas)
                            : ListView.builder(
                                itemCount: _.tareas.length,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        itemActividad(size, context, index),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: _.goNuevaTarea,
              child: Icon(Icons.add),
            ),
          ),
          GetBuilder<TareasController>(
                id: 'validando',
                builder: (_)=> _.validando ? Container(
                  color: Colors.black45,
                  child: Center(child: CircularProgressIndicator()),
                ) : Container(),
              ),
        ],
      ),
    );
  }

  Widget itemActividad(Size size, BuildContext context, int index) {
    final items = [
      /* {'key': 1, 'value': 'Seleccionar'}, */
      {'key': 1, 'value': 'Exportar Excel'},
      {'key': 2, 'value': 'Copiar tarea'},
      //aparece un formulario de nueva tarea con los datos cargados
      {'key': 3, 'value': 'Eliminar'},
    ];

    return GetBuilder<TareasController>(
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
                                color: _.tareas[index].colorEstado,
                              ),
                            ),
                            flex: 1),
                        Flexible(child: Container(), flex: 1),
                        Flexible(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _.tareas[index].fechaHora,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 14),
                            ),
                          ),
                          flex: 10,
                        ),
                        Flexible(child: Container(), flex: 1),
                        Flexible(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              _.tareas[index].actividad?.descripcion ?? '',
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
                                  boxPadding:
                                      EdgeInsets.fromLTRB(13, 12, 0, 12),
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
                                  onChanged: (value) => _.onChangedMenu(
                                      value, _.tareas[index].key)),
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
                            child:
                                Text(_.tareas[index].labor?.descripcion ?? ''),
                          ),
                          flex: 10,
                        ),
                        Flexible(child: Container(), flex: 1),
                        Flexible(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(_.tareas[index].centroCosto
                                    ?.detallecentrocosto ??
                                ''),
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    child: Text(
                                        (_.tareas[index].sizeDetails ?? 0)
                                            .toString())),
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
                            child: Text(
                                _.tareas[index].sede?.detallesubdivision ?? ''),
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
                        if(_.tareas[index].estadoLocal!='M')
                        Flexible(
                          child: Container(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              backgroundColor: infoColor,
                              child: IconButton(
                                  onPressed: () => _
                                              .tareas[index].estadoLocal ==
                                          'P'
                                      ? _.goListadoPersonas(_.tareas[index].key)
                                      : _.goMigrar(_.tareas[index].key),
                                  icon: Icon(
                                    _.tareas[index].estadoLocal == 'P'
                                        ? Icons.search
                                        : Icons.sync,
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
                                /* onPressed: () =>
                                          _.goAgregarPersona(index),
                                      icon: Icon(Icons.person_add), */
                                onPressed: () =>
                                    _.tareas[index].estadoLocal == 'P'
                                        ? _.goAprobar(_.tareas[index].key)
                                        : null,
                                icon: _.tareas[index].estadoLocal == 'P'
                                    ? Icon(Icons.check)
                                    : Icon(Icons.remove_red_eye),
                                color: Colors.white,
                              ),
                            ),
                          ),
                          flex: 7,
                        ),
                        Flexible(child: Container(), flex: 1),
                        Flexible(
                          child: Container(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              backgroundColor: _.tareas[index].estadoLocal=='P' ? alertColor : dangerColor,
                              child: IconButton(
                                onPressed: () =>
                                     _.tareas[index].estadoLocal=='P' ? _.goEditar(_.tareas[index].key,) : _.goEliminar(_.tareas[index].key,),
                                icon:  Icon( _.tareas[index].estadoLocal=='P' ? Icons.edit  : Icons.delete ),
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
        ),
      ),
    );
  }

  Widget _opcionesSeleccionados() {
    final items = [
      {'key': 1, 'value': 'Seleccionar todos'},
      {'key': 2, 'value': 'Quitar todos'},
      {'key': 3, 'value': 'Exportar en excel'},
    ];

    return GetBuilder<TareasController>(
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
                  onChanged: (value) {},
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
