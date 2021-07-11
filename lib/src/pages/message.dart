import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../utils/settings.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'members.dart';


class Message extends StatefulWidget {
  final String userName;
  final String channelName;

  const Message({Key key,  this.userName, this.channelName,}) : super(key: key);
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  bool _isLogin = false;
  bool _isInChannel = false;


  final _channelMessageController = TextEditingController();


  final _infoStrings = <String>[];
  final  msgl = <Messagedata>[];

  AgoraRtmClient _client;
  AgoraRtmChannel _channel;

  @override
  void initState() {
    super.initState();
    _createClient();
    
  }

  
  @override
  Widget build(BuildContext context) {
    String name;
    return Scaffold(
          appBar: AppBar(
            title: Text(widget.channelName.toString()),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          body: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildLogin(),
                _buildSendChannelMessage(),
                _buildInfoList(),
              ],
            ),
          ),
    );
  }

  void _createClient() async {
    _client =
        await AgoraRtmClient.createInstance(APP_ID);   
  }

  Future<AgoraRtmChannel> _createChannel(String name) async {
    AgoraRtmChannel channel = await _client?.createChannel(name);
    if(channel != null) {
      channel.onMessageReceived =
          (AgoraRtmMessage message, AgoraRtmMember member) {
        _log(member.userId + " " + (message.text??""));
      };
      Firestore.instance.collection(widget.channelName.toString()).get().then((value) => {
        value.docs.forEach((element) {
          _log(element["name"] + ": " + element["msg"]);
          Messagedata x =  Messagedata( element["name"] ,element["msg"], element["time"] );
          if(!msgl.contains(x)){
            addmsg(x);
          }
          
        })
      });
    }
    return channel;
  }

  static TextStyle textStyle = TextStyle(fontSize: 18, color: Colors.blue);

  Widget _buildLogin() {
    return Row(children: <Widget>[
      new Text(widget.userName,style: textStyle),
     new OutlineButton(
        child: Text(_isLogin ? 'Leave' : 'Start', style: textStyle),
        onPressed: (){
          if(_isLogin){
            _toggleJoinChannel();
            _toggleLogin();
            Navigator.pop(context);
          }
          else{
            _toggleLogin();
            _toggleJoinChannel();
          }
        }
      ),
      Spacer(),
      new RaisedButton.icon(
        color: Colors.lightBlueAccent.shade100,
        label: Text("Participants"),
        padding: EdgeInsets.all(5),
        icon: Icon(Icons.people), onPressed: _toggleGetMembers)
    ]);
  }

  Widget _buildSendChannelMessage() {
    if (!_isLogin || !_isInChannel) {
      return Container();
    }
    return Row(children: <Widget>[
      new Expanded(
          child: new TextField(
              controller: _channelMessageController,
              decoration: InputDecoration(hintText: 'Input channel message'))),
      new OutlineButton(
        child: Text('Send to Channel', style: textStyle),
        onPressed: _toggleSendChannelMessage,
      )
    ]);
  }

  Widget _buildInfoList() {
    // msgl.sort((a,b) => a.time.compareTo(b.time));
    // msgl.forEach((element)=> {
    //   _log(element.name.toString() +":" +element.msg.toString())
    //   });
    
    return Expanded(
        child: Container(
            child: ListView.builder(
      itemBuilder: (context, i) {
        return Container(
           alignment : _infoStrings[i].substring(0,_infoStrings[i].indexOf(':')) == widget.userName ? 
           Alignment.centerRight : Alignment.centerLeft,
          padding: EdgeInsets.all(5),
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width:5,
              color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Text(
              _infoStrings[i].substring(0,_infoStrings[i].indexOf(':')) == widget.userName ?
               "You "+ _infoStrings[i].substring(_infoStrings[i].indexOf(':')) : _infoStrings[i],
            style: TextStyle(fontSize: 15),),
          ),
        );
      },
      itemCount: _infoStrings.length,
    )));
  }

  void _toggleLogin() async {
    if (_isLogin) {
      try {
        await _client?.logout();
        _log('Logout success.');

        setState(() {
          _isLogin = false;
        });
      } catch (errorCode) {
        _log('Logout error: ' + errorCode.toString());
      }
    } else {
      String userId = widget.userName;
      if (userId.isEmpty) {
        _log('Please input your user id to login.');
        return;
      }
      try {
        await _client?.login(null, userId);
        setState(() {
          _isLogin = true;
        });
      } catch (errorCode) {
        _log('Login error: ' + errorCode.toString());
      }
    }
  }
  void _toggleJoinChannel() async {
    if (_isInChannel) {
      try {
        await _channel?.leave();
        _log('Leave channel success.');
        if(_channel != null) {
          _client?.releaseChannel(_channel.channelId);
        }
        setState(() {
          _isInChannel = false;
        });
      } catch (errorCode) {
        _log('Leave channel error: ' + errorCode.toString());
      }
    } else {
      String channelId = widget.channelName;
      if (channelId.isEmpty) {
        _log('Please input channel id to join.');
        return;
      }

      try {
        _channel = await _createChannel(channelId);
        await _channel?.join();

        setState(() {
          _isInChannel = true;
        });
      } catch (errorCode) {
        _log('Join channel error: ' + errorCode.toString());
      }
    }
  }

  void _toggleGetMembers() async {
    try {
      List<AgoraRtmMember> members = await _channel?.getMembers();
      print(members.toString());
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Memberspage(
            Members: members,
          ),
        ),
      );

    } catch (errorCode) {
      _log('GetMembers failed: ' + errorCode.toString());
    }
  }

  void _toggleSendChannelMessage() async {
    String text = _channelMessageController.text;
    if (text.isEmpty) {
      _log('Please input text to send.');
      return;
    }
    try {
      await _channel?.sendMessage(AgoraRtmMessage.fromText(text));
      _log(widget.userName+ ': '+ text);
      FirebaseFirestore.instance.collection(widget.channelName.toString()).add({
        "name": widget.userName.toString(),
        "msg" : text, 
        "time" : DateTime.now().toString(),
        }).then((value) => print(value)).catchError((onError) => print(onError));
        _channelMessageController.clear();
    } catch (errorCode) {
      _log('error sending message: ' + errorCode.toString());
    }
    

  }

  void _log(String info) {
    print(info);
    setState(() {
      _infoStrings.add(info);
    });
  }
  void addmsg(Messagedata x){
    setState(() {
      msgl.add(x);
    });
  }
}

class Messagedata{
  String name;
  String msg;
  String time;
  Messagedata(this.name,this.msg,this.time);
}