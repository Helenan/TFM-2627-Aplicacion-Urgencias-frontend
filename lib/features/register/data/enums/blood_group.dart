import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum BloodGroup {
  aPositive,
  aNegative,
  bPositive,
  bNegative,
  abPositive,
  abNegative,
  oPositive,
  oNegative,
  other,
  unknown,
}

extension BloodGroupDisplayExtension on BloodGroup {
  String get displayName {
    switch (this) {
      case BloodGroup.aPositive:
        return 'A+';
      case BloodGroup.aNegative:
        return 'A-';
      case BloodGroup.bPositive:
        return 'B+';
      case BloodGroup.bNegative:
        return 'B-';
      case BloodGroup.abPositive:
        return 'AB+';
      case BloodGroup.abNegative:
        return 'AB-';
      case BloodGroup.oPositive:
        return 'O+';
      case BloodGroup.oNegative:
        return 'O-';
      case BloodGroup.other:
        return 'Otro';
      case BloodGroup.unknown:
        return 'Desconocido';
    }
  }
}

BloodGroup? getBloodGroup(String? value) {
  return BloodGroup.values.where((e) => e.name == value).firstOrNull;
}
