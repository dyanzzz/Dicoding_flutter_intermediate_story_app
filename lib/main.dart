import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'app_router.dart';
import 'core/localization/app_localizations.dart';
import 'provider/auth_provider.dart';
import 'provider/locale_provider.dart';
import 'provider/story_provider.dart';
import 'provider/upload_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, StoryProvider>(
          create:
              (context) => StoryProvider(
                Provider.of<AuthProvider>(context, listen: false),
              ),
          update: (context, authProvider, storyProvider) {
            //storyProvider?.updateAuth(authProvider);
            return storyProvider ?? StoryProvider(authProvider);
          },
        ),
        ChangeNotifierProvider(create: (_) => UploadProvider()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp.router(
            title: 'Story App',
            debugShowCheckedModeBanner: false,
            locale: localeProvider.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routerConfig: AppRouter.router,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
          );
        },
      ),
    );
  }
}
