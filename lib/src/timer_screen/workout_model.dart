import 'package:hive/hive.dart';

import '../constants/enums.dart';

part 'workout_model.g.dart';

@HiveType(typeId: 0)
class ExerciseInterval extends HiveObject {
  @HiveField(0)
  WorkoutTypes type;

  @HiveField(1)
  int duration;

  @HiveField(2)
  int repeatCount;

  ExerciseInterval({
    required this.type,
    required this.duration,
    required this.repeatCount,
  });
}

@HiveType(typeId: 1)
class WorkoutPlan extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int totalDuration;

  @HiveField(3)
  List<ExerciseInterval> intervals;

  @HiveField(4)
  int repeatCount;

  WorkoutPlan({
    required this.id,
    required this.name,
    required this.totalDuration,
    required this.intervals,
    required this.repeatCount,
  });
}
