import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:learnandplay/AllScreens/adminUserList.dart';
import 'package:learnandplay/AllScreens/loginscreen.dart';
import 'package:learnandplay/AllScreens/mainscreen.dart';
import 'package:learnandplay/Models/AdminUsers.dart';
import 'package:learnandplay/main.dart';

bool _isAdd=false;
String _adminUserId="";
class Registration extends StatefulWidget {
  static const String idScreen = "registrationScreen";

  Registration(bool isAdd, adminUserId){
    _isAdd=isAdd;
    _adminUserId=adminUserId;
  }

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  static const String idScreen = "registerScreen";
  TextEditingController nameTextEditingController= TextEditingController();
  TextEditingController emailTextEditingController= TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!_isAdd){
      getAdminUser();
    }
  }

  void getAdminUser()
  {
    AdminUsers adminUser;
    adminUsersRef.child(_adminUserId).once().then((DataSnapshot dataSnapshot) => {
      if (dataSnapshot.value!=null)
        {
           adminUser= AdminUsers.fromSnapshot(dataSnapshot),
           nameTextEditingController.text=adminUser.name,
           emailTextEditingController.text=adminUser.email,
        }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameTextEditingController.dispose();
    emailTextEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Admin User"),
          actions: <Widget>[
            FlatButton(
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Registration(true, "")));
              },
              child: Text("+",
                style: TextStyle(fontSize: 30.0, fontFamily: "Brand-Bold"),),
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
            ),
          ],

        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      children: [

                        SizedBox(height: 1.0,),
                        TextField(
                          controller: nameTextEditingController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: "Name",
                            labelStyle: TextStyle(
                                fontSize: 14.0
                            ),
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 10.0
                            ),
                          ),
                          style: TextStyle(
                              fontSize: 14.0
                          ),
                        ),

                        SizedBox(height: 1.0,),
                        TextField(
                          controller: emailTextEditingController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(
                                fontSize: 14.0
                            ),
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 10.0
                            ),
                          ),
                          style: TextStyle(
                              fontSize: 14.0
                          ),
                        ),
                        SizedBox(height: 10.0),
                        RaisedButton(
                          color: Colors.blue,
                          textColor: Colors.white,
                          child: Container(
                            height: 50.0,
                            child: Center(
                              child: Text(
                                _isAdd ? "Create" : "Update",
                                style: TextStyle(
                                    fontSize: 14.0, fontFamily: "Brand-Bold"),
                              ),
                            ),
                          ),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(24.0)
                          ),
                          onPressed: () {
                            if (nameTextEditingController.text.length < 3) {
                              displayToastMessage(
                                  "Name must be at least 3 characters!",
                                  context);
                            }
                            else if (!emailTextEditingController.text.contains(
                                "@")) {
                              displayToastMessage("Invalid Email!", context);
                            }
                            else {
                              registerNewUser(context);
                            }
                          },
                        )


                      ],
                    )
                ),
              ],
            ),
          )
          ,
        )
        ,

    );
  }
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;

  void editAdminUser(BuildContext context, String adminUserId)
  async{
    Map<String, dynamic> adminUserDataMap={
      "name":nameTextEditingController.text.trim(),
      "email":emailTextEditingController.text.trim(),

    };
    await adminUsersRef.child(adminUserId).update(adminUserDataMap).then((value) =>
    {
      displayToastMessage("Admin user has been updated!", context),
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => AdminUserList()), ModalRoute.withName('/'),)
    });

  }
  void registerNewUser(BuildContext context) async
  {
   String tempPassword="!Q@W#E%T^Y&U*I(O)Pzxc";

    final User? firebaseUser=( await _firebaseAuth.createUserWithEmailAndPassword(
        email: emailTextEditingController.text,
        password: tempPassword).catchError((errMsg){
      displayToastMessage("Error"+errMsg, context);
    })).user;

    if (firebaseUser!=null)
    {
     // adminUsersRef.child(firebaseUser.uid);
      Map userDataMap={
        "name":nameTextEditingController.text.trim(),
        "email":emailTextEditingController.text.trim(),
        "password":tempPassword,
        "isActive":false,
        "photo":"user_icon.png"
      };

      adminUsersRef.child(firebaseUser.uid).set(userDataMap).then((value) => {
        FirebaseAuth.instance.sendPasswordResetEmail(email:emailTextEditingController.text).then((value) => {
            displayToastMessage("Admin user has been created, and Email sent to " +emailTextEditingController.text, context),

            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => AdminUserList()), ModalRoute.withName('/'),)
        })

      });
    }
    else
    {
      displayToastMessage("Admin user has not created!", context);
    }
  }
}

displayToastMessage(String message, BuildContext context)
{
  Fluttertoast.showToast(msg: message);
}
