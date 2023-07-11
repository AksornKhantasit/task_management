import 'package:flutter_test/flutter_test.dart';
import 'package:task_management_application/models/task_model.dart';

void main() {
  test('Task Model fromJson Test', () async {
    //given
    var mockJson = {
      "tasks": [
        {
          "id": "cbb0732a-c9ab-4855-b66f-786cd41a3cd1",
          "title": "Read a book",
          "description": "Spend an hour reading a book for pleasure",
          "createdAt": "2023-03-24T19:30:00Z",
          "status": "TODO"
        }, {
          "id": "119a8c45-3f3d-41da-88bb-423c5367b81a",
          "title": "Exercise",
          "description": "Go for a run or do a workout at home",
          "createdAt": "2023-03-25T09:00:00Z",
          "status": "TODO" }
      ],
      "pageNumber": 0,
      "totalPages": 16
    };

    //when
    var expectResult = TaskModel.fromJson(mockJson);

    //then
    expect(expectResult.tasks?.first.title, "Read a book");
    expect(expectResult.tasks?.first.description, "Spend an hour reading a book for pleasure");
    expect(expectResult.tasks?.first.status, "TODO");
  });
}
