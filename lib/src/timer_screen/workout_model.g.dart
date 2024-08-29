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
    );
  }

  @override
  void write(BinaryWriter writer, Exercise obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.actions)
      ..writeByte(2)
      ..write(obj.repeat);
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
    );
  }

  @override
  void write(BinaryWriter writer, Workout obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.exercises);
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
