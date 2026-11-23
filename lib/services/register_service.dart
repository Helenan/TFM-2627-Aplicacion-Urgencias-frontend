import 'package:cloud_functions/cloud_functions.dart';

import '../features/register/data/patient_register.dart';

class RegisterService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<void> registerPatient(PatientRegister patientRegister) async {
    try {
      final callable = _functions.httpsCallable('registerPatient');

      await callable.call({'register': patientRegister.toJson()});
    } on FirebaseFunctionsException {
      rethrow;
    }
  }
}
