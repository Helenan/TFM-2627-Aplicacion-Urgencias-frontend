import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum UserRole { admin, doctor, nurse }

extension UserRoleDisplayExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Administrador';
      case UserRole.doctor:
        return 'Doctor';
      case UserRole.nurse:
        return 'Enfermero';
    }
  }
}
