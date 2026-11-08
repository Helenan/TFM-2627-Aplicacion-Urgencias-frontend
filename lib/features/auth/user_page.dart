import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:tfm_2627_aplicacion_urgencias_frontend/utils/email_field.dart';
import 'package:tfm_2627_aplicacion_urgencias_frontend/utils/password_field.dart';
import 'package:tfm_2627_aplicacion_urgencias_frontend/utils/role_select.dart';

import '../../utils/error_container.dart';
import '../users/data/enums/user_role.dart';
import '../users/data/user.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _specialtyController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();

  bool _error = false;
  String _errorMessage = '';
  UserRole _selectedUserRole = UserRole.doctor;

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final password = _passwordController.text.trim();

    if (password != _passwordConfirmationController.text.trim()) {
      _error = true;
      _errorMessage = 'Las contraseñas no son iguales';
      return;
    }
    final email = _emailController.text.trim();

    final newUser = User.create(
      role: _selectedUserRole,
      mail: email,
      firstName: _nameController.text.trim(),
      lastName: _surnameController.text.trim(),
      speciality: _specialtyController.text.trim(),
    );

    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    final firebaseUser = credential.user;

    if (firebaseUser == null) {
      _error = true;
      _errorMessage = 'No se ha podido crear el usuario.';
      return;
    }

    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(firebaseUser.uid)
        .set({
          ...newUser.toJson(),
          'uid': firebaseUser.uid,
          'createdAt': DateTime.now(),
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 420,
                    minHeight: constraints.maxHeight - 48,
                  ),
                  child: IntrinsicHeight(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Añadir un usuario',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          ),

                          const SizedBox(height: 36),

                          Text(
                            'Nombre',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 10),

                          TextFormField(
                            controller: _nameController,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => () {},
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nombre del usuario';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 22),

                          Text(
                            'Apellidos',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 10),

                          TextFormField(
                            controller: _surnameController,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => () {},
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Apellidos del usuario';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 22),

                          RoleSelect(
                            selectedRole: _selectedUserRole,
                            onChanged: (role) {
                              if (role == null) {
                                throw ArgumentError.notNull('role');
                              }
                              setState(() {
                                _selectedUserRole = role;
                              });
                            },
                          ),

                          if (_selectedUserRole == UserRole.doctor) ...[
                            const SizedBox(height: 22),

                            Text(
                              'Especialidad',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 10),

                            TextFormField(
                              controller: _specialtyController,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => () {},
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Especialidad del doctor';
                                }

                                return null;
                              },
                            ),
                          ],

                          const SizedBox(height: 22),

                          EmailField(
                            emailController: _emailController,
                            submit: () {},
                          ),

                          const SizedBox(height: 22),

                          PasswordField(
                            passwordController: _passwordController,
                            submit: () {},
                          ),

                          const SizedBox(height: 22),

                          PasswordField(
                            passwordController: _passwordConfirmationController,
                            submit: () {},
                            label: 'Confirma la contraseña',
                          ),

                          if (_error) ...[
                            const SizedBox(height: 22),
                            ErrorContainer(errorMessage: _errorMessage),
                          ],

                          const SizedBox(height: 16),

                          SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _submit,
                              child: const Text('Crear usuario'),
                            ),
                          ),

                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
