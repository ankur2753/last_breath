import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'workoutstage.dart';

class WorkoutStageStorageService {
  static const String _workoutsKey = 'workouts';

  Future<void> storeWorkout(String workoutId, List<WorkoutStage> stages) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Store the workout stages
    final List<String> stagesJson = stages
        .map((stage) => jsonEncode({
              'id': stage.id,
              'name': stage.name,
              'duration': stage.duration.inSeconds,
            }))
        .toList();
    await prefs.setStringList(workoutId, stagesJson);

    // Update the list of workout IDs
    final List<String> workoutIds = prefs.getStringList(_workoutsKey) ?? [];
    if (!workoutIds.contains(workoutId)) {
      workoutIds.add(workoutId);
      await prefs.setStringList(_workoutsKey, workoutIds);
    }
  }

  Future<List<WorkoutStage>> retrieveWorkout(String workoutId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? stagesJson = prefs.getStringList(workoutId);
    if (stagesJson == null) return [];

    return stagesJson.map((stageJson) {
      final Map<String, dynamic> stageMap = jsonDecode(stageJson);
      return WorkoutStage(
        id: stageMap['id'],
        name: stageMap['name'],
        duration: Duration(seconds: stageMap['duration']),
      );
    }).toList();
  }

  Future<List<String>> retrieveAllWorkoutIds() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_workoutsKey) ?? [];
  }

  Future<void> clearWorkout(String workoutId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(workoutId);

    // Update the list of workout IDs
    final List<String> workoutIds = prefs.getStringList(_workoutsKey) ?? [];
    workoutIds.remove(workoutId);
    await prefs.setStringList(_workoutsKey, workoutIds);
  }

  Future<void> clearAllWorkouts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> workoutIds = prefs.getStringList(_workoutsKey) ?? [];
    for (String workoutId in workoutIds) {
      await prefs.remove(workoutId);
    }
    await prefs.remove(_workoutsKey);
  }
}
