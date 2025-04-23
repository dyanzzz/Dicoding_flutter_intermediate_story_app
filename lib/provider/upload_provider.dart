import 'dart:io';

import 'package:dicoding_story_flutter/core/extensions.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../../data/repositories/story_repository.dart';
import '../screens/widgets/snackbar_helper.dart';

class UploadProvider with ChangeNotifier {
  final StoryRepository _storyRepository = StoryRepository();
  File? _imageFile;
  bool _isLoading = false;
  String _errorMessage = '';

  File? get imageFile => _imageFile;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> pickImage({
    required ImageSource source,
    required BuildContext context,
  }) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source).toFile();
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        _imageFile = file;
        notifyListeners();
      }
    } catch (e) {
      SnackbarHelper.showError(
        context,
        'Failed to pick image: ${e.toString()}',
      );
      _errorMessage = 'Failed to pick image: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<bool> uploadStory({
    required String token,
    required String description,
    double? lat,
    double? lon,
    required BuildContext context,
  }) async {
    if (_imageFile == null) {
      _errorMessage = '';
      SnackbarHelper.showError(context, 'Please select an image first');
      notifyListeners();
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final bytes = await _imageFile!.readAsBytes();
      final success = await _storyRepository.uploadStory(
        token: token,
        description: description,
        photoBytes: bytes,
        fileName: basename(_imageFile!.path),
        lat: lat,
        lon: lon,
      );

      _isLoading = false;
      _errorMessage = '';
      notifyListeners();
      return success;
    } catch (e) {
      _isLoading = false;
      SnackbarHelper.showError(context, e.toString());
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void reset() {
    _imageFile = null;
    _isLoading = false;
    _errorMessage = '';
    notifyListeners();
  }
}
