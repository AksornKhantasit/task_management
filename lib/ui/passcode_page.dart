import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:task_management_application/ui/task_management_page.dart';

class PasscodePage extends StatefulWidget {
  final StreamController<SessionState> sessionStateStream;
  const PasscodePage({Key? key, required this.sessionStateStream,}) : super(key: key);

  @override
  State<PasscodePage> createState() => _PasscodePageState();
}

class _PasscodePageState extends State<PasscodePage> {
  String enteredPasscode = '';
  String passcode = '123456';

  void _updatePasscode(String digit) {
    setState(() {
      enteredPasscode += digit;
    });
    _verifyPasscode();
  }

  void _deleteDigit() {
    setState(() {
      if (enteredPasscode.isNotEmpty) {
        enteredPasscode =
            enteredPasscode.substring(0, enteredPasscode.length - 1);
      }
    });
  }

  void _verifyPasscode() {
    if (enteredPasscode == passcode) {
      widget.sessionStateStream.add(SessionState.startListening);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => TaskManagementPage(
            sessionStateStream: widget.sessionStateStream,
          ),
        ),
      );
    } else if (enteredPasscode.length == 6 && enteredPasscode != passcode) {
      showToast();
      enteredPasscode = '';
    }
  }

  void showToast() {
    Fluttertoast.showToast(
      msg: "Incorrect passcode. please try again.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.redAccent,
      fontSize: 18
    );
  }

  Widget _buildEnteredPasscode() {
    List<Widget> passcodeCircles = [];

    for (int i = 0; i < 6; i++) {
      bool hasDigit = i < enteredPasscode.length;
      passcodeCircles.add(_buildCircleInput(hasDigit));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: passcodeCircles,
    );
  }

  Widget _buildCircleInput(bool hasDigit) {
    return Container(
        width: 30.0,
        height: 30.0,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[300],
        ),
        child: hasDigit
            ? Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[500],
                ),
              )
            : const Offstage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 40.0),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                key: Key('ENTER_YOUR_PASSCODE_LABEL'),
                'Enter your passcode',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 20.0),
            _buildEnteredPasscode(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  children: List.generate(12, (index) {
                    final number = index == 10 ? 0 : index + 1;
                    return GestureDetector(
                      key: Key('NUMBER_BUTTON_$index'),
                      onTap: () {
                        widget.sessionStateStream.add(SessionState.stopListening);
                        if (index == 11){
                          _deleteDigit();
                        } else if (enteredPasscode.length < 6) {
                          _updatePasscode('$number');
                        }
                      },
                      child: index == 11
                          ? IconButton(onPressed: _deleteDigit, icon: const Icon(Icons.arrow_circle_left), iconSize: 50, color: Colors.grey[400])
                          : index != 9
                              ? Container(
                                  margin: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$number',
                                      style: const TextStyle(
                                          fontSize: 24.0, color: Colors.white),
                                    ),
                                  ),
                                )
                              : const Offstage(),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
