import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:teamsclone/src/pages/signin.dart';
import 'index.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final _formKey = GlobalKey<FormState>();

  String email;
  String password;
  String name;
  String username;
  String ud;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        toolbarHeight: 29,
        backgroundColor: Colors.blueAccent,
        actions: [
          Container(
           // padding: EdgeInsets.all(10.0),
            child: RaisedButton(
              color: Colors.white,
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                        builder: (context) => Signin()) );
              },
              child: Text('Signin',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          )
        ],
        title: Text('welcome',
          style: TextStyle(
            color: Colors.white,
          ),),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                child: Text('New to Teams ',
                style: TextStyle(
                  fontSize: 23,
                ),),
              ),
              Text('Register here',
              style: TextStyle(
                fontSize: 15,
              ),),
              Container(
                height: 10,
                alignment: Alignment.bottomLeft,
                  child: Text('Email',
                  style: TextStyle(
                    fontSize: 9,
                  ),)),
              TextFormField(
                validator: (val) => val.isEmpty ? 'Enter an email' : null,
                onChanged: (val) {
                  setState(() {
                    email = val;
                  });
                },
              ),

              Container(
                height: 10,
                  alignment: Alignment.bottomLeft,
                  child: Text('Password',style: TextStyle(
                    fontSize: 9,
                  ),)),
              TextFormField(
                obscureText: true,
                validator: (val) => (val.length < 6) ? 'Enter a pswd of 6+ chars' : null,
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },
              ),
              //SizedBox(height: 20,),
              Container(
                height: 10,
                  alignment: Alignment.bottomLeft,
                  child: Text('Name',style: TextStyle(
                    fontSize: 9,
                  ),)),
              TextFormField(
                onChanged: (val) {
                  setState(() {
                    name=val;
                  });
                },
              ),
              //SizedBox(height: 20,),
              RaisedButton(
                color: Colors.white,
                onPressed: () async {
                  setState(() {
                    username=name;
                    print(username);
                  });
                  if(_formKey.currentState.validate()) {
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: email, password: password).then((result) async{
                      print(result.user.email);
                      setState(() {
                        ud=result.user.uid;
                      });
                      Firestore.instance.collection("users").doc(email.toString()).set({
                        "name" : name
                      });
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => IndexPage(name:name,email: email,)));
                    });
                  }
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
