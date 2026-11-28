import 'package:freezed_annotation/freezed_annotation.dart';

import '../../register/data/specialty.dart';
import 'enums/user_role.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@Freezed(unionKey: 'type')
abstract class User with _$User {
  const User._();

  const factory User.admin({
    required String mail,
    required String firstName,
    required String lastName,
    @Default(UserRole.admin) UserRole role,
  }) = Admin;

  const factory User.doctor({
    required String mail,
    required String firstName,
    required String lastName,
    @Default(UserRole.doctor) UserRole role,
    @JsonKey(toJson: _doctorSpecialtyToJson, fromJson: Specialty.fromJson)
    required Specialty speciality,
  }) = Doctor;

  const factory User.nurse({
    required String mail,
    required String firstName,
    required String lastName,
    @Default(UserRole.nurse) UserRole role,
  }) = Nurse;

  factory User.create({
    required UserRole role,
    required String mail,
    required String firstName,
    required String lastName,
    Specialty? speciality,
    List<String>? permissions,
  }) {
    switch (role) {
      case UserRole.admin:
        return User.admin(mail: mail, firstName: firstName, lastName: lastName);

      case UserRole.doctor:
        return User.doctor(
          mail: mail,
          firstName: firstName,
          lastName: lastName,
          speciality: speciality ?? (throw ArgumentError.notNull('speciality')),
        );

      case UserRole.nurse:
        return User.nurse(mail: mail, firstName: firstName, lastName: lastName);
    }
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

Map<String, dynamic> _doctorSpecialtyToJson(Specialty specialty) =>
    specialty.toJson();
