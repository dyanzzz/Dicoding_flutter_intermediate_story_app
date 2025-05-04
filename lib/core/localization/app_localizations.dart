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
            'required_valid_location': 'Location cannot be empty',
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
            'latlon': 'Latitude & Longitude',
            'camera': 'Camera',
            'gallery': 'Gallery',
            'story_detail': 'Detail Story',
            'upload': 'Post',
            'look_map': 'Look at the map',
            'story_location': 'Story Location',
            'my_position': 'My Position',
            'goto_my_position': 'Go to my location',
            'goto_story_location': 'Go to story location',
            'refresh': 'Refresh',
            'pick_your_location': 'Pick your location',
            'set_location': 'Set Location',
            'location_service_not_available': 'Location service not available',
            'permission_denied': 'Permission denied',
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
            'required_valid_location': 'Lokasi tidak boleh kosong',
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
            'latlon': 'Latitude & Longitude',
            'camera': 'Kamera',
            'gallery': 'Media',
            'story_detail': 'Detail Cerita',
            'upload': 'Posting',
            'look_map': 'Lihat peta',
            'story_location': 'Lokasi Story',
            'my_position': 'Posisi Saya',
            'goto_my_position': 'Ke lokasi saya',
            'goto_story_location': 'Ke lokasi pembuat cerita',
            'refresh': 'Segarkan',
            'pick_your_location': 'Pilih lokasi anda',
            'set_location': 'Pilih Lokasi',
            'location_service_not_available': 'Service lokasi tidak tersedia',
            'permission_denied': 'Izin ditolak',
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
