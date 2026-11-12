import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tfm_2627_aplicacion_urgencias_frontend/features/users/data/enums/user_role.dart';

class AuthorizationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? get currentUid => _auth.currentUser?.uid;

  bool get isAuthenticated => currentUid != null;

  Future<UserRole?> getCurrentRole() async {
    final uid = currentUid;

    if (uid == null) return null;

    final doc = await _firestore.collection('usuarios').doc(uid).get();

    return getUserRole(doc.data()?['role']);
  }

  Future<bool> hasRole(UserRole role) async {
    return await getCurrentRole() == role;
  }

  Future<bool> isAdmin() async => hasRole(UserRole.admin);

  Future<bool> isDoctor() async => hasRole(UserRole.doctor);

  Future<bool> isNurse() async => hasRole(UserRole.nurse);
}
