// ignore_for_file: unused_label

import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:learnandplay/AllScreens/arraygame.dart';
import 'package:learnandplay/AllScreens/listgame.dart';
import 'package:learnandplay/AllScreens/registrationscreen.dart';
import 'package:learnandplay/AllScreens/slides.dart';
import 'package:learnandplay/AllScreens/topic.dart';
import 'package:learnandplay/Models/Pages.dart';
import 'package:learnandplay/Models/Topics.dart';
import 'package:learnandplay/Models/UserTopics.dart';
import 'package:learnandplay/config.dart';
import 'package:learnandplay/main.dart';
import 'package:learnandplay/widget/navigation.dart';

class MainScreen  extends StatefulWidget {
  static const String idScreen = "mainScreen";
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Topics> _topics=[];
  List<Pages> _pages=[];

  @override
  void initState() {

    super.initState();
    getData(context);
    // List<Topics> topics=[];
    // List<Pages> pg=[];
    // topicsRef.once().then((DataSnapshot snapshot){
    //    topics.clear();
    //
    //    snapshot.value.forEach((key,values)  {
    //     Topics topic=new Topics(
    //       id: key,
    //       title: values['title'],
    //       duration: values["duration"],
    //       icon: values["icon"],
    //       gameId:values['gameId'],
    //       isActive:"isActive",
    //     );
    //
    //     setState(() {
    //       topics.add(topic);
    //     });
    //
    //
    //   });
    //   setState(() {
    //     _topics=topics;
    //   });
    // });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Navigation(),
        appBar: AppBar(
          title: Text("Data Structure"),
          //automaticallyImplyLeading: false,
          actions: <Widget>[
            FlatButton(
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Topic(true,"")));
              },
              child: Text("+",style:TextStyle(fontSize: 30.0, fontFamily: "Brand-Bold"),),
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
            ),
          ],
        ) ,
        body: ListView.builder(
            itemCount: _topics.length,
            itemBuilder: (context, index){
              Topics topic= _topics[index];
              return Container(
                  height: 170,
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0)), color: Colors.white, boxShadow: [
                    BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
                  ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: <Widget>[
                            Text(
                              topic.title,
                              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              topic.duration,
                              style: const TextStyle(fontSize: 17, color: Colors.grey),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                              children: <Widget>[
                                SizedBox(
                                  height: 5,
                                  width: 3,
                                ),
                                RaisedButton(
                                  color:Colors.blue,
                                  textColor: Colors.white,
                                  child: Container(
                                    height: 20.0,
                                    child: Center(
                                      child: Text(
                                        "Edit",
                                        style:TextStyle(fontSize: 14.0, fontFamily: "Brand-Bold"),
                                      ) ,
                                    ),
                                  ),
                                  shape: new RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(24.0)
                                  ),
                                  onPressed: (){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Topic(false, topic.id)));
                                   },
                                ),
                                SizedBox(
                                  height: 5,
                                  width: 3,
                                ),
                                RaisedButton(
                                  color: Colors.blue,
                                  textColor: Colors.white,
                                  child: Container(
                                    height: 20.0,
                                    child: Center(
                                      child: Text(
                                        "View Slides",
                                        style:TextStyle(fontSize: 14.0, fontFamily: "Brand-Bold"),
                                      ) ,
                                    ),
                                  ),
                                  shape: new RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(24.0)
                                  ),
                                  onPressed: (){

                                  },
                                ),
                              ],
                            )

                          ],
                        ),
                        Image.network(
                          topic.url!,//"https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                          fit: BoxFit.fill,
                          width: 90,
                          height: 80,
                        )
                        // Image.asset(
                        //   "images/"+topic.icon,
                        //   height: double.infinity,
                        //   width:90
                        // )
                      ],
                    ),
                  ));
            }
        )
    );
  }
  void getGame(BuildContext context, int gameId){

    //Navigator.of(context).pop();

    switch (gameId){
      case 1:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArrayGame()));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListGame()));
        break;
      default: {
       displayToastMessage("Game not available yet!", context);
      }
      break;

    }
  }

  void getPages(String topicId, int index, String topicKey,topic) {
       pagesRef
        .orderByChild("topicId")
        .equalTo(topicId)
        .once()
        .then((DataSnapshot snapshot){
        snapshot.value.forEach((key,values) {

        Pages page= new Pages(id: key
            , text: values["text"]
            , description: values["description"]
            , sourceType: values["sourceType"]
            , pageImage: values["pageImage"]
            , isActive:  values["IsActive"]=="true"
            , topicId:  values["topicId"]
            , order: int.parse(values["Order"])
        );

        _pages.add(page);
      });
      Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (BuildContext context) => Slides(_pages, index,topicId,topicKey,topic)),
        ModalRoute.withName('/'),);
    });
  }

  void getData(BuildContext context) async{
    List<Topics> topics=[];
    List<Pages> pg=[];
    await topicsRef.once().then((DataSnapshot snapshot){
         snapshot.value.forEach((key,values) async {
           Topics topic=new Topics(
            id: key,
            title: values['title'],
            duration: values["duration"],
            icon: values["icon"],
            gameId:values['gameId'],
            isActive:values['isActive'],
           );
           Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(topic.icon);
           await firebaseStorageRef.getDownloadURL().then((value) => {
             topic.url = value
           });

         setState(() {
           topics.add(topic);
         });
      });

      setState(() {
        _topics=topics;
      });
    }).catchError((errMsg){
      displayToastMessage("Error"+errMsg, context);
    });
  }

}
