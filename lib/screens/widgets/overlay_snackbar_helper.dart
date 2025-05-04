import 'package:flutter/material.dart';

class OverlaySnackbar {
  static void show(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    Color backgroundColor = Colors.black87,
    Color textColor = Colors.white,
    double elevation = 6.0,
    EdgeInsets margin = const EdgeInsets.all(10),
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(4)),
  }) {
    // Cari OverlayState
    final overlayState = Overlay.of(context);

    // Buat OverlayEntry untuk SnackBar
    final overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            bottom: 20,
            left: 10,
            right: 10,
            child: Material(
              color: Colors.transparent,
              child: Container(
                margin: margin,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: borderRadius,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: elevation,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: Text(
                    message,
                    style: TextStyle(color: textColor, fontSize: 14.0),
                  ),
                ),
              ),
            ),
          ),
    );

    // Tampilkan SnackBar
    overlayState.insert(overlayEntry);

    // Sembunyikan setelah duration
    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }

  // Shortcut methods untuk jenis SnackBar berbeda
  static void success(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    show(
      context,
      message: message,
      backgroundColor: Colors.green,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  static void error(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    show(
      context,
      message: message,
      backgroundColor: Colors.red,
      duration: duration ?? const Duration(seconds: 4),
    );
  }

  static void warning(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    show(
      context,
      message: message,
      backgroundColor: Colors.orange,
      textColor: Colors.black,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  static void info(BuildContext context, String message, {Duration? duration}) {
    show(
      context,
      message: message,
      backgroundColor: Colors.blue,
      duration: duration ?? const Duration(seconds: 2),
    );
  }
}
