import 'package:cloud_functions/cloud_functions.dart';

import '../features/users/data/user.dart';

class UserService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<void> createUser(String email, String password, User user) async {
    try {
      final callable = _functions.httpsCallable('createUser');

      await callable.call({
        'email': email,
        'password': password,
        'user': user.toJson(),
      });
    } on FirebaseFunctionsException catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUser(String uid) async {
    try {
      final callable = _functions.httpsCallable('deleteUser');

      await callable.call({'uid': uid});
    } on FirebaseFunctionsException catch (e) {
      print('Código: ${e.code}');
      print('Mensaje: ${e.message}');
      print('Detalles: ${e.details}');
      rethrow;
    }
  }
}
