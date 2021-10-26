// ignore_for_file: unused_label

import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:learnandplay/AllScreens/registrationscreen.dart';
import 'package:learnandplay/Models/Pages.dart';
import 'package:learnandplay/Models/Topics.dart';
import 'package:learnandplay/config.dart';
import 'package:learnandplay/main.dart';
import 'package:learnandplay/widget/navigation.dart';

String _userId="";
class Monitoring  extends StatefulWidget {

  static const String idScreen = "monitoring";

  Monitoring(String userId)
  {
    _userId=userId;
  }
  @override
  _MonitoringState createState() => _MonitoringState();
}

class _MonitoringState extends State<Monitoring> {
  List<Topics> _topics = [];

  @override
  void initState() {
    getData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Data Structure"),
        ),
        body: ListView.builder(
            itemCount: _topics.length,
            itemBuilder: (context, index) {
              Topics topic = _topics[index];
              return ListTile(
                tileColor: (index % 2 == 0) ? Colors.white : Colors.blue,
                title: Text(topic.title.toUpperCase(),
                    style: TextStyle(fontSize: 12.0, fontFamily: "Brand-Bold")),
                subtitle: Text("Status :" + topic.status.toString(),
                    style: TextStyle(fontSize: 12.0, fontFamily: "Brand-Bold")),

              );
            }
        )
    );
  }

  void getData(BuildContext context) async {
    List<Topics> topics = [];
    List<Pages> pg = [];
    await topicsRef.orderByChild("isActive").equalTo(true).once().then((
        DataSnapshot snapshot) {
      snapshot.value.forEach((key, values) async {
        Topics topic = new Topics(
          id: key,
          title: values['title'],
          duration: values["duration"],
          icon: values["icon"],
          gameId: values['gameId'],
          isActive: values['isActive'],
          status: "",
        );

        await getStatus(_userId, topic.id).then((value) =>
        {
          topic.status = value
              .toString()
              .length == 0 ? "Not Started" : value.toString()
        });

        setState(() {
          topics.add(topic);
        });
      });
      setState(() {
        _topics = topics;
      });
    }).catchError((errMsg) {
      displayToastMessage("Error" + errMsg, context);
    });
  }

  Future<String> getStatus(String? userId, String topicId) async
  {
    String status = "";
    final userTopicId = userId.toString() + "_" + topicId;
    await studentTopicsRef
        .orderByChild("userTopicId")
        .equalTo(userTopicId)
        .once().then((DataSnapshot dataSnapshot) =>
    {

      if (dataSnapshot.value != null)
        {
          dataSnapshot.value.forEach((key, values) {
            status = values["status"];
          }),

          setState(() {
            status = status;
          }),

        }
    }
    );
    return status;
  }
}
