
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:task_management_application/models/task_model.dart';
import 'package:task_management_application/models/task_request_body.dart';
import 'package:task_management_application/services/task_service.dart';
import 'task_service_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late MockDio mockDio;
  late TaskService taskService;

  TaskRequestBody taskRequestBody = TaskRequestBody(
    offset: 1,
    limit: 2,
    sortBy: 'createdAt',
    isAsc: true,
    status: 'TODO',
  );

  setUpAll(() {
    mockDio = MockDio();
    taskService = TaskService(mockDio: mockDio);
  });

  group('Task service test', () {
    test("case success", () {
      //given
      var responseData = TaskModel(
        tasks: [
          Tasks(
            id: '1',
            title: 'Task 1',
            description: 'Task 1 Description',
            createdAt: '2022-01-01T10:00:00Z',
            status: 'TODO',
          ),
          Tasks(
            id: '2',
            title: 'Task 2',
            description: 'Task 2 Description',
            createdAt: '2022-01-02T14:00:00Z',
            status: 'TODO',
          ),
        ],
        pageNumber: 0,
        totalPages: 16,
      );

      Response response = Response(requestOptions: RequestOptions(), statusCode: 200, data: responseData.toJson());
      when(mockDio.get(
        'https://todo-list-api-mfchjooefq-as.a.run.app/todo-list',
        data: null,
        queryParameters: {
          'offset': 1,
          'limit': 2,
          'sortBy': 'createdAt',
          'isAsc': true,
          'status': 'TODO',
        },
        options: null,
        cancelToken: null,
        onReceiveProgress: null,
      )).thenAnswer((_) async => response);

      //when
      var expectedResult = taskService.getData(taskRequestBody);

      //then
      expectedResult.then((value) {
        expect(value.tasks?.first.title, 'Task 1');
        expect(value.tasks?.first.description, 'Task 1 Description');
        expect(value.tasks?.first.status, 'TODO');
      });
    });

    test("case error", () {
      //given
      when(mockDio.get(
        'https://todo-list-api-mfchjooefq-as.a.run.app/todo-list',
        data: null,
        queryParameters: {
          'offset': 1,
          'limit': 2,
          'sortBy': 'createdAt',
          'isAsc': true,
          'status': 'TODO',
        },
        options: null,
        cancelToken: null,
        onReceiveProgress: null,
      )).thenThrow(Exception('Failed to load Task from API'));

      expect(() async {
        await taskService.getData(taskRequestBody);
      }, throwsException);
    });
  });
}
