import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:learnandplay/AllScreens/registrationscreen.dart';
import 'package:learnandplay/Models/Users.dart';
import 'package:learnandplay/main.dart';

class StudentList extends StatefulWidget {
  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {

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
      body:  buildVerticalListView(),
    );
  }

  Widget buildVerticalListView() => ListView.builder(

    itemCount: users.length,
    itemBuilder: (context, index) {
      final user = users[index];

      return ListTile(
        tileColor: (index%2==0)?Colors.white:Colors.blue,
        title: Text(user.name.toUpperCase(), style:TextStyle(fontSize: 12.0, fontFamily: "Brand-Bold")),
        trailing:Container(
            width:200 ,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FlatButton(
                  textColor: (index%2==0)?Colors.blue:Colors.white,
                  onPressed: () {
                      FirebaseAuth.instance.sendPasswordResetEmail(email:user.email).then((value) => {
                      displayToastMessage("Password reset! Email sent to "+ user.email, context),
                      });
                  },
                  child: Text("Reset Password",style:TextStyle(fontSize: 10.0, fontFamily: "Brand-Bold"),),
                ),
                SizedBox(width:2),
                FlatButton(
                  textColor: (index%2==0)?Colors.blue:Colors.white,
                  onPressed: () {

                    print("Delete");
                  },
                  child: Text("Archive",style:TextStyle(fontSize: 10.0, fontFamily: "Brand-Bold"),),
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

  void getUsers() async{
    await usersRef
        .orderByChild("isActive")
        .equalTo(true)
        .once()
        .then((DataSnapshot snapshot){
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
        );}
          );
    }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }



}
