import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:learnandplay/AllScreens/registrationscreen.dart';
import 'package:learnandplay/Models/Users.dart';
import 'package:learnandplay/main.dart';
import 'package:learnandplay/widget/navigation.dart';

class StudentsForApproval extends StatefulWidget {
  static const String idScreen = "studentsForApprovalScreen";
  @override
  _StudentsForApprovalState createState() => _StudentsForApprovalState();
}

class _StudentsForApprovalState extends State<StudentsForApproval> {
  late List<Users> users= [];
  late Timer timer;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Navigation(),
      appBar: AppBar(
        title: Text("Students for Approval"),
      ) ,
      body:  users.length==0 ? Center(child: Text('No students for approval.')) : buildVerticalListView(),
    );
  }

  Widget buildVerticalListView() {
    return ListView.builder(

      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          tileColor: (index % 2 == 0) ? Colors.white : Colors.blue,
          title: Text(user.name.toUpperCase(),
              style: TextStyle(fontSize: 14.0, fontFamily: "Brand-Bold")),
          trailing: Container(
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FlatButton(
                    textColor: (index % 2 == 0) ? Colors.blue : Colors.white,
                    onPressed: () {
                      approveStudent(user.id.toString(), user.email);
                      getUsers();
                    },
                    child: Text("Approve", style: TextStyle(
                        fontSize: 14.0, fontFamily: "Brand-Bold"),),
                  ),

                ],
              )
          ),
        );
      },
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer = Timer.periodic(Duration(seconds: 25), (Timer t) => getUsers());
    getUsers();

  }

  void approveStudent(String studentId, String studentEmail) async
  {
    Map<String, dynamic> userDataMap={
      "isActive":true
    };

    await  usersRef.child(studentId).update(userDataMap).then((value) async => {
      FirebaseAuth.instance.sendPasswordResetEmail(email:studentEmail).then((value) => {
        displayToastMessage("Student access approved! Email sent to "+ studentEmail, context),
      })

    });
  }

  void getUsers() {
    users.clear();
    FirebaseDatabase database = new FirebaseDatabase();
    database.reference().child("users")
        .orderByChild("isActive")
        .equalTo(false)
        .once()
        .then((DataSnapshot snapshot){
      if (snapshot.value!=null){
        snapshot.value.forEach((key,values) {

          Users user = new Users(id: key
              , email: values["email"]
              , name: values["name"]
              , year: values["year"]
              , isActive: values["isActive"]
              , isArchive: values["isArchive"]
              , photo: values["photo"]);

          setState(() {
            users.add(user);
          });

        }
        );


      }
      else{
        setState(() {
          users=[];
        });
      }

    }
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    usersRef.reference();
    super.dispose();
  }
}
