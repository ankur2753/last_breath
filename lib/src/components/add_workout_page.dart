import 'package:flutter/material.dart';
import 'package:last_breath/src/components/timer.dart';
import 'package:last_breath/src/settings/settings_controller.dart';
import 'package:last_breath/src/timer_screen/timer_controller.dart';
import 'package:last_breath/src/timer_screen/workout_model.dart';
import 'package:last_breath/src/timer_screen/workoutstage.dart';
import 'package:provider/provider.dart';

class AddWorkout extends StatefulWidget {
  const AddWorkout({super.key});

  @override
  State<AddWorkout> createState() => _AddWorkoutState();
}

class _AddWorkoutState extends State<AddWorkout> {
  late ScrollController _scrollController;
  late TimerController _timerController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _timerController = Provider.of<TimerController>(context, listen: false);
    _timerController.addListener(_handleTimerChanges);
  }

  @override
  void dispose() {
    _timerController.removeListener(_handleTimerChanges);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleTimerChanges() {
    if (_timerController.isWorkoutCompleted) {
      Navigator.of(context).pushReplacementNamed('/completed');
    } else {
      _scrollToCurrentWorkout();
    }
  }

  void _scrollToCurrentWorkout() {
    if (!_scrollController.hasClients || _scrollController.positions.isEmpty) {
      return;
    }

    final timerProvider = Provider.of<TimerController>(context, listen: false);
    final currentIndex = timerProvider.currentStageIndex;

    if (currentIndex >= 0) {
      _scrollController.animateTo(
        currentIndex * 80.0, // Assuming each item is roughly 80 pixels high
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimerController>(
      builder: (context, timerProvider, _) {
        return SafeArea(
          top: false,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Add New Workout'),
              centerTitle: true,
            ),
            body: _buildBody(context, timerProvider),
            floatingActionButton: _buildFloatingActionButton(timerProvider),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, TimerController timerProvider) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: timerProvider.workoutList.length,
            itemBuilder: (context, index) => WorkoutListItem(
              workout: timerProvider.workoutList[index],
              isSelected: timerProvider.currentStageIndex == index,
              onTap: () {
                timerProvider.currentStageIndex = index;
                _scrollToCurrentWorkout();
              },
            ),
          ),
        ),
        if (timerProvider.isWorkoutCompleted)
          TextButton(
            onPressed: () {
              timerProvider.resetWorkout();
            },
            child: const Text('Reset Workout'),
          ),
      ],
    );
  }

  FloatingActionButton _buildFloatingActionButton(
      TimerController timerProvider) {
    return FloatingActionButton(
      onPressed: timerProvider.toggleTimerState,
      child: Icon(
        timerProvider.isTimerRunning ? Icons.pause : Icons.play_arrow,
      ),
    );
  }

  void _toggleTheme(SettingsController settingsController) {
    final newThemeMode = settingsController.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    settingsController.updateThemeMode(newThemeMode);
  }
}

class WorkoutListItem extends StatelessWidget {
  final ExerciseInterval workout;
  final bool isSelected;
  final VoidCallback onTap;

  const WorkoutListItem({
    Key? key,
    required this.workout,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? theme.highlightColor : theme.cardColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  workout.type.toString(),
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                Text(
                  '${workout.duration} seconds',
                  style: textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
