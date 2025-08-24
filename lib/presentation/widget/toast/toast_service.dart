
import 'package:flutter/material.dart';
import 'package:frontend_spaceregis/presentation/widget/toast/toast_widget.dart';
import 'toast_types.dart';

class ToastService {
  static void show({
    required BuildContext context,
    required ToastType type,
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    final config = toastConfigs[type]!;
    final overlay = Overlay.of(context);

    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (ctx) => ToastWidget(
        config: config,
        title: title,
        message: message,
        onDismiss: () => overlayEntry.remove(),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
  static void showWithoutMessage({
    required BuildContext context,
    required ToastType type,
    required String title,
    Duration duration = const Duration(seconds: 3),
  }) {
    final config = toastConfigs[type]!;
    final overlay = Overlay.of(context);

    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (ctx) => ToastWidget(
        config: config,
        title: title,
        onDismiss: () => overlayEntry.remove(),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}