import 'package:cloud_functions/cloud_functions.dart';
import '../features/register/data/patient.dart';

class PatientService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<void> createPatient(Patient patient) async {
    try {
      final callable = _functions.httpsCallable('createPatient');

      await callable.call({'patient': patient.toJson()});
    } on FirebaseFunctionsException {
      rethrow;
    }
  }

  Future<void> updatePatient(String uid) async {
    try {
      final callable = _functions.httpsCallable('updatePatient');

      await callable.call({'uid': uid});
    } on FirebaseFunctionsException catch (e) {
      print('Código: ${e.code}');
      print('Mensaje: ${e.message}');
      print('Detalles: ${e.details}');
      rethrow;
    }
  }

  Future<Patient> findPatient(String uid) async {
    try {
      final callable = _functions.httpsCallable('findPatient');

      final result = await callable.call({'uid': uid});

      return Patient.fromJson(result.data);
    } on FirebaseFunctionsException catch (e) {
      print('Código: ${e.code}');
      print('Mensaje: ${e.message}');
      print('Detalles: ${e.details}');
      rethrow;
    }
  }

  Future<List<Patient>> queryPatient(String identityDocument) async {
    try {
      final callable = _functions.httpsCallable('queryPatient');

      final result = await callable.call({'identityDocument': identityDocument});

      return (result.data as List)
          .map((patient) => Patient.fromJson(Map<String, dynamic>.from(patient)))
          .toList();
    } on FirebaseFunctionsException catch (e) {
      print('Código: ${e.code}');
      print('Mensaje: ${e.message}');
      print('Detalles: ${e.details}');
      rethrow;
    }
  }
}
