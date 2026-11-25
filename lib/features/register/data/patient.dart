import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tfm_2627_aplicacion_urgencias_frontend/features/register/data/enums/biological_sex.dart';

import 'enums/allergy_knowledge.dart';
import 'enums/blood_group.dart';

part 'patient.freezed.dart';
part 'patient.g.dart';

@freezed
abstract class Patient with _$Patient {
  const Patient._();

  const factory Patient({
    required String identityDocument,
    required String firstName,
    required String lastName,
    required String dateOfBirth, // There is no date type
    @Default(BiologicalSex.unspecified) BiologicalSex biologicalSex,
    @Default(BloodGroup.unknown) BloodGroup bloodGroup,
    String? otherBloodGroup, // Only used when bloodGroup is 'other'
    @Default(AllergyKnowledge.unknown) AllergyKnowledge allergyKnowledge,
    String? allergies,
    String? actualMedication, // Medication taken regardless of their stay in the emergency room
    String? chronicDiseases,
    String? otherMedicalInformation,
  }) = _Patient;

  factory Patient.fromJson(Map<String, dynamic> json) =>
      _$PatientFromJson(json);
}
