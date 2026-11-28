import 'package:freezed_annotation/freezed_annotation.dart';

part 'specialty.freezed.dart';
part 'specialty.g.dart';

@freezed
abstract class Specialty with _$Specialty {
  const Specialty._();

  const factory Specialty({
    required String name,
    @JsonKey(toJson: _subspecialtiesToJson)
    @Default([])
    List<Specialty> subspecialties,
  }) = _Specialty;

  factory Specialty.fromJson(Map<String, dynamic> json) =>
      _$SpecialtyFromJson(json);
}

List<Map<String, dynamic>> _subspecialtiesToJson(
  List<Specialty> subspecialties,
) => subspecialties.map((subspecialty) => subspecialty.toJson()).toList();
