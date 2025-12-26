// lib/features/todo/presentation/manager/add_task_state.dart
part of 'add_task_cubit.dart';

abstract class AddTaskState {
  const AddTaskState();
}

class AddTaskInitial extends AddTaskState {
  const AddTaskInitial();
}

class AddTaskLoading extends AddTaskState {
  const AddTaskLoading();
}

class AddTaskSuccess extends AddTaskState {
  final TaskModel task;
  const AddTaskSuccess({required this.task});
}

class AddTaskLoaded extends AddTaskState {
  final List<TaskModel> tasks;
  const AddTaskLoaded({required this.tasks});
}

class AddTaskError extends AddTaskState {
  final String message;
  const AddTaskError({required this.message});
}
