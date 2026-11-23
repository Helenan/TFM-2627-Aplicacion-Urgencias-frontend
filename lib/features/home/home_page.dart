import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tfm_2627_aplicacion_urgencias_frontend/services/auth_service.dart';
import 'package:tfm_2627_aplicacion_urgencias_frontend/utils/bottom_navbar.dart';
import 'package:tfm_2627_aplicacion_urgencias_frontend/utils/error_banner.dart';
import 'package:tfm_2627_aplicacion_urgencias_frontend/utils/nav_entry.dart';

import '../../app/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final authorization = AuthorizationService();
  bool _isAdmin = false;
  bool _isDoctor = false;

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  Future<void> _checkUser() async {
    final admin = await authorization.isAdmin();
    final doctor = await authorization.isDoctor();

    if (!mounted) return;

    setState(() {
      _isAdmin = admin;
      _isDoctor = doctor;
    });
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      showErrorBanner(context, 'No se ha podido cerrar la sesión.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Urgencias'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: _logout,
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text('Menú', style: TextStyle(fontSize: 24)),
              ),
              const Divider(height: 1),
              if (_isDoctor)
                ListTile(
                  leading: const Icon(Icons.local_hospital, color: Colors.blue),
                  title: const Text('Registrar paciente'),
                  onTap: () {
                    Navigator.pop(context); // close the drawer
                    Navigator.pushNamed(context, AppRoutes.register);
                  },
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _isDoctor
          ? BottomNavbar(
              entries: [
                NavEntry(
                  icon: const Icon(
                    Icons.local_hospital,
                    color: Colors.blue,
                    size: 36,
                  ),
                  label: 'Registrar paciente',
                  onTap: (context) =>
                      Navigator.pushNamed(context, AppRoutes.register),
                ),
              ],
            )
          : null,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              if (_isAdmin)
                Card(
                  clipBehavior: Clip.hardEdge,
                  color: Colors.white70,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.user);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.person_add_alt_1,
                                size: 24,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Crear usuario',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Registrar un nuevo usuario.',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
