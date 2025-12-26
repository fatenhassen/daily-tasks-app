import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:daily_tasks_app/features/data/models/task_model.dart';

part 'add_task_state.dart';

class AddTaskCubit extends Cubit<AddTaskState> {
  final List<TaskModel> _tasks = [];

  AddTaskCubit() : super(AddTaskInitial()) {
    // Initialize with empty task list
    emit(AddTaskLoaded(tasks: List.from(_tasks)));
  }

  List<TaskModel> get tasks => List.unmodifiable(_tasks);

  void addTask(TaskModel task) async {
    emit(AddTaskLoading());
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 200));

      // Add the new task to the list
      _tasks.insert(0, task);

      // Emit the new state with updated task list
      emit(AddTaskSuccess(task: task));
      emit(AddTaskLoaded(tasks: List.from(_tasks)));
    } catch (e) {
      emit(AddTaskError(message: e.toString()));
    }
  }

  void updateTask(TaskModel oldTask, TaskModel newTask) {
    final index = _tasks.indexWhere(
      (t) =>
          t.title == oldTask.title &&
          t.time == oldTask.time &&
          t.category == oldTask.category,
    );

    if (index != -1) {
      _tasks[index] = newTask;
      emit(AddTaskLoaded(tasks: List.from(_tasks)));
    }
  }

  void deleteTask(TaskModel task) {
    _tasks.removeWhere(
      (t) =>
          t.title == task.title &&
          t.time == task.time &&
          t.category == task.category,
    );
    emit(AddTaskLoaded(tasks: List.from(_tasks)));
  }

  void toggleTaskCompletion(TaskModel task) {
    final index = _tasks.indexWhere(
      (t) =>
          t.title == task.title &&
          t.time == task.time &&
          t.category == task.category,
    );

    if (index != -1) {
      _tasks[index] = task.copyWith(isCompleted: !task.isCompleted);
      emit(AddTaskLoaded(tasks: List.from(_tasks)));
    }
  }
}
