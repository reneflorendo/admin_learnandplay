import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:learnandplay/AllScreens/loginscreen.dart';
import 'package:learnandplay/AllScreens/mainscreen.dart';
import 'package:learnandplay/main.dart';

class RegistrationScreen extends StatelessWidget {
  static const String idScreen = "registerScreen";
  TextEditingController nameTextEditingController= TextEditingController();
  TextEditingController emailTextEditingController= TextEditingController();
  TextEditingController confirmPasswordTextEditingController= TextEditingController();
  TextEditingController passwordTextEditingController= TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height:5.0,),
              Image(
                image: AssetImage ('images/header.png'),
                width: 390.0,
                height: 180.0,
                alignment: Alignment.center,
              ),
              Padding(
                  padding: EdgeInsets.all(15.0),
                  child:Column(
                    children: [

                      SizedBox(height:1.0,),
                      TextField(
                        controller: nameTextEditingController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Name",
                          labelStyle: TextStyle(
                              fontSize: 14.0
                          ),
                          hintStyle: TextStyle(
                              color:Colors.grey,
                              fontSize: 10.0
                          ),
                        ),
                        style: TextStyle(
                            fontSize: 14.0
                        ),
                      ),

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
                              fontSize: 10.0
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
                              fontSize: 10.0
                          ),
                        ),
                        style: TextStyle(
                            fontSize: 14.0
                        ),
                      ),
                      SizedBox(height:1.0,),
                      TextField(
                        controller: confirmPasswordTextEditingController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Confirm Password",
                          labelStyle: TextStyle(
                              fontSize: 14.0
                          ),
                          hintStyle: TextStyle(
                              color:Colors.grey,
                              fontSize: 10.0
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
                              "Register",
                              style:TextStyle(fontSize: 14.0, fontFamily: "Brand-Bold"),
                            ) ,
                          ),
                        ),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(24.0)
                        ),
                        onPressed: (){
                          if (nameTextEditingController.text.length < 3)
                          {
                            displayToastMessage("Name must be at least 3 characters", context);
                          }
                          else if (!emailTextEditingController.text.contains("@"))
                          {
                            displayToastMessage("Invalid EMail", context);
                          }
                          else if (passwordTextEditingController.text.length < 6)
                          {
                            displayToastMessage("Password is at least 6 characters", context);

                          }
                          else if (passwordTextEditingController.text!=confirmPasswordTextEditingController.text)
                          {
                            displayToastMessage("Password not match!", context);
                          }
                          else{
                            registerNewUser(context);
                          }

                        },
                      )


                    ],
                  )
              ),
              FlatButton(
                onPressed: (){
                  Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
                    ModalRoute.withName('/'),);

                },
                child: Text(
                  "Already have an Account? Login Here",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;

  void registerNewUser(BuildContext context) async
  {


    final User? firebaseUser=( await _firebaseAuth.createUserWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: passwordTextEditingController.text).catchError((errMsg){
      displayToastMessage("Error"+errMsg, context);
    })).user;

    if (firebaseUser!=null)
    {
      usersRef.child(firebaseUser.uid);
      Map userDataMap={
        "name":nameTextEditingController.text.trim(),
        "email":emailTextEditingController.text.trim(),
        "password":passwordTextEditingController.text.trim(),
        "year":"1st",
        "isActive":false,
        "photo":"user_icon.png"
      };

      usersRef.child(firebaseUser.uid).set(userDataMap);
      displayToastMessage("Congratulations! Your account has been registered!", context);
      Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
        ModalRoute.withName('/'),);
    }
    else
    {
      displayToastMessage("User has not created!", context);
    }
  }
}

displayToastMessage(String message, BuildContext context)
{
  Fluttertoast.showToast(msg: message);
}
