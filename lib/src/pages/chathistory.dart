
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chatpage.dart';
class Chatpage extends StatefulWidget {
  final String email;
  final String name;
  const Chatpage({Key key, this.name, this.email}) : super(key: key);
  @override

  _ChatpageState createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  final List<String> chats = [];
  final _usernameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        actions: [
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width*0.7,
              child: TextField(
                controller: _usernameController,
              ),
            ),
          ),
          IconButton(
            color: Colors.black,
            icon: Icon(Icons.search), onPressed: ()
            {
              print(_usernameController.text);
              print(widget.email);
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => Indchatpage(fromuser: widget.email, touser: _usernameController.text,)));
            }
            )
      ],),
      body: Container(
        child: Column(children: [
          chathis(),
        ],),
      ),
    );
  }

  Widget chathis(){
    Firestore.instance.collection(widget.email).get().then((value) => {
      value.docs.forEach((element) {
        print(element.id);
        if(!chats.contains(element.id)){
          setState(() {
            chats.add(element.id);
          });
        }
      })
    }
    );
    return Expanded(
      child: chats.length==0 ? Text("") : 
      ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context,i){
          return Container(
            color: Colors.amber,
            child: ListTile(
              title: Text(chats[i]),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
              builder: (context) => Indchatpage(fromuser: widget.email, touser: chats[i],)));
              },),
          );
        },
        itemCount: chats.length,
        ),
    );
  }
}