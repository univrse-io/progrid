import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final Icon? icon;
  final bool? enabled;

  const MyTextField({
    super.key,
    this.controller,
    this.hintText,
    this.obscureText = false,
    this.onChanged,
    this.icon,
    this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController effectiveController = controller ?? TextEditingController();

    return TextField(
      obscureText: obscureText,
      controller: effectiveController,
      onChanged: onChanged,
      enabled: enabled,
      decoration: InputDecoration(
        prefixIcon: icon,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.5,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(1),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.5,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        filled: false,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 14),
      ),
    );
  }
}
