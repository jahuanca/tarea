
import 'package:flutter/material.dart';
import 'package:flutter_tareo/core/colors.dart';
import 'package:flutter_tareo/ui/widgets/app_bar_widget.dart';
import 'package:flutter_tareo/ui/widgets/dropdown_label_widget.dart';

class AgregarPersonaPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    final Size size=MediaQuery.of(context).size;

    return Scaffold(
      appBar: getAppBar('Agregar persona'),
      backgroundColor: secondColor,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: size.width*0.05),
          child: Column(
            children: [
              DropdownLabelWidget(
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
            ],
          ),
        ),
      ),
    );
  }
}