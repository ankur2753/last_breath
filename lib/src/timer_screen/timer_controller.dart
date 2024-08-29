// import 'package:hive/hive.dart';
// import 'workout_model.dart';

// class WorkoutPlanService {
//   late Box<Workout> _workoutBox;

//   Future<void> init() async {
//     _workoutBox = await Hive.openBox<Workout>('workoutPlans');
//   }

//   // Create a new workout plan
//   Future<void> createWorkout({
//     required String id,
//     required String name,
//     required List<Exercise> exercises,
//   }) async {
//     Workout newWorkout = Workout(
//       id: id,
//       name: name,
//       exercises: exercises,
//     );

//     await _workoutBox.put(id, newWorkout);
//   }

//   // Update an existing workout plan
//   Future<void> updateWorkout({
//     required String id,
//     String? name,
//     List<Exercise>? exercises,
//   }) async {
//     Workout? existingWorkout = _workoutBox.get(id);

//     if (existingWorkout != null) {
//       if (name != null) existingWorkout.name = name;
//       if (exercises != null) existingWorkout.exercises = exercises;

//       await existingWorkout.save();
//     } else {
//       throw Exception("Workout not found");
//     }
//   }

//   // Retrieve a single workout plan by ID
//   Future<Workout?> getWorkout(String id) async {
//     return _workoutBox.get(id);
//   }

//   // Retrieve all workout plans
//   Future<List<Workout>> getAllWorkouts() async {
//     return _workoutBox.values.toList();
//   }

//   // Delete a workout plan by ID
//   Future<void> deleteWorkout(String id) async {
//     await _workoutBox.delete(id);
//   }

//   // Clear all workout plans
//   Future<void> clearAllWorkouts() async {
//     await _workoutBox.clear();
//   }

//   // Add or update an exercise in a workout
//   Future<void> addOrUpdateExercise({
//     required String workoutId,
//     required Exercise exercise,
//   }) async {
//     Workout? workout = await getWorkout(workoutId);
//     if (workout != null) {
//       workout.exercises.removeWhere((e) => e.name == exercise.name);
//       workout.exercises.add(exercise);
//       await workout.save();
//     } else {
//       throw Exception("Workout not found");
//     }
//   }

//   // Remove an exercise from a workout
//   Future<void> removeExercise({
//     required String workoutId,
//     required String exerciseName,
//   }) async {
//     Workout? workout = await getWorkout(workoutId);
//     if (workout != null) {
//       workout.exercises.removeWhere((e) => e.name == exerciseName);
//       await workout.save();
//     } else {
//       throw Exception("Workout not found");
//     }
//   }
// }

// //   /// Add an exercise to an existing workout plan.
// //   Future<void> addExerciseToWorkout(
// //       String workoutId, Exercise exercise) async {
// //     Workout? plan = await getWorkout(workoutId);
// //     if (plan != null) {
// //       plan.exercises.add(exercise);
// //       plan.totalDuration += exercise.totalDuration;
// //       await plan.save();
// //     } else {
// //       throw Exception("Workout plan not found");
// //     }
// //   }

// //   /// Remove an exercise from an existing workout plan.
// //   Future<void> removeExerciseFromWorkout(
// //       String workoutId, String exerciseName) async {
// //     Workout? plan = await getWorkout(workoutId);
// //     if (plan != null) {
// //       plan.exercises.removeWhere((exercise) => exercise.name == exerciseName);
// //       plan.totalDuration = plan.exercises
// //           .fold(0, (sum, exercise) => sum + exercise.totalDuration);
// //       await plan.save();
// //     } else {
// //       throw Exception("Workout plan not found");
// //     }
// //   }

// //   /// Add an exercise step to a specific exercise within a workout plan.
// //   Future<void> addExerciseStepToExercise(
// //     String workoutId,
// //     String exerciseName,
// //     ExerciseSteps step,
// //   ) async {
// //     Workout? plan = await getWorkout(workoutId);
// //     if (plan != null) {
// //       Exercise? exercise = plan.exercises.firstWhere(
// //           (exercise) => exercise.name == exerciseName,
// //           orElse: () => throw Exception("Exercise not found"));
// //       exercise.steps.add(step);
// //       exercise.totalDuration += step.duration;
// //       plan.totalDuration += step.duration;
// //       await plan.save();
// //     } else {
// //       throw Exception("Workout plan not found");
// //     }
// //   }

// //   /// Remove an exercise step from a specific exercise within a workout plan.
// //   Future<void> removeExerciseStepFromExercise(
// //     String workoutId,
// //     String exerciseName,
// //     ExerciseSteps step,
// //   ) async {
// //     Workout? plan = await getWorkout(workoutId);
// //     if (plan != null) {
// //       Exercise? exercise = plan.exercises.firstWhere(
// //           (exercise) => exercise.name == exerciseName,
// //           orElse: () => throw Exception("Exercise not found"));
// //       if (exercise.steps.remove(step)) {
// //         exercise.totalDuration -= step.duration;
// //         plan.totalDuration -= step.duration;
// //         await plan.save();
// //       }
// //     } else {
// //       throw Exception("Workout plan not found");
// //     }
// //   }
// // }
