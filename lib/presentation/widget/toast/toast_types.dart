
import 'package:flutter/material.dart';

enum ToastType {
  neutral,
  neutralBlue,
  success,
  warning,
  error,
}

class ToastConfig {
  final Color backgroundColor;
  final Color iconColor;
  final IconData icon;
  final Color textColor;

  const ToastConfig({
    required this.backgroundColor,
    required this.iconColor,
    required this.icon,
    required this.textColor,
  });
}

const Map<ToastType, ToastConfig> toastConfigs = {
  ToastType.neutral: ToastConfig(
    backgroundColor: Color(0xFFE5E7EB),
    iconColor: Color(0xFF6B7280),
    icon: Icons.info_outline,
    textColor: Color(0xFF374151),
  ),
  ToastType.neutralBlue: ToastConfig(
    backgroundColor: Color(0xFFDBEAFE),
    iconColor: Color(0xFF3B82F6),
    icon: Icons.notifications_outlined,
    textColor: Color(0xFF1E40AF),
  ),
  ToastType.success: ToastConfig(
    backgroundColor: Colors.green,
    iconColor: Colors.white,
    icon: Icons.check_circle_outline,
    textColor: Colors.white
  ),
  ToastType.warning: ToastConfig(
    backgroundColor: Color(0xFFFEF3C7),
    iconColor: Color(0xFFF59E0B),
    icon: Icons.warning_amber_outlined,
    textColor: Color(0xFF92400E),
  ),
  ToastType.error: ToastConfig(
    backgroundColor: Color(0xFFFEE2E2),
    iconColor: Color(0xFFEF4444),
    icon: Icons.error_outline,
    textColor: Color(0xFF991B1B),
  ),
};