import 'package:task_management_application/models/task_model.dart';

class TaskState {
  final List<Tasks> tasksList;
  final int nextOffset;
  final bool hasMore;

  const TaskState({
    required this.tasksList,
    required this.nextOffset,
    required this.hasMore,
  });
}

class TaskInitial extends TaskState {
  TaskInitial()
      : super(
          tasksList: [],
          nextOffset: 0,
          hasMore: false,
        );
}

class TaskLoading extends TaskState {
  TaskLoading(TaskState state)
      : super(
          tasksList: state.tasksList,
          nextOffset: state.nextOffset,
          hasMore: state.hasMore,
        );
}

class TaskSuccess extends TaskState {
  TaskSuccess(
      {required super.tasksList,
      required super.nextOffset,
      required super.hasMore});
}

class TaskError extends TaskState {
  final String errorMessage;

  TaskError(TaskState state, {this.errorMessage = ""})
      : super(
          tasksList: state.tasksList,
          nextOffset: state.nextOffset,
          hasMore: state.hasMore,
        );
}
