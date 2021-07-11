
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'message.dart';
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
        backgroundColor: Colors.blueAccent,
        actions: [
          
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: Container(
              width: MediaQuery.of(context).size.width*0.7,
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: "  Search",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                ),
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
        if(!chats.contains("i="+element.id)){
          if(element.id!="chanels"){
            setState(() {
              chats.add("i="+element.id);
            });
          }
          else{
            element.data().forEach((key, value) {
              if(!chats.contains("g="+key)){
                setState(() {
                  chats.add("g="+key);
                });
              }
            });
          }
        }
      })
    }
    );
    return Expanded(
      child: chats.length==0 ? Text("") : 
      ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context,i){
          return GestureDetector(
            onTap: (){
                if(chats[i][0]=='i'){
                  Navigator.push(context, MaterialPageRoute(
                  builder: (context) => Indchatpage(fromuser: widget.email, touser: chats[i].substring(2),)));
                }
                else{
                   Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Message(
                      userName: widget.name,
                      channelName: chats[i].substring(2),
                      useremail: widget.email,
                    )
                  ),
                );
                }
              },
            child: Container(
              padding: EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blueAccent.shade100,
                    maxRadius: 20,
                    child: Text(chats[i][2]),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children : [
                        Text(chats[i].substring(2),
                        style: TextStyle(fontSize: 16),)
                      ]
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: chats.length,
        ),
    );
  }
}