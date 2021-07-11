import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:teamsclone/src/pages/register.dart';
import './index.dart';

class Signin extends StatefulWidget {
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _formKey = GlobalKey<FormState>();

  String email;
  String password;
  String ud;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //toolbarHeight: 29,
        backgroundColor: Colors.black,
        actions: [
          Container(
            padding: EdgeInsets.all(10.0),
            child: RaisedButton(
              color: Colors.grey,
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                        builder: (context) => Register()));
              },
              child: Text('Register',
                style: TextStyle(
                  color: Colors.white,
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
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
             // SizedBox(height: 40,),
              Container(
                padding: EdgeInsets.all(5),
                child: Text('Already have an account',
                  style: TextStyle(
                    fontSize: 23,
                  ),),
              ),
              Text('Signin here',
                style: TextStyle(
                  fontSize: 18,
                ),),
              TextFormField(
                validator: (val) => val.isEmpty ? 'Enter an email' : null,
                onChanged: (val) {
                  setState(() {
                    email = val;
                  });
                },
              ),
              SizedBox(height: 20,),
              TextFormField(
                obscureText: true,
                validator: (val) => val.length < 6 ? 'Enter an pswd of 6+chars' : null,
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },
              ),
              SizedBox(height: 20,),
              RaisedButton(
                onPressed: () async {
                  if(_formKey.currentState.validate()) {
                    print('ok');
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email, password: password).then((result) async{
                      print(result.user.email);
                      setState(() {
                        ud=result.user.uid;
                      });
                      Firestore.instance.collection("users").doc(email).get().then((value) => {
                         Navigator.push(context, MaterialPageRoute(
                        builder: (context) => IndexPage(name: value["name"], email: email,)))
                      });
                     
                    });
                  }
                },
                child: Text('Signin'),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
