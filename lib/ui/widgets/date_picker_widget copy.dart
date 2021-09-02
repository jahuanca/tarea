import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DatePickerWidget {
  final Size size;
  final String placeholder;
  final IconData icon;
  final TextEditingController textEditingController;
  final String texto;
  final TextInputType textInputType;
  /* final void Function(DateTime, TimeOfDay) onChanged; */
  final void Function() onChanged;
  final String error;
  final DateTime dateSelected;
  final DateTime minDate;
  final int maxYear;
  final int minYear;
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

    if (picked != null && onChanged != null) {
      return await _selectTime(context, picked);
    }
    return null;
  }

  Future<DateTime> _selectTime(BuildContext context, DateTime selectedDate) async {
    TimeOfDay picked;
    picked = await showTimePicker(
      context: context,
      initialTime:
          (minDate != null) ? TimeOfDay.fromDateTime(minDate) : TimeOfDay.now(),
    );

    selectedDate = new DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      picked.hour,
      picked.minute,
    );
    return selectedDate;
    //onChanged(selectedDate, picked);
  }

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;
}
