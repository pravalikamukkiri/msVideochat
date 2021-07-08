import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:teamsclone/src/pages/message.dart';

import './call.dart';

class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<IndexPage> {
  /// create a channelController to retrieve text value
  final _channelController = TextEditingController();
  final _usernameController = TextEditingController();

  /// if channel textField is validated to have error
  bool _validateError = false;

  ClientRole _role = ClientRole.Broadcaster;

  @override
  void dispose() {
    // dispose input controller
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("welcome teamsclone"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              height: 100,
             child:TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  errorText:_validateError ? 'Your name is mandatory' : null,
                  border: UnderlineInputBorder(),
                  hintText: 'Your name',
                ),
              )
            ),
            Container(
              padding: EdgeInsets.all(20),
              height: 100,
              child:TextField(
                controller: _channelController,
                decoration: InputDecoration(
                  errorText:_validateError ? 'Channel name is mandatory' : null,
                  border: UnderlineInputBorder(),
                  hintText: 'Channel name',
                ),
              )
              
            ),
            RaisedButton(
              child: Text('Join meeting'),
              onPressed:(){
                onJoin();
              },
            ),
            RaisedButton(
              child: Text('Join chat room'),
              onPressed:() async{
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Message(
                      userName: _usernameController.text,
                      channelName: _channelController.text,
                    )
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onJoin() async {
    // update input validation
    setState(() {
      _channelController.text.isEmpty
          ? _validateError = true
          : _validateError = false;
    });
    if (_channelController.text.isNotEmpty) {
      // await for camera and mic permissions before pushing video page
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);
      // push video page with given channel name
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
            channelName: _channelController.text,
            userName: _usernameController.text,
            role: ClientRole.Broadcaster,
          ),
        ),
      );
    }
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}
