import 'package:flutter/material.dart';

import '../features/register/data/enums/blood_group.dart';
import 'app_dropdown.dart';

class BloodGroupSelect extends StatefulWidget {
  final BloodGroup selected;
  final ValueChanged<BloodGroup?> onChanged;
  final String label;
  final String errorText;
  final String hintText;

  const BloodGroupSelect({
    super.key,
    required this.selected,
    required this.onChanged,
    this.label = 'Grupo sanguíneo',
    this.errorText = 'Introduce un grupo sanguíneo',
    this.hintText = 'Grupo sanguíneo del paciente',
  });

  @override
  State<StatefulWidget> createState() => _BloodGroupSelectState();
}

class _BloodGroupSelectState extends State<BloodGroupSelect> {
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

        AppDropdown<BloodGroup>(
          value: widget.selected,
          items: BloodGroup.values.map((group) {
            return DropdownMenuItem(
              value: group,
              child: Text(group.displayName),
            );
          }).toList(),
          onChanged: widget.onChanged,
        ),
      ],
    );
  }
}
