import 'package:flutter/material.dart';
import 'package:frontend_spaceregis/core/constant/constant.dart';
class ButtonWithIcon extends StatelessWidget {
  final String text;
  final IconData iconData;
  final bool? withoutIcon;
  final VoidCallback? onPressed;
  final Color? colorBackground;
  final double? fontSize;
  final Color? color;
  final AlignmentGeometry? alignment;
  const ButtonWithIcon({
    super.key,
    required this.text,
    required this.iconData,
    required this.onPressed,
     this.withoutIcon,
     this.fontSize,
     this.alignment,
     this.color,
    this.colorBackground,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
           alignment: alignment ?? Alignment.center,
          backgroundColor: colorBackground ?? Colors.white,
          
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey,width: 1),
            borderRadius: BorderRadius.circular(DEFFAULT_RADIUS),
          ),
        ),
        onPressed: onPressed,
        icon: withoutIcon == true ? null : Icon(
          iconData,
          color: color ?? Colors.black,
          size: 20,
        ),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical:15),
          child: Text(
            text,
            textAlign: TextAlign.center,
            maxLines: 1,
            style: TextStyle(color: color ?? Colors.black,fontSize: fontSize ?? 17,fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}