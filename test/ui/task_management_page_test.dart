import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:task_management_application/ui/task_management_page.dart';

void main() {
  late StreamController<SessionState> sessionStateStream;

  Widget createTaskManagementPage() {
    return MaterialApp(
      home: Scaffold(
          body: TaskManagementPage(sessionStateStream: sessionStateStream)),
    );
  }

  setUp(() {
    sessionStateStream = StreamController<SessionState>();
  });

  tearDown(() {
    sessionStateStream.close();
  });

  testWidgets('task management page test', (WidgetTester tester) async {
    await tester.pumpWidget(createTaskManagementPage());
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('TASK_MANAGEMENT_PAGE')), findsOneWidget);
    expect(find.text('Hi!'), findsOneWidget);
    expect(find.text('To-do'), findsOneWidget);
    await tester.tap(find.text('Doing'));
    expect(find.text('Doing'), findsOneWidget);
    await tester.tap(find.text('Done'));
    expect(find.text('Done'), findsOneWidget);
  });
}
