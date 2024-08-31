import 'package:hive/hive.dart';
import 'workout_model.dart';

class WorkoutDatabase {
  static const String boxName = 'workouts';

  // Open the Hive box
  static Future<Box<Workout>> _openBox() async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<Workout>(boxName);
    }
    return Hive.box<Workout>(boxName);
  }

  // Create a new workout
  static Future<void> addWorkout(Workout workout) async {
    final box = await _openBox();
    await box.put(workout.id, workout);
  }

  // Read all workouts
  static Future<List<Workout>> getAllWorkouts() async {
    final box = await _openBox();
    return box.values.toList();
  }

  // Read a specific workout by ID
  static Future<Workout?> getWorkout(String id) async {
    final box = await _openBox();
    return box.get(id);
  }

  // Update a workout
  static Future<void> updateWorkout(Workout workout) async {
    final box = await _openBox();
    await box.put(workout.id, workout);
  }

  // Delete a workout
  static Future<void> deleteWorkout(String id) async {
    final box = await _openBox();
    print("delit + $id");
    await box.delete(id);
  }

  // Delete all workouts
  static Future<void> deleteAllWorkouts() async {
    final box = await _openBox();
    await box.clear();
  }

  // Get the total number of workouts
  static Future<int> getWorkoutCount() async {
    final box = await _openBox();
    return box.length;
  }

  // Search workouts by name
  static Future<List<Workout>> searchWorkouts(String query) async {
    final box = await _openBox();
    return box.values
        .where((workout) =>
            workout.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Get workouts sorted by total time
  static Future<List<Workout>> getWorkoutsSortedByTime() async {
    final workouts = await getAllWorkouts();
    workouts.sort((a, b) => a.totalTime.compareTo(b.totalTime));
    return workouts;
  }

  // Add an exercise to a workout
  static Future<void> addExerciseToWorkout(
      String workoutId, Exercise exercise) async {
    final box = await _openBox();
    final workout = await getWorkout(workoutId);
    if (workout != null) {
      workout.exercises.add(exercise);
      await updateWorkout(workout);
    }
  }

  // Remove an exercise from a workout
  static Future<void> removeExerciseFromWorkout(
      String workoutId, int exerciseIndex) async {
    final box = await _openBox();
    final workout = await getWorkout(workoutId);
    if (workout != null &&
        exerciseIndex >= 0 &&
        exerciseIndex < workout.exercises.length) {
      workout.exercises.removeAt(exerciseIndex);
      await updateWorkout(workout);
    }
  }

  // Update an exercise in a workout
  static Future<void> updateExerciseInWorkout(
      String workoutId, int exerciseIndex, Exercise updatedExercise) async {
    final box = await _openBox();
    final workout = await getWorkout(workoutId);
    if (workout != null &&
        exerciseIndex >= 0 &&
        exerciseIndex < workout.exercises.length) {
      workout.exercises[exerciseIndex] = updatedExercise;
      await updateWorkout(workout);
    }
  }

  // Add an exercise step to an exercise
  static Future<void> addStepToExercise(
      String workoutId, int exerciseIndex, ExerciseSteps step) async {
    final box = await _openBox();
    final workout = await getWorkout(workoutId);
    if (workout != null &&
        exerciseIndex >= 0 &&
        exerciseIndex < workout.exercises.length) {
      workout.exercises[exerciseIndex].actions.add(step);
      await updateWorkout(workout);
    }
  }

  // Remove an exercise step from an exercise
  static Future<void> removeStepFromExercise(
      String workoutId, int exerciseIndex, int stepIndex) async {
    final box = await _openBox();
    final workout = await getWorkout(workoutId);
    if (workout != null &&
        exerciseIndex >= 0 &&
        exerciseIndex < workout.exercises.length) {
      final exercise = workout.exercises[exerciseIndex];
      if (stepIndex >= 0 && stepIndex < exercise.actions.length) {
        exercise.actions.removeAt(stepIndex);
        await updateWorkout(workout);
      }
    }
  }

  // Update an exercise step
  static Future<void> updateExerciseStep(String workoutId, int exerciseIndex,
      int stepIndex, ExerciseSteps updatedStep) async {
    final box = await _openBox();
    final workout = await getWorkout(workoutId);
    if (workout != null &&
        exerciseIndex >= 0 &&
        exerciseIndex < workout.exercises.length) {
      final exercise = workout.exercises[exerciseIndex];
      if (stepIndex >= 0 && stepIndex < exercise.actions.length) {
        exercise.actions[stepIndex] = updatedStep;
        await updateWorkout(workout);
      }
    }
  }

  // Get all exercises from a specific workout
  static Future<List<Exercise>> getExercisesFromWorkout(
      String workoutId) async {
    final workout = await getWorkout(workoutId);
    return workout?.exercises ?? [];
  }

  // Get total duration of a workout
  static Future<int> getWorkoutDuration(String workoutId) async {
    final workout = await getWorkout(workoutId);
    return workout?.totalTime ?? 0;
  }

  // Update workout name
  static Future<void> updateWorkoutName(
      String workoutId, String newName) async {
    final box = await _openBox();
    final workout = await getWorkout(workoutId);
    if (workout != null) {
      workout.name = newName;
      await updateWorkout(workout);
    }
  }

  // Get workouts with a specific exercise
  static Future<List<Workout>> getWorkoutsWithExercise(
      String exerciseName) async {
    final workouts = await getAllWorkouts();
    return workouts
        .where((workout) => workout.exercises.any((exercise) =>
            exercise.name.toLowerCase() == exerciseName.toLowerCase()))
        .toList();
  }
}
