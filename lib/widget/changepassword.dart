import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learnandplay/AllScreens/registrationscreen.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController currentPasswordTextEditingController=new TextEditingController();
  TextEditingController newPasswordTextEditingController=new TextEditingController();
  TextEditingController confirmPasswordTextEditingController=new TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool checkCurrentPasswordValid = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar:AppBar(
          title: Text("Change Password"),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),

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
                        controller: currentPasswordTextEditingController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Current Password",
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
                        controller: newPasswordTextEditingController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "New Password",
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
                              "Update",
                              style:TextStyle(fontSize: 14.0, fontFamily: "Brand-Bold"),
                            ) ,
                          ),
                        ),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(24.0)
                        ),
                        onPressed: () async {
                          if (currentPasswordTextEditingController.text.length ==0)
                          {
                            displayToastMessage("Enter valid current password!", context);

                          }
                          else if (newPasswordTextEditingController.text.length ==0)
                          {
                            displayToastMessage("Enter valid new password!", context);

                          }
                          else if (newPasswordTextEditingController.text!=confirmPasswordTextEditingController.text)
                          {
                            displayToastMessage("Password not match!", context);
                          }
                          else{
                                  checkCurrentPasswordValid = await validatePassword(
                                  currentPasswordTextEditingController.text);

                                  setState(() {});

                                  if (!checkCurrentPasswordValid)
                                    {
                                      displayToastMessage("Incorrect password!", context);
                                    }
                                  else{
                                      updatePassword(newPasswordTextEditingController.text);
                                    }

                        }}
                      ),


                    ],
                  )
              ),

            ],
          ),
        ),
      ),
    );
  }

  Future<bool> validatePassword(String password) async {
    User? firebaseUser = await _auth.currentUser;
    var authCredentials = EmailAuthProvider.credential(
        email: firebaseUser!.email.toString(), password: password);
    try {
      var authResult = await firebaseUser
          .reauthenticateWithCredential(authCredentials);
      return authResult.user != null;
    } catch (e) {
      print(e);
      return false;
    }
  }
  Future<void> updatePassword(String password) async {
    User? firebaseUser = await _auth.currentUser;
    firebaseUser!.updatePassword(password);
  }
}
