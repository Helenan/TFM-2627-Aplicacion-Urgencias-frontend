import 'package:flutter/material.dart';
import 'package:tfm_2627_aplicacion_urgencias_frontend/features/register/data/enums/biological_sex.dart';

import 'app_dropdown.dart';

class BiologicalSexSelect extends StatefulWidget {
  final BiologicalSex selected;
  final ValueChanged<BiologicalSex?> onChanged;
  final String label;
  final String errorText;
  final String hintText;

  const BiologicalSexSelect({
    super.key,
    required this.selected,
    required this.onChanged,
    this.label = 'Sexo biológico',
    this.errorText = 'Introduce un sexo biológico',
    this.hintText = 'Sexo biológico del paciente',
  });

  @override
  State<StatefulWidget> createState() => _BiologicalSexSelectState();
}

class _BiologicalSexSelectState extends State<BiologicalSexSelect> {
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

        AppDropdown<BiologicalSex>(
          value: widget.selected,
          items: BiologicalSex.values.map((sex) {
            return DropdownMenuItem(value: sex, child: Text(sex.displayName));
          }).toList(),
          onChanged: widget.onChanged,
        ),
      ],
    );
  }
}
