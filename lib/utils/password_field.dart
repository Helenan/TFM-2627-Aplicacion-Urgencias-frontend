import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController passwordController;
  final VoidCallback submit;
  final String label;
  final String errorText;
  final String hintText;
  final String obscureTooltip;
  final String revealTooltip;

  const PasswordField({
    super.key,
    required this.passwordController,
    required this.submit,
    this.label = 'Contraseña',
    this.errorText = 'Introduce tu contraseña',
    this.hintText = 'Contraseña',
    this.obscureTooltip = 'Ocultar contraseña',
    this.revealTooltip = 'Mostrar contraseña',
  });

  @override
  State<StatefulWidget> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscurePassword = true;

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

        TextFormField(
          controller: widget.passwordController,
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.password],
          onFieldSubmitted: (_) => widget.submit(),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              tooltip: _obscurePassword
                  ? widget.revealTooltip
                  : widget.obscureTooltip,
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return widget.hintText;
            }

            if (value.length < 6) {
              return 'Debe tener al menos 6 caracteres';
            }

            return null;
          },
        ),
      ],
    );
  }
}
