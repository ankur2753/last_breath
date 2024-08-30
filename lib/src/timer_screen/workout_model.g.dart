// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExerciseStepsAdapter extends TypeAdapter<ExerciseSteps> {
  @override
  final int typeId = 1;

  @override
  ExerciseSteps read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExerciseSteps(
      type: fields[0] as ActionTypes,
      duration: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ExerciseSteps obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.duration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseStepsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExerciseAdapter extends TypeAdapter<Exercise> {
  @override
  final int typeId = 2;

  @override
  Exercise read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Exercise(
      name: fields[0] as String,
      actions: (fields[1] as List).cast<ExerciseSteps>(),
      repeat: fields[2] as int,
      description: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Exercise obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.actions)
      ..writeByte(2)
      ..write(obj.repeat)
      ..writeByte(3)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WorkoutAdapter extends TypeAdapter<Workout> {
  @override
  final int typeId = 3;

  @override
  Workout read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Workout(
      id: fields[0] as String,
      name: fields[1] as String,
      exercises: (fields[2] as List).cast<Exercise>(),
      isTemplate: fields[3] as bool,
      lastPerformed: fields[4] as DateTime?,
      timesPerformed: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Workout obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.exercises)
      ..writeByte(3)
      ..write(obj.isTemplate)
      ..writeByte(4)
      ..write(obj.lastPerformed)
      ..writeByte(5)
      ..write(obj.timesPerformed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WorkoutHistoryAdapter extends TypeAdapter<WorkoutHistory> {
  @override
  final int typeId = 4;

  @override
  WorkoutHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutHistory(
      id: fields[0] as String,
      workoutId: fields[1] as String,
      date: fields[2] as DateTime,
      duration: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutHistory obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.workoutId)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.duration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ActionTypesAdapter extends TypeAdapter<ActionTypes> {
  @override
  final int typeId = 0;

  @override
  ActionTypes read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ActionTypes.Prepare;
      case 1:
        return ActionTypes.Exercise;
      case 2:
        return ActionTypes.Rest;
      default:
        return ActionTypes.Prepare;
    }
  }

  @override
  void write(BinaryWriter writer, ActionTypes obj) {
    switch (obj) {
      case ActionTypes.Prepare:
        writer.writeByte(0);
        break;
      case ActionTypes.Exercise:
        writer.writeByte(1);
        break;
      case ActionTypes.Rest:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActionTypesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
