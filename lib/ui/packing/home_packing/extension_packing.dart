import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/utils/colors.dart';
import 'package:flutter_tareo/core/utils/config.dart';
import 'package:flutter_tareo/core/utils/numbers.dart';
import 'package:flutter_tareo/ui/esparrago_varios/utils/items.dart';
import 'package:flutter_tareo/ui/packing/home_packing/home_packing_controller.dart';
import 'package:flutter_tareo/ui/utils/item_action.dart';

class ExtensionHomePacking {
  List<Map> getItemsGenerals() {
    final items = [
      {'key': 1, 'value': 'Sincronizar', 'isShow': !IS_ONLINE},
      {'key': 4, 'value': 'Exportar a EXCEL', 'isShow': !IS_ONLINE},
    ];
    return items.where((e) => e['isShow']).toList();
  }

  List<Map> getItemsSingle(int index, HomePackingController _) {
    final items = [
      {'key': 1, 'value': 'Sincronizar', 'isShow': !IS_ONLINE},
      {'key': 3, 'value': 'Eliminar', 'isShow': !_.isActive(index)},
      {'key': 4, 'value': 'Exportar a EXCEL', 'isShow': !IS_ONLINE},
      {'key': 5, 'value': 'Limpiar', 'isShow': _.isActive(index)},
    ];
    return items.where((e) => e['isShow']).toList();
  }

  List<Widget> getActions(int index, HomePackingController _) =>
      getItemsActions(actions: [
        ItemAction(
            isShow: _.isActive(index) && !IS_ONLINE,
            icon: Icons.sync,
            backgroundColor: infoColor,
            action: () => _.goMigrar(_.packings[index].key)),
        ItemAction(
            isShow: _.isActive(index) && BOOLEAN_FALSE_VALUE,
            icon: Icons.remove_red_eye,
            backgroundColor: successColor,
            action: () => {}),
        ItemAction(
            isShow: _.isActive(index),
            icon: Icons.delete_outline,
            backgroundColor: dangerColor,
            action: () => _.goEliminar(_.packings[index].getId)),
        ItemAction(
            isShow: !_.isActive(index),
            icon: Icons.search,
            backgroundColor: infoColor,
            action: () => _.goListadoPersonas(_.packings[index].getId)),
        ItemAction(
            isShow: !_.isActive(index),
            icon: Icons.check_rounded,
            backgroundColor: successColor,
            action: () => _.goAprobar(_.packings[index].getId)),
        ItemAction(
            isShow: !_.isActive(index),
            icon: Icons.edit_rounded,
            backgroundColor: alertColor,
            action: () => _.goEditar(
                  _.packings[index].getId,
                )),
        ItemAction(
            isShow: _.isActive(index),
            icon: Icons.analytics,
            backgroundColor: Color.fromARGB(255, 180, 30, 138),
            action: () => _.goReporte(
                  _.packings[index].getId,
                )),
      ]);
}



/*
  (_.packings[index].estado != 'P' &&
                              _.packings[index].estado != 'PC')
                          ? [
                              Flexible(child: Container(), flex: 1),
                              if (_.packings[index].estado != 'M')
                                Flexible(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: CircleAvatar(
                                      backgroundColor: infoColor,
                                      child: IconButton(
                                          onPressed: () =>
                                              _.goMigrar(_.packings[index].key),
                                          icon: Icon(
                                            Icons.sync,
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
                                      onPressed: null,
                                      // ()=> _.goAprobar(index),
                                      icon: Icon(Icons.remove_red_eye),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                flex: 7,
                              ),
                              Flexible(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: CircleAvatar(
                                    backgroundColor: dangerColor,
                                    child: IconButton(
                                      onPressed: () =>
                                          _.goEliminar(_.packings[index].key),
                                      icon: Icon(Icons.delete),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                flex: 7,
                              ),
                              Flexible(child: Container(), flex: 1),
                            ]
                          : [
                              Flexible(child: Container(), flex: 1),
                              Flexible(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: CircleAvatar(
                                    backgroundColor: infoColor,
                                    child: IconButton(
                                        onPressed: () => _.goListadoPersonas(
                                            _.packings[index].key),
                                        icon: Icon(
                                          Icons.search,
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
                                      onPressed: () =>
                                          _.goAprobar(_.packings[index].key),
                                      icon: Icon(Icons.check_rounded),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                flex: 7,
                              ),
                              if (_.packings[index].estado == 'PC')
                                Flexible(child: Container(), flex: 1),
                              if (_.packings[index].estado == 'PC')
                                Flexible(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: CircleAvatar(
                                      backgroundColor: alertColor,
                                      child: IconButton(
                                        onPressed: () => _.goEditar(
                                          _.packings[index].key,
                                        ),
                                        icon: Icon(Icons.edit),
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
                                    backgroundColor:
                                        Color.fromARGB(255, 180, 30, 138),
                                    child: IconButton(
                                      onPressed: () => _.goReporte(
                                        _.packings[index].key,
                                      ),
                                      icon: Icon(Icons.analytics),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                flex: 7,
                              ),
                            ],
                    
 */