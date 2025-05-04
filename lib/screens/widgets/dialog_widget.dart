import 'package:flutter/material.dart';

Future<dynamic> showBottomSheetDialog({
  required BuildContext context,
  required Widget child,
}) {
  return showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
    ),
    context: context,
    builder: (context) {
      return SafeArea(top: false, child: child);
    },
  );
}
