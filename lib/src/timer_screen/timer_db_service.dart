import 'package:hive/hive.dart';

import 'workout_model.dart';

class WorkoutPlanService {
  late Box<WorkoutPlan> _workoutBox;

  Future<void> init() async {
    _workoutBox = await Hive.openBox<WorkoutPlan>('workoutPlans');
  }

  Future<void> createWorkoutPlan({
    required String id,
    required String name,
    required List<ExerciseInterval> intervals,
    int repeatCount = 1,
  }) async {
    int totalDuration = intervals.fold(0, (sum, item) => sum + item.duration);

    WorkoutPlan newPlan = WorkoutPlan(
      id: id,
      name: name,
      totalDuration: totalDuration,
      intervals: intervals,
      repeatCount: repeatCount,
    );

    await _workoutBox.put(id, newPlan);
  }

  Future<void> updateWorkoutPlan({
    required String id,
    String? name,
    List<ExerciseInterval>? intervals,
    int? repeatCount,
  }) async {
    WorkoutPlan? existingPlan = _workoutBox.get(id);

    if (existingPlan != null) {
      if (name != null) existingPlan.name = name;
      if (intervals != null) {
        existingPlan.intervals = intervals;
        existingPlan.totalDuration =
            intervals.fold(0, (sum, item) => sum + item.duration);
      }
      if (repeatCount != null) existingPlan.repeatCount = repeatCount;

      await existingPlan.save();
    } else {
      throw Exception("Workout plan not found");
    }
  }

  Future<WorkoutPlan?> getWorkoutPlan(String id) async {
    return _workoutBox.get(id);
  }

  Future<List<WorkoutPlan>> getAllWorkoutPlans() async {
    return _workoutBox.values.toList();
  }

  Future<void> deleteWorkoutPlan(String id) async {
    await _workoutBox.delete(id);
  }

  Future<void> clearAllWorkoutPlans() async {
    await _workoutBox.clear();
  }
}
