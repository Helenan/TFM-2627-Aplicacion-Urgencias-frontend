import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tfm_2627_aplicacion_urgencias_frontend/features/register/data/patient.dart';
import 'package:tfm_2627_aplicacion_urgencias_frontend/features/register/data/specialty.dart';

part 'patient_register.freezed.dart';
part 'patient_register.g.dart';

@freezed
abstract class PatientRegister with _$PatientRegister {
  const PatientRegister._();

  const factory PatientRegister({
    @JsonKey(toJson: _registerPatientToJson, fromJson: Patient.fromJson)
    required Patient patient,
    required String symptoms,
    @JsonKey(toJson: _registerSpecialtyToJson, fromJson: Specialty.fromJson)
    required Specialty specialty,
    // Medication/treatment prescribed for their care in the emergency room
    String? treatment,
    @Default(true) bool isOpen,
    String? doctor,
    String? nurse,
  }) = _PatientRegister;

  factory PatientRegister.fromJson(Map<String, dynamic> json) =>
      _$PatientRegisterFromJson(json);
}

Map<String, dynamic> _registerPatientToJson(Patient patient) =>
    patient.toJson();

Map<String, dynamic> _registerSpecialtyToJson(Specialty specialty) =>
    specialty.toJson();
