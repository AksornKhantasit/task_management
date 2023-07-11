import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:task_management_application/bloc/task_bloc.dart';
import 'package:task_management_application/bloc/task_event.dart';
import 'package:task_management_application/bloc/task_state.dart';
import 'package:task_management_application/models/task_model.dart';
import 'package:task_management_application/ui/widgets/task_item_list_widget.dart';
import 'package:bloc_test/bloc_test.dart';

class MockTaskBloc extends MockBloc<TaskEvent, TaskState> implements TaskBloc {}

void main() {
  late StreamController<SessionState> sessionStateStream;
  late MockTaskBloc mockBloc;

  Widget createTaskItemListWidget() {
    return MaterialApp(
      home: Scaffold(
          body: TaskItemListWidget(
              taskStatus: 'TODO', sessionStateStream: sessionStateStream, taskBlocForTest: mockBloc,)),
    );
  }

  setUp(() {
    mockBloc = MockTaskBloc();
    sessionStateStream = StreamController<SessionState>();
  });

  tearDown(() {
    sessionStateStream.close();
  });

  testWidgets('TaskItemListWidget: Loading', (WidgetTester tester) async {
    TaskState taskState = const TaskState(tasksList: [], nextOffset: 0, hasMore: false);

    await tester.runAsync(() async {
      whenListen(
        mockBloc,
        Stream.fromIterable([
          TaskInitial(),
          TaskLoading(taskState),
        ]),
        initialState: TaskLoading(taskState),
      );
      await tester.pumpWidget(createTaskItemListWidget());
      expect(find.byKey(const Key('TASK_ITEM_LIST_LOADING')), findsOneWidget);
    });
  });

  testWidgets('TaskItemListWidget: Success', (WidgetTester tester) async {
    List<Tasks> tasksList = [
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
    ];
    await tester.runAsync(() async {
      whenListen(
        mockBloc,
        Stream.fromIterable([
          TaskInitial(),
          TaskSuccess(tasksList: tasksList, nextOffset: 1, hasMore: true),
        ]),
        initialState: TaskInitial(),
      );
      await tester.pumpWidget(createTaskItemListWidget());
      await tester.pump();
      expect(find.byKey(const Key('TASK_ITEM_LIST_SUCCESS')), findsOneWidget);
    });
  });

  testWidgets('TaskItemListWidget: Success', (WidgetTester tester) async {
    TaskState taskState = const TaskState(tasksList: [], nextOffset: 1, hasMore: false);
    await tester.runAsync(() async {
      whenListen(
        mockBloc,
        Stream.fromIterable([
          TaskInitial(),
          TaskError(taskState),
        ]),
        initialState: TaskInitial(),
      );
      await tester.pumpWidget(createTaskItemListWidget());
      await tester.pump();
      expect(find.byKey(const Key('TASK_ITEM_LIST_ERROR')), findsOneWidget);
    });
  });
}
