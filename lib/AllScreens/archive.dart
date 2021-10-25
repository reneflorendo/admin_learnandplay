import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:learnandplay/AllScreens/registrationscreen.dart';
import 'package:learnandplay/Models/Users.dart';
import 'package:learnandplay/main.dart';
import 'package:learnandplay/widget/dialog.dart';
import 'package:learnandplay/widget/loading.dart';
import 'package:learnandplay/widget/search.dart';

class Archive extends StatefulWidget {
  @override
  _ArchiveState createState() => _ArchiveState();
}

class _ArchiveState extends State<Archive> {
  bool isLoading = false;
  late List<Users> users= [];
  late List<Users> usersForSearch= [];
  String query="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Archive"),
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
      body:  Column(
        children: <Widget>[
          buildSearch(),
          Expanded(
              child:buildVerticalListView()
          ),
        ],
      ),
    );
  }

  Widget buildSearch() => SearchWidget(
    text: query,
    hintText: 'Student name',
    onChanged: searchStudent,
  );

  void searchStudent(String query) {
    final students = usersForSearch.where((student) {
      final nameLower = student.name.toLowerCase();

      final searchLower = query.toLowerCase();

      return nameLower.contains(searchLower);
    }).toList();

    setState(() {
      this.query = query;
      this.users = students;
    });
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
                          undoStudent(user.id.toString(), user.name);
                          getUsers();
                  },
                  child: Text("Undo",style:TextStyle(fontSize: 10.0, fontFamily: "Brand-Bold"),),
                ),
                SizedBox(width:2),
                FlatButton(
                  textColor: (index%2==0)?Colors.blue:Colors.white,
                  onPressed: () {
                    mydialog(context,
                        title: "Delete",
                        content: user.name,
                        ok: () async {
                          Navigator.of(context).pop();
                         // loading(context);
                          await usersRef.child(user.id.toString()).remove().then((value) => {
                            getUsers(),
                            //Navigator.of(context).pop()
                          });
                        });
                  },
                  child: Text("Delete",style:TextStyle(fontSize: 10.0, fontFamily: "Brand-Bold"),),
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

  void undoStudent(String studentId, String studentName) async
  {
    Map<String, dynamic> userDataMap={
      "isArchive":false
    };

    await  usersRef.child(studentId).update(userDataMap).then((value) async => {
        displayToastMessage(" Undo Student "+ studentName, context),

    });
  }

  void getUsers() async {
    users.clear();
    await usersRef
        .orderByChild("isArchive")
        .equalTo(true)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        snapshot.value.forEach((key, values) {
          Users user = new Users(id: key
              ,
              email: values["email"]
              ,
              name: values["name"]
              ,
              year: values["year"]
              ,
              isActive: values["isActive"]
              ,
              isArchive: values["isArchive"]
              ,
              photo: values["photo"]);

          setState(() {
            users.add(user);
          });
        }
        );
        setState(() {
          users.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
          usersForSearch.addAll(users);
        });
      }
      else {
        setState(() {
          users = [];
        });
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
