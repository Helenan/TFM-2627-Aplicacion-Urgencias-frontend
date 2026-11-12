import 'package:flutter/material.dart';
import 'package:tfm_2627_aplicacion_urgencias_frontend/features/users/data/enums/user_role.dart';

class RoleSelect extends StatefulWidget {
  final UserRole selectedRole;
  final ValueChanged<UserRole?> onChanged;
  final String label;
  final String errorText;
  final String hintText;

  const RoleSelect({
    super.key,
    required this.selectedRole,
    required this.onChanged,
    this.label = 'Rol del usuario',
    this.errorText = 'Introduce un rol',
    this.hintText = 'Rol del usuario',
  });

  @override
  State<StatefulWidget> createState() => _RoleSelectState();
}

class _RoleSelectState extends State<RoleSelect> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.label,
          textAlign: TextAlign.left,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),

        DropdownButtonFormField<UserRole>(
          items: UserRole.values.map((role) {
            return DropdownMenuItem(value: role, child: Text(role.displayName));
          }).toList(),
          onChanged: widget.onChanged,
        ),
      ],
    );
  }
}
