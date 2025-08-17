
import 'package:flutter/material.dart';
import 'package:frontend_spaceregis/core/constant/constant.dart';

class PrimaryTextForm extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final bool? isPassword;
  final Widget? suffixIcon;
  final bool? obscureText;
  final int? maxLines;
  final FocusNode? focusNode;
  final bool? withoutLabel;
  final TextCapitalization? textCapitalization;
  final String? Function(String?)? validator;
  final void Function(String?)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final bool? enabled;
  final bool? withHelp;
  final String? stringHelp;
  const PrimaryTextForm({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.prefixIcon,
    this.keyboardType,
    this.withoutLabel = false,
    this.isPassword,
    this.suffixIcon,
    this.obscureText,
    this.maxLines,
    this.validator,
    this.focusNode,
    this.onFieldSubmitted,
    this.onChanged,
    this.textCapitalization,
    this.enabled,
    this.withHelp = false,
    this.stringHelp = '',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 4),
            if (withHelp == true)
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        label,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      content: Text(
                        stringHelp ?? "",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                },
                child: const Icon(Icons.help_outline, color: Colors.grey),
              ),
          ],
        ),
        if (withoutLabel == false) const SizedBox(height: 8),
        TextFormField(
          enabled: enabled,
          textCapitalization: textCapitalization ?? TextCapitalization.none,
          focusNode: focusNode,
          maxLines: maxLines ?? 1,
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText ?? false,
          onFieldSubmitted: onFieldSubmitted,
          onChanged: onChanged,
          validator:
              validator ??
              (value) {
                if (value == null || value.isEmpty) {
                  return 'Obligatorio';
                }
                return null;
              },
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: Colors.grey.shade500, size: 20)
                : null,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: greenColor, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}