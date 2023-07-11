import 'package:task_management_application/models/task_request_body.dart';

abstract class TaskEvent {}

class GetTaskListEvent extends TaskEvent {
  final TaskRequestBody taskRequestBody;

  GetTaskListEvent({
    required this.taskRequestBody,
  });
}
