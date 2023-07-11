import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:task_management_application/bloc/task_bloc.dart';
import 'package:task_management_application/bloc/task_event.dart';
import 'package:task_management_application/bloc/task_state.dart';
import 'package:task_management_application/models/task_model.dart';
import 'package:task_management_application/models/task_request_body.dart';
import 'package:task_management_application/utils/date_helper.dart';

class TaskItemListWidget extends StatefulWidget {
  final String taskStatus;
  final StreamController<SessionState> sessionStateStream;

  @visibleForTesting
  final TaskBloc? taskBlocForTest;
  const TaskItemListWidget({Key? key, required this.taskStatus, required this.sessionStateStream, @visibleForTesting this.taskBlocForTest}) : super(key: key);

  @override
  State<TaskItemListWidget> createState() => _TaskItemListWidgetState();
}

class _TaskItemListWidgetState extends State<TaskItemListWidget> {
  late final TaskBloc _taskBloc;
  final ScrollController _scrollController = ScrollController();

  int pageOffset = 0;
  int pageLimit = 10;
  bool isScroll = true;

  @override
  void initState() {
    widget.sessionStateStream.add(SessionState.startListening);
    super.initState();
    _taskBloc = widget.taskBlocForTest ?? TaskBloc();
    getTaskListData();
    _scrollController.addListener((_scrollListener));

  }

  void getTaskListData() {
    TaskRequestBody taskRequestBody = TaskRequestBody(
      offset: pageOffset,
      limit: pageLimit,
      sortBy: 'createdAt',
      isAsc: true,
      status: widget.taskStatus,
    );
    _taskBloc.add(GetTaskListEvent(taskRequestBody: taskRequestBody));
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        _taskBloc.state.hasMore) {
      isScroll = true;
      getTaskListData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      bloc: _taskBloc,
      builder: (context, state) {
        if (state is TaskLoading) {
          return _buildLoadingView(context);
        } else if (state is TaskError) {
          return _buildErrorView(context);
        } else if (state is TaskSuccess) {
          return _buildSuccessView(context, state);
        }
        return const Offstage();
      },
    );
  }

  _buildLoadingView(BuildContext context) {
    return const Center(
        key: Key('TASK_ITEM_LIST_LOADING'),
        child: CircularProgressIndicator());
  }

  _buildErrorView(BuildContext context) {
    return Column(
      key: const Key('TASK_ITEM_LIST_ERROR'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.error_outline, size: 60),
        SizedBox(height: 16),
        Text('Unable to proceed. \n Please try again.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))
      ],
    );
  }

  _buildSuccessView(BuildContext context, TaskSuccess state) {
    pageOffset = state.nextOffset;
    List<Tasks>? items = state.tasksList;
    int listCount = items.length + (_taskBloc.state.hasMore ? 1 : 0);

    return ListView.builder(
        key: const Key('TASK_ITEM_LIST_SUCCESS'),
        controller: _scrollController,
        itemCount: listCount,
        itemBuilder: (BuildContext context, int index) {
          if (index == items.length) {
            return Visibility(
              visible: isScroll,
              child: const Center(child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              )),
            );
          }
          var formattedDate = formatDate(state.tasksList[index].createdAt ?? '');
          bool isSameDate = true;
          final String dateString = state.tasksList[index].createdAt ?? '';
          final DateTime date = DateTime.parse(dateString);
          final item = items[index];

          if (index == 0) {
            isSameDate = false;
          } else {
            final String prevDateString = state.tasksList[index - 1].createdAt ?? '';
            final DateTime prevDate = DateTime.parse(prevDateString);
            isSameDate = date.isSameDate(prevDate);
          }
          bool isShowDate = (index == 0 || !(isSameDate));
          return Dismissible(
            key: Key(item.id ?? ''),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              setState(() {
                items.removeAt(index);
                isScroll = false;
              });
            },
            background: Container(
              color: Colors.red,
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Align(alignment: Alignment.centerRight, child: Text('DELETE', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),)),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: isShowDate,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
                      child: Text(
                        formattedDate,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.star, size: 24, color: Colors.amber,),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title ?? '',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              item.description ?? '',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}

