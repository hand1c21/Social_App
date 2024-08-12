import 'package:flutter/material.dart';

class UserDetailTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final FocusNode? focusNode;
  final FormFieldValidator<String>? validator;
  final TextField? maxLength;
  final TextDirection? textDirection; 
  final TextAlign textAlign; 

  const UserDetailTextField({
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.focusNode,
    this.validator,
    this.maxLength,
    this.textDirection,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      textDirection: textDirection,
      textAlign: textAlign,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        errorStyle: TextStyle(color: Colors.white),
        fillColor: Colors.transparent,
        filled: true,
        labelText: hintText,
        labelStyle: TextStyle(color: Colors.white),
      ),
      validator: validator,
      style: TextStyle(color: Colors.white),
    );
  }
}
