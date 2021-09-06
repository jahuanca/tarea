
import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/colors.dart';
import 'package:flutter_tareo/ui/widgets/dropdown_simple_widget.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final items = [
      {'_id': 1, 'name': 'Fecha'},
      {'_id': 2, 'name': 'Actividad'},
      {'_id': 3, 'name': 'Labor'},
    ];

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        //leading: Icon(Icons.arrow_back, color: Colors.black54,),
        automaticallyImplyLeading: true,
        backgroundColor: cardColor,
        title: Row(
          children: [
            Flexible(
              flex: 3,
              child: Container(
                child: TextFormField(
                  decoration: InputDecoration.collapsed(hintText: 'Buscar'),
                ),
              ),
            ),
            Flexible(
              child: Container(
                child: DropdownSimpleWidget(
                  labelText: 'name',
                  labelValue: '_id',
                  initialValue: '1',
                  onChanged: (value) {},
                  items: items),
              ),
              flex: 2,
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          _itemResultado(size),
          _itemResultado(size),
          _itemResultado(size),
        ],
      ),
    );
  }

  Widget _itemResultado(Size size) {
    return Container(
      child: ListTile(
        //leading: Icon(Icons.flutter_dash),
        title: Text('Titulo'),
        subtitle: Text('Sub titulo'),
      ),
    );
  }
}
