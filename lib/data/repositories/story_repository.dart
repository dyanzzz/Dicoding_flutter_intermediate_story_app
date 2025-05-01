import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/story_model.dart';

class StoryRepository {
  final String baseUrl = 'https://story-api.dicoding.dev/v1';

  Future<List<StoryModel>> getStories([
    String token = "",
    int page = 1,
    int size = 10,
  ]) async {
    final response = await http.get(
      Uri.parse('$baseUrl/stories?page=$page&size=$size&location=1'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['listStory'] as List)
          .map((story) => StoryModel.fromJson(story))
          .toList();
    } else {
      throw Exception('Failed to load stories');
    }
  }

  Future<StoryModel> getStoryDetail(String id, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/stories/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return StoryModel.fromJson(json.decode(response.body)['story']);
    } else {
      throw Exception('Failed to load story detail');
    }
  }

  Future<bool> uploadStory({
    required String token,
    required String description,
    required List<int> photoBytes,
    required String fileName,
    double? lat,
    double? lon,
  }) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/stories'));

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['description'] = description;

    if (lat != null && lon != null) {
      request.fields['lat'] = lat.toString();
      request.fields['lon'] = lon.toString();
    }

    request.files.add(
      http.MultipartFile.fromBytes('photo', photoBytes, filename: fileName),
    );

    final response = await request.send();
    final responseData = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception(
        'Failed to upload story: ${json.decode(responseData)['message']}',
      );
    }
  }
}
