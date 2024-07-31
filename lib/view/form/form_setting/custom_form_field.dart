import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomFormField extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;
  final int? maxLines; // Add this line
  final String? errorText;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const CustomFormField({
    Key? key,
    required this.hintText,
    required this.onChanged,
    this.errorText,
    this.inputFormatters,
    this.validator,
    this.maxLines = 1, // Add this line with a default value of 1
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextFormField(
        maxLines: maxLines, // Add this line
        decoration: InputDecoration(
          hintText: hintText,
          errorText: errorText,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.teal, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        onChanged: onChanged,
        inputFormatters: inputFormatters,
        validator: validator,
      ),
    );
  }
}