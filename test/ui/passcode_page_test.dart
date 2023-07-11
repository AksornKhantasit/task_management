import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:mockito/mockito.dart';
import 'package:task_management_application/ui/passcode_page.dart';
import 'package:task_management_application/ui/task_management_page.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  final sessionStateStream = StreamController<SessionState>();
  final mockNavigatorObserver = MockNavigatorObserver();
  Timer? timer;
  Widget createPasscodePage() {
    return MaterialApp(
        home: Scaffold(
            body: PasscodePage(sessionStateStream: sessionStateStream)),
      navigatorObservers: [mockNavigatorObserver],
      routes: {
        '/taskManagementPage': (context) => Container(),
      },
    );
  }

  setUp(() {
    timer = Timer(Duration.zero, () {}); // ตั้งค่า Timer
  });

  tearDown(() {
    timer?.cancel(); // ยกเลิก Timer หากมีการเรียกใช้งาน
  });

  testWidgets('Given render passcode page'
      ' When user enter correct passcode'
      ' Then navigate to next page', (WidgetTester tester) async {
    await tester.pumpWidget(createPasscodePage());
    expect(find.byKey(const Key('ENTER_YOUR_PASSCODE_LABEL')), findsOneWidget);
    await tester.tap(find.byKey(const Key('NUMBER_BUTTON_0')));
    await tester.tap(find.byKey(const Key('NUMBER_BUTTON_1')));
    await tester.tap(find.byKey(const Key('NUMBER_BUTTON_2')));
    await tester.tap(find.byKey(const Key('NUMBER_BUTTON_3')));
    await tester.tap(find.byKey(const Key('NUMBER_BUTTON_4')));
    await tester.tap(find.byKey(const Key('NUMBER_BUTTON_5')));
    await tester.pumpAndSettle();
    verify(mockNavigatorObserver.didReplace(
        newRoute: anyNamed('newRoute'), oldRoute: anyNamed('oldRoute')));
    expect(find.byType(TaskManagementPage), findsOneWidget);
  });

  testWidgets('Given render passcode page'
      ' When user enter incorrect passcode'
      ' Then show toast message', (WidgetTester tester) async {
    await tester.pumpWidget(createPasscodePage());
    expect(find.byKey(const Key('ENTER_YOUR_PASSCODE_LABEL')), findsOneWidget);
    await tester.tap(find.byKey(const Key('NUMBER_BUTTON_0')));
    await tester.tap(find.byKey(const Key('NUMBER_BUTTON_0')));
    await tester.tap(find.byKey(const Key('NUMBER_BUTTON_0')));
    await tester.tap(find.byKey(const Key('NUMBER_BUTTON_0')));
    await tester.tap(find.byKey(const Key('NUMBER_BUTTON_0')));
    await tester.tap(find.byKey(const Key('NUMBER_BUTTON_0')));
    await tester.pump();
  });
}
