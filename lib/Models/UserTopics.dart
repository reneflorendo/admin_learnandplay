import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


class UserTopics
{
  late String? id;
  late String topicId;
  late String? userTopicId;
  late String topic;
  late int currentPage;
  late String status;

  UserTopics({required this.id, required this.topicId, required this.userTopicId, required this.topic, required this.currentPage, required this.status,});

  UserTopics.fromSnapshot(DataSnapshot dataSnapshot)
  {
    id = dataSnapshot.key;
    topicId= dataSnapshot.value["topicId"];
    userTopicId = dataSnapshot.value["userTopicId"];
    topic = dataSnapshot.value["topic"];
    currentPage= dataSnapshot.value["currentPage"];
    status = dataSnapshot.value["status"];
  }
}