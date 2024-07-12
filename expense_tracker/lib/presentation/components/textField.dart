import 'package:expense_tracker/presentation/components/colors.dart';
import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String? hint;
  final IconData icon;
  final TextEditingController controller;
  final bool passwordInvisible;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  const InputField({
    super.key,
    required this.hint,
    required this.icon,
    required this.controller,
    this.passwordInvisible = false,
    this.validator,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical: 6),
      width: size.width * .9,
      height: 60,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: TextFormField(
          validator: validator,
          controller: controller,
          obscureText: passwordInvisible,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              icon: Icon(icon),
              suffixIcon: suffixIcon),
        ),
      ),
    );
  }
}
