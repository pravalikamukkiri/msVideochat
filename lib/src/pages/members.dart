import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';

class Memberspage extends StatefulWidget {
  final List<AgoraRtmMember> Members;

  const Memberspage({Key key,  this.Members, }) : super(key: key);
  @override

  _MemberspageState createState() => _MemberspageState();
}

class _MemberspageState extends State<Memberspage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.Members[0].channelId),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemBuilder: (context,i){
          return Container(
            padding: EdgeInsets.all(5),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  child: Icon(Icons.people),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent.shade100,
                    border: Border.all(width:5,
                    color: Colors.blue.shade200),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  padding: EdgeInsets.all(5),
                  child: Text(widget.Members[i].userId,style: TextStyle(fontSize: 20),)
                ),
              ],
            ),
          );
        },
        itemCount: widget.Members.length,
        ),
      ),

    );
  }
}