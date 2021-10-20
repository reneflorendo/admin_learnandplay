import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:learnandplay/AllScreens/registrationscreen.dart';
import 'package:learnandplay/Models/Users.dart';
import 'package:learnandplay/main.dart';

class StudentsForApproval extends StatefulWidget {
  @override
  _StudentsForApprovalState createState() => _StudentsForApprovalState();
}

class _StudentsForApprovalState extends State<StudentsForApproval> {
  final items = List.generate(2000, (counter) => 'Item: $counter');
  final List<Users> users= [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Students"),
        // automaticallyImplyLeading: false,
        // actions: <Widget>[
        //   FlatButton(
        //     textColor: Colors.white,
        //     onPressed: () {},
        //     child: Text("+",style:TextStyle(fontSize: 30.0, fontFamily: "Brand-Bold"),),
        //     shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
        //   ),
        // ],

      ) ,
      body:  users.length==0 ? Center(child: Text('No students for approval.')) : buildVerticalListView(),
    );
  }

  Widget buildVerticalListView() => ListView.builder(

    itemCount:  users.length,
    itemBuilder: (context, index) {
      final user = users[index];
      return ListTile(
        tileColor: (index%2==0)?Colors.white:Colors.blue,
        title: Text(user.name.toUpperCase(), style:TextStyle(fontSize: 14.0, fontFamily: "Brand-Bold")),
        subtitle: Text("Year : "+user.year, style:TextStyle(fontSize: 12.0, fontFamily: "Brand-Bold")),
        trailing:Container(
            width:200 ,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FlatButton(
                  textColor: (index%2==0)?Colors.blue:Colors.white,
                  onPressed: () {
                      approveStudent(user.id.toString(), user.email);
                      getUsers();
                  },
                  child: Text("Approve",style:TextStyle(fontSize: 14.0, fontFamily: "Brand-Bold"),),
                ),

              ],
            )
        ),
      );
    },
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

  void getUsers() async{
    users.clear();
    await usersRef
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
            , photo: values["photo"]);

        setState(() {
          users.add(user);
        });

      }
      );
      }
        }
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }



}
