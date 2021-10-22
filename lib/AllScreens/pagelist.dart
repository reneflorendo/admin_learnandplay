import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:learnandplay/AllScreens/registrationscreen.dart';
import 'package:learnandplay/AllScreens/topicPage.dart';
import 'package:learnandplay/Models/Pages.dart';
import 'package:learnandplay/Models/Users.dart';
import 'package:learnandplay/main.dart';

String _topic="";
String _topicId="";
class PageList extends StatefulWidget {

  PageList(String topicId,String topic){
    _topicId=topicId;
    _topic=topic;

  }
  @override
  _PageListState createState() => _PageListState();
}

class _PageListState extends State<PageList> {
  final List<Pages> pages= [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pages"),
        // automaticallyImplyLeading: false,
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => TopicPage(true, "0", _topicId)));
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

    itemCount:  pages.length,
    itemBuilder: (context, index) {
      final page = pages[index];
      return ListTile(
        tileColor: (index%2==0)?Colors.white:Colors.blue,
        title: Text(page.text, style:TextStyle(fontSize: 14.0, fontFamily: "Brand-Bold")),
        trailing:Container(
            width:200 ,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FlatButton(
                  textColor: (index%2==0)?Colors.blue:Colors.white,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => TopicPage(false,page.id.toString(),_topicId)));
                  },
                  child: Text("Edit",style:TextStyle(fontSize: 14.0, fontFamily: "Brand-Bold"),),
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
    getPages();
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

  void getPages() async{
    pages.clear();
    await pagesRef
        .orderByChild("topicId")
        .equalTo(_topicId)
        .once()
        .then((DataSnapshot snapshot){
      if (snapshot.value!=null){
        snapshot.value.forEach((key,values) {

          Pages page = new Pages(id: key,
              text: values["text"],
              description:values["description"] ,
              sourceType:values["sourceType"] ,
              pageImage:values["pageImage"] ,
              isActive:values["IsActive"] ,
              order:int.parse(values["Order"]) ,
              topicId: values["topicId"] );
          setState(() {
            pages.add(page);
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
