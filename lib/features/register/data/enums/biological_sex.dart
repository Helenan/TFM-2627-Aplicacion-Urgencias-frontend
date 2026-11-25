import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum BiologicalSex { male, female, intersex, unspecified }

extension BiologicalSexDisplayExtension on BiologicalSex {
  String get displayName {
    switch (this) {
      case BiologicalSex.male:
        return 'Masculino';
      case BiologicalSex.female:
        return 'Femenino';
      case BiologicalSex.intersex:
        return 'Intersexual';
      case BiologicalSex.unspecified:
        return 'No especificado';
    }
  }
}

BiologicalSex? getBiologicalSex(String? value) {
  return BiologicalSex.values.where((e) => e.name == value).firstOrNull;
}
