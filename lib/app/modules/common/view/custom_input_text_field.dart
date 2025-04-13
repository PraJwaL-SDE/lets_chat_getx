import 'package:flutter/material.dart';

class CustomInputTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const CustomInputTextField({super.key, required this.controller,this.hint = ""});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: hint,

        border: OutlineInputBorder(),

      ),
    );
  }
}
