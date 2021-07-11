import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:teamsclone/src/pages/message.dart';
import 'chathistory.dart';
import './call.dart';

class IndexPage extends StatefulWidget {
  final String name;
  final String email;
  const IndexPage({Key key, this.name, this.email}) : super(key: key);
  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<IndexPage> {
  /// create a channelController to retrieve text value
  final _channelController = TextEditingController();
  // final _usernameController = TextEditingController();

  /// if channel textField is validated to have error
  bool _validateError = false;
  bool record=false;

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
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("welcome teamsclone"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(
              builder: (context) => Chatpage(name: widget.name ,email: widget.email,)));
              }
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
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
            Row(
              children: [
                Container(child: Radio(
                  value: ClientRole.Broadcaster,
                  groupValue: _role,
                  onChanged: (ClientRole value){
                    setState(() {_role = value;});
                  },
                ),),
                Text("Broadcast",),
                Container(child: Radio(
                  value: ClientRole.Audience,
                  groupValue: _role,
                  onChanged: (ClientRole value){
                    setState(() {_role = value;});
                  },
                ),),
                Text("Auidence"),
                
              ],
            ),
            RaisedButton(
              color: Colors.white,
                  child: Text('Join meet'),
                  onPressed:(){
                    onJoin();
                  },
                ),
            RaisedButton(
              color: Colors.white,
              padding: EdgeInsets.all(5),
              child: Text('Join chat room'),
              onPressed:() async{
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Message(
                      userName: widget.name,
                      channelName: _channelController.text,
                      useremail: widget.email,
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
            userName: widget.name,
            role: _role,
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
