import 'package:dio/dio.dart';
import 'package:task_management_application/models/task_model.dart';
import 'package:task_management_application/models/task_request_body.dart';

class TaskService {
  final Dio? mockDio;

  TaskService({this.mockDio});
  late Dio dio = mockDio ?? Dio();

  static const String mainUrl = 'https://todo-list-api-mfchjooefq-as.a.run.app/todo-list';

  Future<TaskModel> getData(TaskRequestBody taskRequestBody) async {
    try {
      Response response = await dio.get(mainUrl, queryParameters: {
        'offset': taskRequestBody.offset,
        'limit': taskRequestBody.limit,
        'sortBy': taskRequestBody.sortBy,
        'isAsc': taskRequestBody.isAsc,
        'status': taskRequestBody.status
      });
      if (response.statusCode == 200) {
        return TaskModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load Task from API');
      }
    } catch (e) {
      rethrow;
    }
  }
}
