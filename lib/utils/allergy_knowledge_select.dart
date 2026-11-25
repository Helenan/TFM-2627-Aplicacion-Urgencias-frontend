import 'package:flutter/material.dart';

import '../features/register/data/enums/allergy_knowledge.dart';
import 'app_dropdown.dart';

class AllergyKnowledgeSelect extends StatefulWidget {
  final AllergyKnowledge selected;
  final ValueChanged<AllergyKnowledge?> onChanged;
  final String label;
  final String errorText;
  final String hintText;

  const AllergyKnowledgeSelect({
    super.key,
    required this.selected,
    required this.onChanged,
    this.label = 'Alergias conocidas',
    this.errorText = 'Introduce un estado de alergias conocidas',
    this.hintText = 'Estado de conocimiento de alergias del paciente',
  });

  @override
  State<StatefulWidget> createState() => _AllergyKnowledgeSelectState();
}

class _AllergyKnowledgeSelectState extends State<AllergyKnowledgeSelect> {
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

        AppDropdown<AllergyKnowledge>(
          value: widget.selected,
          items: AllergyKnowledge.values.map((knowledge) {
            return DropdownMenuItem(
              value: knowledge,
              child: Text(knowledge.displayName),
            );
          }).toList(),
          onChanged: widget.onChanged,
        ),
      ],
    );
  }
}
