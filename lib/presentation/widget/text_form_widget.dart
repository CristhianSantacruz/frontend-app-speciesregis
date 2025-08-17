import 'package:flutter/material.dart';
class SecondTextFormField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validatorForm;
  final TextInputType? keyboardType;
  final FocusNode? focusNodeForm;
  final int? maxLines;
  final bool isPassword;
  final void Function()? onTap;
  final TextCapitalization? textCapitalization;
  final void Function(String)? onFieldSubmittedForm;

  const SecondTextFormField({
    super.key,
    required this.hintText,
    required this.controller,
    this.validatorForm,
    this.onTap,
    this.keyboardType,
    this.focusNodeForm,
    this.isPassword = false,
    this.onFieldSubmittedForm,
    this.maxLines,
    this.textCapitalization 
  });

  @override
  State<SecondTextFormField> createState() => _SecondTextFormFieldState();
}

class _SecondTextFormFieldState extends State<SecondTextFormField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  void _togglePasswordView() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: widget.onTap ,
      textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
      maxLines: widget.isPassword ? 1 : (widget.maxLines ?? 1),
      focusNode: widget.focusNodeForm ?? FocusNode(),
      controller: widget.controller,
      onFieldSubmitted: widget.onFieldSubmittedForm ??
          (value) {
            FocusScope.of(context).nextFocus();
          },
      validator: widget.validatorForm ?? (value) {
        return null;
      },
      keyboardType: widget.keyboardType ?? TextInputType.text,
      obscureText: widget.isPassword ? _obscureText : false,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: _togglePasswordView,
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(color: Colors.black),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(color: Colors.red),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}