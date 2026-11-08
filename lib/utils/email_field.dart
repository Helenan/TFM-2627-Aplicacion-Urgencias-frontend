import 'package:flutter/material.dart';

class EmailField extends StatefulWidget {
  final TextEditingController emailController;
  final VoidCallback submit;
  final String label;
  final String errorText;
  final String hintText;

  const EmailField({
    super.key,
    required this.emailController,
    required this.submit,
    this.label = 'Correo electrónico',
    this.errorText = 'Introduce tu correo electrónico',
    this.hintText = 'tucorreo@direccion.com',
  });

  @override
  State<StatefulWidget> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
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
          controller: widget.emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.email],
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.email_outlined),
          ),
          validator: (value) {
            final email = value?.trim() ?? '';

            if (email.isEmpty) {
              return widget.hintText;
            }

            final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

            if (!emailRegex.hasMatch(email)) {
              return 'Introduce un correo válido';
            }

            return null;
          },
        ),
      ],
    );
  }
}
