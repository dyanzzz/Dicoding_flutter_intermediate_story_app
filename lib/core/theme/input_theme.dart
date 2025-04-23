import 'package:flutter/material.dart';

class AppInputTheme {
  static InputDecoration buildDecoration({
    required BuildContext context,
    required String label,
    required IconData prefixIcon,
    Widget? suffixIcon,
    String? hintText,
    Color? fillColor,
    bool isFilled = true,
  }) {
    final theme = Theme.of(context);

    return InputDecoration(
      labelText: label,
      hintText: hintText,
      labelStyle: TextStyle(
        color: theme.colorScheme.onSurface.withOpacity(0.7),
      ),
      hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5)),
      prefixIcon: Icon(prefixIcon, color: theme.colorScheme.primary),
      suffixIcon: suffixIcon,
      filled: isFilled,
      fillColor: fillColor ?? theme.colorScheme.surface.withOpacity(0.9),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.colorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.5),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.colorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
      ),
    );
  }
}
