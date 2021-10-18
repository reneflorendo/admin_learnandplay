import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learnandplay/AllScreens/loginscreen.dart';
import 'package:learnandplay/AllScreens/registrationscreen.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  TextEditingController emailTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: Colors.white,
        body:SingleChildScrollView(
        child: Padding(
        padding: EdgeInsets.all(8.0),
    child: Column(
    children: [
      SizedBox(height: 20,),
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
      SizedBox(height: 10.0),
      RaisedButton(
        color:Colors.blue,
        textColor: Colors.white,
        child: Container(
          height: 50.0,
          child: Center(
            child: Text(
              "Reset",
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
            displayToastMessage("Invalid Email", context);
          }

          else{
              FirebaseAuth.instance.sendPasswordResetEmail(email:emailTextEditingController.text).then((value) => {
                displayToastMessage("Email sent to " +emailTextEditingController.text, context),
                Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
                ModalRoute.withName('/'),)
              }).catchError((onError){
                displayToastMessage("Email not sent! "+ onError, context);
              });
          }

        },
      ),
    ])
        )
        )
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    emailTextEditingController.dispose();
    super.dispose();
  }
}

