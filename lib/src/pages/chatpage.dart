import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
class Indchatpage extends StatefulWidget {
  final String fromuser;
  final String touser;
  const Indchatpage({Key key, this.fromuser, this.touser}) : super(key: key);
  @override
  _IndchatpageState createState() => _IndchatpageState();
}

class _IndchatpageState extends State<Indchatpage> {
  final _msgcontroller = TextEditingController();
  final List<String> msgs = [];

  void initstate() async{
    msgs.clear();
    await Firestore.instance.collection(widget.fromuser).get().then((value) => {
      value.docs.forEach((element) {
        element.data().forEach((key, value) {
          setState(() {
            msgs.add(value);
          });
          // msgs.add(value);
        });
      })
    });
    print(msgs);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(widget.touser),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
          Row(children: [
            Container(
              width: MediaQuery.of(context).size.width*0.8,
              child: TextField(
                controller: _msgcontroller,
              ),
            ),
            IconButton( onPressed: () async{
                await Firestore.instance.collection(widget.fromuser).doc(widget.touser).set(
                  {widget.fromuser.toString()+"~"+DateTime.now().toString() : _msgcontroller.text,},
                  SetOptions(merge: true),
                );
                await Firestore.instance.collection(widget.touser).doc(widget.fromuser).set(
                  {widget.fromuser.toString()+"~"+DateTime.now().toString() : _msgcontroller.text,},
                  SetOptions(merge: true),
                );
                buildmsgchat();
                },
              icon: Icon(Icons.send),
              iconSize: 32.0,
            ),
          ],),
          buildmsgchat(),
        ],),
      ),
    );
  }
  Widget buildmsgchat(){
    // msgs.clear();
    Firestore.instance.collection(widget.fromuser).get().then((value) => {
      value.docs.forEach((element) {
        if(element.id == widget.touser){
          element.data().forEach((key, value) {
              if(!msgs.contains(key+"="+value)){
                setState(() {
                  msgs.add(key+"="+value);
                });
              }
          });
        }
      })
    });
    print(msgs);
    msgs.sort();
    return Expanded(
      child:msgs.length==0 ? Text(msgs.length.toString()) :
      ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context,i){
        return Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              msgs[i].substring(0,msgs[i].indexOf('~'))==widget.fromuser ? Spacer() : Text(""),
              Container(
                padding: EdgeInsets.all(8),
                color: Colors.white,
                child: Text(
                  msgs[i].substring(0,msgs[i].indexOf('~'))==widget.fromuser ? "you : "+msgs[i].substring(msgs[i].indexOf('=')+1) : 
                  msgs[i].substring(0,msgs[i].indexOf('@')) + ": " + msgs[i].substring(msgs[i].indexOf('=')+1)
                ),
              ),
            ],
          ),
        );
      },
      itemCount: msgs.length,
      ),
    );
  }
}