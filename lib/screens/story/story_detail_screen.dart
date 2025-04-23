import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/localization/app_localizations.dart';
import '../../provider/auth_provider.dart';
import '../../provider/story_provider.dart';

class StoryDetailPage extends StatefulWidget {
  final String storyId;

  const StoryDetailPage({super.key, required this.storyId});

  @override
  State<StoryDetailPage> createState() => _StoryDetailPageState();
}

class _StoryDetailPageState extends State<StoryDetailPage> {
  @override
  void initState() {
    super.initState();
    _loadStoryDetail();
  }

  Future<void> _loadStoryDetail() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final storyProvider = Provider.of<StoryProvider>(context, listen: false);
    final token = await authProvider.getToken();

    if (token != null) {
      await storyProvider.fetchStoryDetail(
        id: widget.storyId,
        token: token,
        context: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final storyProvider = Provider.of<StoryProvider>(context);
    final story = storyProvider.selectedStory;
    final lang = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(lang!.translate('story_detail'))),
      body:
          storyProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : storyProvider.errorMessage.isNotEmpty
              ? Center(child: Text(storyProvider.errorMessage))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (story != null) ...[
                          CachedNetworkImage(
                            imageUrl: story.photoUrl,
                            width: double.infinity,
                            height: 300,
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                            errorWidget:
                                (context, url, error) =>
                                    const Icon(Icons.error),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            story.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            story.description,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '${lang.translate('post_on')}: ${story.createdAt.toLocal()}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          if (story.lat != null && story.lon != null) ...[
                            const SizedBox(height: 16),
                            Text(
                              '${lang.translate('location')}: ${story.lat}, ${story.lon}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
