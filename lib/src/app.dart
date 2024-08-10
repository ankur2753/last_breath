import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:last_breath/src/components/workout_timer_page.dart';
import 'package:last_breath/src/constants/colors.dart';
import 'package:last_breath/src/home/homepage.dart';
import 'package:last_breath/src/settings/settings_controller.dart';
import 'package:last_breath/src/settings/settings_page.dart';
import 'package:last_breath/src/timer_screen/workoutCompleted.dart';
import 'package:provider/provider.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return Consumer<SettingsController>(
        builder: (context, settingsController, child) {
      return MaterialApp(
        // Providing a restorationScopeId allows the Navigator built by the
        // MaterialApp to restore the navigation stack when a user leaves and
        // returns to the app after it has been killed while running in the
        // background.
        restorationScopeId: 'last_breath_app',

        // Provide the generated AppLocalizations to the MaterialApp. This
        // allows descendant Widgets to display the correct translations
        // depending on the user's locale.
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English, no country code
        ],

        // Use AppLocalizations to configure the correct application title
        // depending on the user's locale.
        //
        // The appTitle is defined in .arb files found in the localization
        // directory.
        onGenerateTitle: (BuildContext context) =>
            AppLocalizations.of(context)!.appTitle,
        theme: ThemeData(useMaterial3: true),
        darkTheme: darkTheme,

        themeMode: settingsController.themeMode,
        initialRoute: '/home',
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/workout':
              return MaterialPageRoute(
                builder: (context) => const WorkoutTimerPage(),
              );
            case '/completed':
              return MaterialPageRoute(
                builder: (context) => const WorkoutCompletedPage(),
              );
            case '/settings':
              return MaterialPageRoute(
                builder: (context) => const SettingsPage(), // Fallback route
              );
            case '/home':
            default:
              return MaterialPageRoute(
                builder: (context) => const HomePage(), // Fallback route
              );
          }
        },
        // Define a function to handle named routes in order to support
        // Flutter web url navigation and deep linking.
      );
    });
  }
}
