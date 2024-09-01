import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
import 'src/timer_screen/workout_model.dart';

void main() async {
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(ActionTypesAdapter());
  Hive.registerAdapter(ExerciseStepsAdapter());
  Hive.registerAdapter(ExerciseAdapter());
  Hive.registerAdapter(WorkoutAdapter());
  Hive.registerAdapter(WorkoutHistoryAdapter());
  try {
    await Hive.openBox<Workout>('workouts');
  } catch (e) {
    print('Error opening workouts box: $e');
    // Handle the error (e.g., delete the corrupted box and recreate it)
    await Hive.deleteBoxFromDisk('workouts');
    await Hive.openBox<Workout>('workouts');
  }
  // await Hive.openBox<Exercise>('exercises');
  await Hive.openBox<WorkoutHistory>('workoutHistory');

  runApp(
    MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (context) => TimerController()),
        ChangeNotifierProvider(create: (context) => settingsController),
      ],
      child: const MyApp(),
    ),
  );
}
