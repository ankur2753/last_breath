import 'package:hive/hive.dart';

part 'workout_model.g.dart';

@HiveType(typeId: 0)
enum ActionTypes {
  @HiveField(0)
  Prepare,
  @HiveField(1)
  Exercise,
  @HiveField(2)
  Rest,
}

extension ParseToString on ActionTypes {
  String toShortString() {
    return this.toString().split('.').last;
  }
}

@HiveType(typeId: 1)
class ExerciseSteps {
  @HiveField(0)
  ActionTypes type;

  @HiveField(1)
  int duration; // in seconds

  ExerciseSteps({required this.type, required this.duration});
}

@HiveType(typeId: 2)
class Exercise {
  // @HiveField(0)
  // String name;

  @HiveField(1)
  List<ExerciseSteps> actions;

  @HiveField(2)
  int repeat;

  Exercise({
    // required this.name,
    required this.actions,
    required this.repeat,
  });

  int get totalDuration =>
      actions.fold(0, (sum, action) => sum + action.duration) * repeat;
}

@HiveType(typeId: 3)
class Workout {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  List<Exercise> exercises;

  @HiveField(3)
  bool isTemplate;

  @HiveField(4)
  DateTime? lastPerformed;

  @HiveField(5)
  int timesPerformed;

  Workout({
    required this.id,
    required this.name,
    required this.exercises,
    this.isTemplate = false,
    this.lastPerformed,
    this.timesPerformed = 0,
  });

  int get totalTime =>
      exercises.fold(0, (sum, exercise) => sum + exercise.totalDuration);
}

@HiveType(typeId: 4)
class WorkoutHistory {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String workoutId;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final int duration;

  WorkoutHistory({
    required this.id,
    required this.workoutId,
    required this.date,
    required this.duration,
  });
}
