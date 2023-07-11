import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_application/bloc/task_event.dart';
import 'package:task_management_application/bloc/task_state.dart';
import 'package:task_management_application/models/task_model.dart';
import 'package:task_management_application/models/task_request_body.dart';
import 'package:task_management_application/services/task_service.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  late final TaskService _taskService;
  bool hasMore = false;

  TaskBloc({TaskService? taskService}) : super(TaskInitial()) {
    _taskService = taskService ?? TaskService();
    on<GetTaskListEvent>(_fetchGetTaskList);
  }

  void _fetchGetTaskList(
    GetTaskListEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      if (event.taskRequestBody.offset == 0) {
        emit(TaskLoading(state));
      }

      final apiResponse = await _taskService.getData(
          TaskRequestBody(
              offset: event.taskRequestBody.offset,
              limit: event.taskRequestBody.limit,
              sortBy: event.taskRequestBody.sortBy,
              isAsc: event.taskRequestBody.isAsc,
              status: event.taskRequestBody.status,
          ));

      if (apiResponse.tasks == null) {
        emit(TaskError(state, errorMessage: 'Response error'));
      } else {
        List<Tasks> tasksListData = apiResponse.tasks ?? [];
        List<Tasks> tasksList = [...state.tasksList];
        if ((apiResponse.tasks == null || apiResponse.tasks!.isEmpty) &&
            event.taskRequestBody.offset == 0) {
          hasMore = false;
        } else{
          if (event.taskRequestBody.offset == apiResponse.totalPages! - 1) {
            hasMore = false;
          } else {
            hasMore = true;
          }
        }
        tasksList.addAll(tasksListData);
        emit(TaskSuccess(tasksList: tasksList, nextOffset: event.taskRequestBody.offset + 1, hasMore: hasMore));
      }
    } catch (e) {
      emit(TaskError(
        state,
        errorMessage: e.toString(),
      ));
    }
  }
}
