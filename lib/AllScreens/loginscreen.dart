import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:learnandplay/AllScreens/registrationScreen.dart';
import 'package:learnandplay/AllScreens/resetpassword.dart';
import 'package:learnandplay/Models/Pages.dart';
import 'package:learnandplay/Models/Topics.dart';
import 'package:learnandplay/Models/Users.dart';
import 'package:learnandplay/config.dart';
import '../main.dart';
import 'mainscreen.dart';
import 'dart:io';

class LoginScreen extends StatelessWidget {
  static const String idScreen = "loginScreen";
  List<Topics> _topics=[];
  List<Pages> _pages=[];
  TextEditingController emailTextEditingController= TextEditingController();
  TextEditingController passwordTextEditingController= TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body:SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            children: [
              SizedBox(height:35.0,),
              Image(
                image: AssetImage ('images/header.png'),
                width: 390.0,
                height: 180.0,
                alignment: Alignment.center,
              ),
              Padding(
                  padding: EdgeInsets.all(20.0),
                  child:Column(
                    children: [

                      SizedBox(height:1.0,),
                      TextField(
                        controller: emailTextEditingController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(
                              fontSize: 14.0
                          ),
                          hintStyle: TextStyle(
                              color:Colors.grey,
                              fontSize: 14.0
                          ),
                        ),
                        style: TextStyle(
                            fontSize: 14.0
                        ),
                      ),

                      SizedBox(height:1.0,),
                      TextField(
                        controller: passwordTextEditingController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                              fontSize: 14.0
                          ),
                          hintStyle: TextStyle(
                              color:Colors.grey,
                              fontSize: 14.0
                          ),
                        ),
                        style: TextStyle(
                            fontSize: 14.0
                        ),
                      ),

                      SizedBox(height: 10.0),
                      RaisedButton(
                        color:Colors.blue,
                        textColor: Colors.white,
                        child: Container(
                          height: 50.0,
                          child: Center(
                            child: Text(
                              "Login",
                              style:TextStyle(fontSize: 14.0, fontFamily: "Brand-Bold"),
                            ) ,
                          ),
                        ),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(24.0)
                        ),
                        onPressed: (){

                          if (!emailTextEditingController.text.contains("@"))
                          {
                            displayToastMessage("Invalid EMail", context);
                          }
                          else if (passwordTextEditingController.text.length < 6)
                          {
                            displayToastMessage("Password is at least 6 characters", context);
                          }
                          else{
                            loginAndAuthenticateUser(context);
                          }

                        },
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(height: 20, width: 5,),
                          FlatButton(
                            color:Colors.blue,
                            textColor: Colors.white,
                            child: Text("Forgot Password?"),
                            onPressed: (){
                              Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(builder: (BuildContext context) => ResetPassword()),
                                ModalRoute.withName('/'),);
                            },
                          ),
                          SizedBox(height: 20, width: 5,),
                          FlatButton(
                            color:Colors.blue,
                            textColor: Colors.white,
                            child: Text("Sign Up"),
                            onPressed: (){
                              Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(builder: (BuildContext context) => RegistrationScreen()),
                                ModalRoute.withName('/'),);
                            },
                          ),
                        ],
                      )



                    ],
                  )
              ),

            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
  }
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;

  void loginAndAuthenticateUser(BuildContext context) async{

    try {
      final User firebaseUser = (await _firebaseAuth
          .signInWithEmailAndPassword(
          email: emailTextEditingController.text,
          password: passwordTextEditingController.text)

      //     .catchError((errMsg) {
      //   displayToastMessage("Error" + errMsg, context);
      // })
      ).user!;

      if (firebaseUser != null) {
        usersRef.child(firebaseUser.uid).once().then((DataSnapshot snap) {
          if (snap.value != null) {
            userCurrentInfo = Users.fromSnapshot(snap);
            Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(
                  builder: (BuildContext context) => MainScreen()),
              ModalRoute.withName('/'),);
            displayToastMessage("You are logged in!.", context);
          }
          else {
            _firebaseAuth.signOut();
            displayToastMessage("User not exists! Please register.", context);
          }
        });
      }
      else {
        _firebaseAuth.signOut();
        displayToastMessage("Cannot sign in!", context);
      }
    }
      // on SocketException catch(errMsg){
      //   displayToastMessage("Internet connection not available!", context);
      // }
      catch(errMsg){
       displayToastMessage("Error" + errMsg.toString(), context);

      }

    }
}
