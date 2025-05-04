import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/model/story_model.dart';
import '../../data/repositories/story_repository.dart';
import '../screens/widgets/overlay_snackbar_helper.dart';
import 'auth_provider.dart';

class StoryProvider with ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  final AuthProvider authProvider;
  Timer? _scrollDebounce;
  final StoryRepository _storyRepository = StoryRepository();
  final List<StoryModel> _stories = [];
  StoryModel? _selectedStory;
  bool _isLoading = false;
  bool _hasMore = true;
  String _errorMessage = '';
  int? pageItems = 1;
  int sizeItems = 10;

  List<StoryModel> get stories => _stories;
  StoryModel? get selectedStory => _selectedStory;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String get errorMessage => _errorMessage;

  StoryProvider(this.authProvider) {
    scrollController.addListener(_scrollListener);
    _fetchInitialStories();
  }

  Future<void> _fetchInitialStories() async {
    final token = await authProvider.getToken();
    if (token != null) {
      await fetchStories(token: token);
    }
  }

  Future<void> fetchStories({required String token}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newStories = await _storyRepository.getStories(
        token,
        pageItems!,
        sizeItems,
      );
      _errorMessage = '';
      pageItems = pageItems! + 1;

      _stories.addAll(newStories);
      pageItems = pageItems! + 1;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _hasMore = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  void _scrollListener() {
    if (_scrollDebounce?.isActive ?? false) return;

    _scrollDebounce = Timer(const Duration(milliseconds: 500), () {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent * 0.8) {
        _fetchInitialStories();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  Future<void> refreshStories() async {
    pageItems = 1;
    _stories.clear();
    _hasMore = true;
    _errorMessage = "";
    await _fetchInitialStories();
  }

  Future<void> clearErrorMessage() async {
    _errorMessage = "";
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
      OverlaySnackbar.error(context, e.toString());
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
