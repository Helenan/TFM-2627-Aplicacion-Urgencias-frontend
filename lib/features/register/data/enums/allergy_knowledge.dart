import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum AllergyKnowledge { withKnownAllergies, noKnownAllergies, unknown }

extension AllergyKnowledgeDisplayExtension on AllergyKnowledge {
  String get displayName {
    switch (this) {
      case AllergyKnowledge.withKnownAllergies:
        return 'Tiene alergias conocidas';
      case AllergyKnowledge.noKnownAllergies:
        return 'Sin alergias conocidas';
      case AllergyKnowledge.unknown:
        return 'Desconocido';
    }
  }
}

AllergyKnowledge? getAllergyKnowledge(String? value) {
  return AllergyKnowledge.values.where((e) => e.name == value).firstOrNull;
}
