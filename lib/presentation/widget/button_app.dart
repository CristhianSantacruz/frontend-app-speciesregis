import 'package:flutter/material.dart';
import 'package:frontend_spaceregis/core/constant/constant.dart';

class ButtonApp extends StatelessWidget {
  final String text;
  final Color colorText;
  final Color backgroundColor;
  final VoidCallback? onPressed;
  const ButtonApp({
    super.key,
    required this.text,
    required this.colorText,
    required this.backgroundColor,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DEFFAULT_RADIUS),
          ),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical:15),
          child: Text(
            text,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: TextStyle(fontSize: 16,color: colorText ))
          ),
        ),
      
    );
  }
}