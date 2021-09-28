import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tareo/ui/utils/alert_dialogs.dart';

class DatePickerWidget {
  final Size size;
  final String placeholder;
  final IconData icon;
  final TextEditingController textEditingController;
  final String texto;
  final TextInputType textInputType;
  final void Function() onChanged;
  final String error;
  final DateTime dateSelected;
  final DateTime minDate;
  final int maxYear;
  final int minYear;
  final bool onlyDate;
  final BuildContext context;

  DatePickerWidget({
    this.context,
    this.size,
    this.texto,
    this.placeholder,
    this.icon,
    this.textEditingController,
    this.textInputType = TextInputType.name,
    this.onChanged,
    this.error,
    this.onlyDate = true,
    this.dateSelected,
    this.maxYear = 2022,
    this.minYear = 2019,
    this.minDate,
  });

  Future<DateTime> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        locale: Locale('es', ''),
        initialDate: minDate ?? dateSelected,
        firstDate: minDate ?? DateTime(minYear),
        lastDate: DateTime(maxYear));
    if (onlyDate) {
      return picked;
    } else {
      if (picked != null && onChanged != null) {
        return await selectTime(context, picked);
      }
      return null;
    }
  }

  Future<DateTime> selectTime(
      BuildContext context, DateTime selectedDate) async {
    TimeOfDay picked;
    picked = await showTimePicker(
      context: context,
      initialTime:
          (minDate != null) ? TimeOfDay.fromDateTime(minDate) : TimeOfDay.now(),
    );
    if (picked == null) {
      return selectedDate;
    }
    selectedDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      picked.hour,
      picked.minute,
    );

    if (toDouble(picked) > toDouble(TimeOfDay.fromDateTime(minDate))) {
      return selectedDate;
    } else {
      toastError('Error', 'Fecha debe ser mayor');
      return dateSelected;
    }
    //onChanged(selectedDate, picked);
  }

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;
}
