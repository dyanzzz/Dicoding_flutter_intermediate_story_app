import 'package:flutter/material.dart';

import '../../data/model/story_model.dart';
import '../../data/repositories/story_repository.dart';
import '../screens/widgets/snackbar_helper.dart';

class StoryProvider with ChangeNotifier {
  final StoryRepository _storyRepository = StoryRepository();
  List<StoryModel> _stories = [];
  StoryModel? _selectedStory;
  bool _isLoading = false;
  String _errorMessage = '';

  List<StoryModel> get stories => _stories;
  StoryModel? get selectedStory => _selectedStory;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchStories({
    required String token,
    required BuildContext context,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      _stories = await _storyRepository.getStories(token);
      _errorMessage = '';
    } catch (e) {
      SnackbarHelper.showError(context, e.toString());
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchStoryDetail({
    required String id,
    required String token,
    required BuildContext context,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      _selectedStory = await _storyRepository.getStoryDetail(id, token);
      _errorMessage = '';
    } catch (e) {
      SnackbarHelper.showError(context, e.toString());
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
