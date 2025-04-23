import 'dart:async';

import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const supportedLocales = [Locale('en', 'US'), Locale('id', 'ID')];

  late Map<String, String> _localizedStrings;

  Future<bool> load() async {
    final jsonMap =
        await {
          'en': {
            'welcome': 'Welcome',
            'login': 'Login',
            'register': 'Register',
            'email': 'Email',
            'password': 'Password',
            'name': 'Name',
            'stories': 'Stories',
            'add_story': 'Add Story',
            'description': 'Description',
            'logout': 'Logout',
            'create_new_account': 'Create New Account',
            'required_name': 'Name cannot be empty',
            'required_email': 'Email cannot be empty',
            'required_valid_email': 'Email is not valid',
            'required_password': 'Password cannot be empty',
            'required_valid_password': 'Password must be at least 8 characters',
            'already_account': 'Already account?',
            'login_here': 'Login here!',
            'dont_have_account': "Don't have an account yet?",
            'register_now': 'Register Now!',
            'required_image': 'Image is required',
            'required_description': 'Description is required',
            'back_to_home': 'Back to Home',
            'error': 'Error',
            'unknown_error': 'Unknown Error',
            'post_on': 'Posted on ',
            'location': 'Location ',
            'camera': 'Camera',
            'gallery': 'Gallery',
            'story_detail': 'Detail Story',
            'upload': 'Post',
          },
          'id': {
            'welcome': 'Selamat Datang',
            'login': 'Masuk',
            'register': 'Daftar',
            'email': 'Email',
            'password': 'Kata Sandi',
            'name': 'Nama',
            'stories': 'Cerita',
            'add_story': 'Tambah Cerita',
            'description': 'Deskripsi',
            'logout': 'Keluar',
            'create_new_account': 'Buat Akun Baru',
            'required_name': 'Nama tidak boleh kosong',
            'required_email': 'Email tidak boleh kosong',
            'required_valid_email': 'Email tidak valid',
            'required_password': 'Password tidak boleh kosong',
            'required_valid_password': 'Minimal Password harus 8 karakter',
            'already_account': 'Sudah punya akun?',
            'login_here': 'Masuk disini!',
            'dont_have_account': "Belum punya akun?",
            'register_now': 'Daftar sekarang!',
            'required_image': 'Ambil gambar dulu',
            'required_description': 'Deskripsi tidak boleh kosong',
            'back_to_home': 'Kembali ke Home',
            'error': 'Rusak',
            'unknown_error': 'Kerusakan tidak diketahui',
            'post_on': 'Di posting pada ',
            'location': 'Lokasi ',
            'camera': 'Kamera',
            'gallery': 'Media',
            'story_detail': 'Detail Cerita',
            'upload': 'Posting',
          },
        }[locale.languageCode];

    _localizedStrings = jsonMap!.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  String translate(String key) => _localizedStrings[key] ?? key;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'id'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
