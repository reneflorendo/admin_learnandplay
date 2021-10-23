import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:learnandplay/AllScreens/registrationscreen.dart';
import 'package:learnandplay/Models/AdminUsers.dart';
import 'package:learnandplay/main.dart';

class AdminUserList extends StatefulWidget {
  @override
  _AdminUserListState createState() => _AdminUserListState();
}

class _AdminUserListState extends State<AdminUserList> {
  @override
  final List<AdminUsers> adminUsers= [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Users"),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Registration(true,"")));
            },
            child: Text("+",style:TextStyle(fontSize: 30.0, fontFamily: "Brand-Bold"),),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],

      ) ,
      body:  buildVerticalListView(),
    );
  }

  Widget buildVerticalListView() => ListView.builder(

    itemCount: adminUsers.length,
    itemBuilder: (context, index) {
      final adminUser = adminUsers[index];
      return Container(
          height: 140,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0)), color: Colors.white, boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
          ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: <Widget>[
                    Text(
                      adminUser.name,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      adminUser.email,
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    Text(
                         "Status : "+ (adminUser.isActive?"Active":"Disabled"),
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                      children: <Widget>[
                        SizedBox(
                          height: 5,
                          width: 5,
                        ),
                        RaisedButton(

                          color:Colors.blue,
                          textColor: Colors.white,
                          child: Container(
                            height: 20.0,
                            width:45 ,
                            child: Center(
                              child: Text(
                                adminUser.isActive ? "Disabled":"Activate",
                                style:TextStyle(fontSize: 10.0, fontFamily: "Brand-Bold"),
                              ) ,
                            ),
                          ),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(15.0)
                          ),
                          onPressed: (){
                            var isActive=false;
                            if (!adminUser.isActive)
                              {
                                 isActive=true;
                              }
                            activateUser(adminUser.id.toString(),isActive);
                            //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Topic(false, topic.id)));
                          },
                        ),
                        SizedBox(
                          height: 5,
                          width: 5,
                        ),
                        RaisedButton(
                          color:Colors.blue,
                          textColor: Colors.white,
                          child: Container(
                            height: 20.0,
                            width:75 ,
                            child: Center(
                              child: Text(
                                "Reset Password",
                                style:TextStyle(fontSize: 10.0, fontFamily: "Brand-Bold"),
                              ) ,
                            ),
                          ),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(15.0)
                          ),
                          onPressed: (){
                            FirebaseAuth.instance.sendPasswordResetEmail(email:adminUser.email).then((value) => {
                              displayToastMessage("Password reset, and sent email to " +adminUser.email, context),
                            });
                          },
                        ),
                        SizedBox(
                          height: 5,
                          width: 5,
                        ),
                        RaisedButton(
                          color: Colors.blue,
                          textColor: Colors.white,
                          child: Container(
                            height: 20.0,
                            width:40 ,
                            child: Center(
                              child: Text(
                                "Delete",
                                style:TextStyle(fontSize: 10.0, fontFamily: "Brand-Bold"),
                              ) ,
                            ),
                          ),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(15.0)
                          ),
                          onPressed: (){

                          },
                        ),
                      ],
                    )

                  ],
                ),
                // Image.asset(
                //   "images/"+topic.icon,
                //   height: double.infinity,
                //   width:90
                // )
              ],
            ),
          ));
    },
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsers();

  }
  //
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   setState(() {
  //     getUsers();
  //   });
  // }

  void activateUser(String adminUserId, bool isActive){
    Map<String,dynamic> adminUserDataMap={
      "isActive":isActive,
    };
    adminUsersRef.child(adminUserId).update(adminUserDataMap);
    getUsers();
  }

  void getUsers() async{
    adminUsers.clear();
    await adminUsersRef
        .once()
        .then((DataSnapshot snapshot){
      snapshot.value.forEach((key,values) {

        AdminUsers user = new AdminUsers(
            id: key,
            email: values["email"],
            name: values["name"],
            isActive: values["isActive"],
            photo: values["photo"]
        );

        setState(() {
          adminUsers.add(user);
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
