import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/localization/app_localizations.dart';
import '../../provider/locale_provider.dart';

class LanguagePicker extends StatelessWidget {
  const LanguagePicker({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      final localeProvider = Provider.of<LocaleProvider>(
        context,
        listen: false,
      );
      final lang = AppLocalizations.of(context);

      // Validasi supportedLocales tidak kosong
      if (AppLocalizations.supportedLocales.isEmpty) {
        throw Exception('Supported locales is empty');
      }

      // Pastikan localeProvider.locale ada di supportedLocales
      final currentLocale = localeProvider.locale;
      final isValidLocale = AppLocalizations.supportedLocales.contains(
        currentLocale,
      );

      return DropdownButton<Locale>(
        value:
            isValidLocale
                ? currentLocale
                : AppLocalizations.supportedLocales.first,
        icon: const Icon(Icons.language),
        items:
            AppLocalizations.supportedLocales.map((locale) {
              final flag = _getFlag(locale.languageCode);
              final languageName = _getLanguageName(locale.languageCode, lang);

              return DropdownMenuItem<Locale>(
                value: locale,
                child: Row(
                  children: [
                    Text(flag, style: const TextStyle(fontSize: 24)),
                    const SizedBox(width: 8),
                    Text(languageName),
                    const SizedBox(width: 8),
                  ],
                ),
              );
            }).toList(),
        onChanged: (Locale? newLocale) {
          if (newLocale != null) {
            localeProvider.setLocale(newLocale);
          }
        },
      );
    } catch (e) {
      // Fallback UI jika terjadi error
      debugPrint('LanguagePicker error: $e');
      return const Icon(Icons.error_outline, color: Colors.red);
    }
  }

  String _getFlag(String languageCode) {
    return languageCode == 'en' ? '🇺🇸' : '🇮🇩';
  }

  String _getLanguageName(String languageCode, AppLocalizations? lang) {
    switch (languageCode) {
      case 'en':
        return lang?.translate('en') ?? 'English';
      case 'id':
        return lang?.translate('id') ?? 'Bahasa Indonesia';
      default:
        return languageCode.toUpperCase();
    }
  }
}
