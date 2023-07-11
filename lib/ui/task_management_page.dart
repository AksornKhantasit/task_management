import 'dart:async';

import 'package:flutter/material.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:task_management_application/ui/widgets/task_item_list_widget.dart';

class TaskManagementPage extends StatefulWidget {
  final StreamController<SessionState> sessionStateStream;
  const TaskManagementPage({Key? key, required this.sessionStateStream}) : super(key: key);

  @override
  State<TaskManagementPage> createState() => _TaskManagementPageState();
}

class _TaskManagementPageState extends State<TaskManagementPage> {

  @override
  void initState() {
    super.initState();
  }

  onPressed () {
    widget.sessionStateStream.add(SessionState.stopListening);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                key: const Key('TASK_MANAGEMENT_PAGE'),
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(50), // Creates border
                    color: Colors.black26),
                tabs: const [
                  Tab(child: Text('To-do', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),),
                  Tab(child: Text('Doing', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),),
                  Tab(child: Text('Done', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),),
                ],
                onTap: onPressed(),
              ),
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                    children: const [
                       Text('Hi!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
                       Spacer(),
                       CircleAvatar(child: Icon(Icons.person)),
                    ]),
              ),
            ),
            body: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                TaskItemListWidget(taskStatus: 'TODO', sessionStateStream: widget.sessionStateStream),
                TaskItemListWidget(taskStatus: 'DOING', sessionStateStream: widget.sessionStateStream),
                TaskItemListWidget(taskStatus: 'DONE', sessionStateStream: widget.sessionStateStream),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
