import 'dart:async';

import 'package:flutter/material.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:task_management_application/ui/passcode_page.dart';
import 'package:task_management_application/ui/task_management_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState!;

  final sessionStateStream = StreamController<SessionState>();

  @override
  Widget build(BuildContext context) {
    final sessionConfig = SessionConfig(
      invalidateSessionForAppLostFocus: const Duration(seconds: 10),
      invalidateSessionForUserInactivity: const Duration(seconds: 10),
    );
    sessionConfig.stream.listen((SessionTimeoutState timeoutEvent) {
      sessionStateStream.add(SessionState.stopListening);
      if (timeoutEvent == SessionTimeoutState.userInactivityTimeout) {
        _navigator.pushReplacement(MaterialPageRoute(
          builder: (_) => PasscodePage(sessionStateStream: sessionStateStream),
        ));
      } else if (timeoutEvent == SessionTimeoutState.appFocusTimeout) {
        _navigator.pushReplacement(MaterialPageRoute(
          builder: (_) => PasscodePage(sessionStateStream: sessionStateStream),
        ));
      }
    });
    return SessionTimeoutManager(
      userActivityDebounceDuration: const Duration(seconds: 1),
      sessionConfig: sessionConfig,
      sessionStateStream: sessionStateStream.stream,
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        routes: {
          '/': (context) => PasscodePage(sessionStateStream: sessionStateStream),
          '/taskManagementPage': (context) => TaskManagementPage(sessionStateStream: sessionStateStream),
        },
      ),
    );
  }
}
