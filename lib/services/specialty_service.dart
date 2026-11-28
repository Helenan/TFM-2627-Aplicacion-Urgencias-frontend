import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';

import '../features/register/data/specialty.dart';

class SpecialtyService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<List<Specialty>> querySpecialty(String name) async {
    try {
      final callable = _functions.httpsCallable('querySpecialty');

      final result = await callable.call({'name': name});
      
      return (jsonDecode(jsonEncode(result.data)) as List)
          .map((specialty) => Specialty.fromJson(specialty))
          .toList();
    } on FirebaseFunctionsException catch (e) {
      print('Código: ${e.code}');
      print('Mensaje: ${e.message}');
      print('Detalles: ${e.details}');
      rethrow;
    }
  }
}
