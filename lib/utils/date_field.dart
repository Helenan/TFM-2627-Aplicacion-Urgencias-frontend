import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateField extends StatefulWidget {
  final TextEditingController dateController;
  final VoidCallback submit;
  final String label;
  final String errorText;
  final String dateTooOldText;
  final String hintText;
  DateFormat? dateFormat;

  DateField({
    super.key,
    required this.dateController,
    required this.submit,
    this.label = 'Fecha',
    this.errorText = 'Introduce una fecha válida',
    this.dateTooOldText = 'Introduce una fecha más reciente',
    this.hintText = 'DD/MM/YYYY',
    this.dateFormat,
  });

  @override
  State<DateField> createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
  late DateFormat effectiveDateFormat;

  @override
  void initState() {
    super.initState();

    effectiveDateFormat = widget.dateFormat ?? DateFormat('dd/MM/yyyy');
  }

  Future<void> selectDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: widget.hintText,
    );

    if (selectedDate != null) {
      setState(() {
        widget.dateController.text = effectiveDateFormat.format(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.label,
          textAlign: TextAlign.left,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),

        TextFormField(
          controller: widget.dateController,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_month_sharp),
              onPressed: selectDate,
            ),
          ),
          validator: (value) {
            final date = value?.trim() ?? '';
            if (date.isEmpty) {
              return widget.hintText;
            }

            try {
              final formattedDate = effectiveDateFormat.parseStrict(date);

              if (formattedDate.isAfter(DateTime.now())) {
                return widget.errorText;
              }

              if (formattedDate.year < 1900) {
                return widget.dateTooOldText;
              }
            } catch (_) {
              return widget.errorText;
            }

            return null;
          },
        ),
      ],
    );
  }
}
