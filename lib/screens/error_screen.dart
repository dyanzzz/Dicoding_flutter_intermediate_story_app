import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/localization/app_localizations.dart';

class ErrorPage extends StatelessWidget {
  final Exception? error;

  const ErrorPage({this.error, super.key});

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(lang!.translate('error'))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(error?.toString() ?? lang.translate('unknown_error')),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: Text(lang.translate('back_to_home')),
            ),
          ],
        ),
      ),
    );
  }
}
