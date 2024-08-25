import 'package:sqlite3/sqlite3.dart';
import 'package:last_breath/src/timer_screen/workoutstage.dart';

class WorkoutStageStorageService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = _initDatabase();
    return _database!;
  }
//TODO: USE THIS TO INIT DB
//   Future<Database> _initDatabase() async {
//   final db = sqlite3.open('workouts.db');
//   final schema = await File('schema.sql').readAsString();
//   db.execute(schema);
//   return db;
// }

  Database _initDatabase() {
    final db = sqlite3.open('workouts.db');
    db.execute(
      '''
      CREATE TABLE IF NOT EXISTS workouts(
        id TEXT PRIMARY KEY
      )
      ''',
    );
    db.execute(
      '''
      CREATE TABLE IF NOT EXISTS workout_stages(
        workout_id TEXT,
        stage_id TEXT,
        name TEXT,
        duration INTEGER,
        PRIMARY KEY (workout_id, stage_id),
        FOREIGN KEY (workout_id) REFERENCES workouts(id)
      )
      ''',
    );
    return db;
  }

  Future<void> saveWorkout(String workoutId, List<WorkoutStage> stages) async {
    final db = await database;
    db.execute(
      'INSERT OR REPLACE INTO workouts (id) VALUES (?)',
      [workoutId],
    );
    for (var stage in stages) {
      db.execute(
        'INSERT OR REPLACE INTO workout_stages (workout_id, stage_id, name, duration) VALUES (?, ?, ?, ?)',
        [workoutId, stage.type, stage.duration.inSeconds],
      );
    }
  }

  Future<List<WorkoutStage>> retrieveWorkout(String workoutId) async {
    final db = await database;
    final ResultSet result = db.select(
      'SELECT stage_id, name, duration FROM workout_stages WHERE workout_id = ?',
      [workoutId],
    );
    if (result.isEmpty) return [];
    return result.map((row) {
      return WorkoutStage(
        id: row['stage_id'] as String,
        name: row['name'] as String,
        duration: Duration(seconds: row['duration'] as int),
      );
    }).toList();
  }

  Future<List<String>> retrieveAllWorkoutIds() async {
    final db = await database;
    final ResultSet result = db.select('SELECT id FROM workouts');
    return result.map((row) => row['id'] as String).toList();
  }

  Future<void> clearWorkout(String workoutId) async {
    final db = await database;
    db.execute(
      'DELETE FROM workout_stages WHERE workout_id = ?',
      [workoutId],
    );
    db.execute(
      'DELETE FROM workouts WHERE id = ?',
      [workoutId],
    );
  }

  Future<void> clearAllWorkouts() async {
    final db = await database;
    db.execute('DELETE FROM workout_stages');
    db.execute('DELETE FROM workouts');
  }

  Future<void> storeWorkout(String workoutId, List<WorkoutStage> stages) async {
    final db = await database;

    // Store the workout ID in the workouts table
    db.execute(
      'INSERT OR REPLACE INTO workouts (id) VALUES (?)',
      [workoutId],
    );

    // Store the workout stages in the workout_stages table
    for (var stage in stages) {
      db.execute(
        'INSERT OR REPLACE INTO workout_stages (workout_id, stage_id, name, duration) VALUES (?, ?, ?, ?)',
        [workoutId, stage.id, stage.name, stage.duration.inSeconds],
      );
    }
  }
}
