import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../core/localization/app_localizations.dart';
import '../../core/theme/input_theme.dart';
import '../../provider/auth_provider.dart';
import '../../provider/story_provider.dart';
import '../../provider/upload_provider.dart';
import '../widgets/snackbar_helper.dart';

class StoryFormPage extends StatefulWidget {
  const StoryFormPage({super.key});

  @override
  State<StoryFormPage> createState() => _StoryFormPageState();
}

class _StoryFormPageState extends State<StoryFormPage> {
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final uploadProvider = Provider.of<UploadProvider>(context);
    final storyProvider = Provider.of<StoryProvider>(context, listen: false);
    final lang = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(lang!.translate('add_story')),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            uploadProvider.reset();
            context.go('/');
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  if (uploadProvider.imageFile != null)
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: FileImage(uploadProvider.imageFile!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  else
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.image, size: 50),
                    ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed:
                            () => uploadProvider.pickImage(
                              source: ImageSource.camera,
                              context: context,
                            ),
                        icon: const Icon(Icons.camera_alt),
                        label: Text(lang.translate('camera')),
                      ),
                      ElevatedButton.icon(
                        onPressed:
                            () => uploadProvider.pickImage(
                              source: ImageSource.gallery,
                              context: context,
                            ),
                        icon: const Icon(Icons.photo_library),
                        label: Text(lang.translate('gallery')),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _descriptionController,

                    decoration: AppInputTheme.buildDecoration(
                      context: context,
                      label: lang.translate('description'),
                      prefixIcon: Icons.note,
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return lang.translate('required_description');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed:
                          uploadProvider.isLoading
                              ? null
                              : () async {
                                if (_formKey.currentState!.validate() &&
                                    uploadProvider.imageFile != null) {
                                  final authProvider =
                                      Provider.of<AuthProvider>(
                                        context,
                                        listen: false,
                                      );
                                  final token = await authProvider.getToken();

                                  if (token != null) {
                                    final success = await uploadProvider
                                        .uploadStory(
                                          token: token,
                                          description:
                                              _descriptionController.text,
                                          context: context,
                                        );

                                    if (success && mounted) {
                                      context.go('/');
                                      uploadProvider.reset();
                                      await storyProvider.fetchStories(
                                        token: token,
                                      );
                                    }
                                  }
                                } else {
                                  SnackbarHelper.showError(
                                    context,
                                    lang.translate('required_image'),
                                  );
                                }
                              },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                        elevation: 3,
                        shadowColor: Colors.green.withOpacity(0.5),
                      ),
                      child:
                          uploadProvider.isLoading
                              ? const CircularProgressIndicator()
                              : Text(lang.translate('upload')),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}
