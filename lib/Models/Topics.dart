import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:learnandplay/Models/Pages.dart';

class Topics
{
  late String id;
  late String title;
  late String duration;
  late String icon;
  late int gameId;
  late String status;
 // late List<Pages> pages;
  Topics({required this.id, required this.title, required this.duration, required this.icon, required this.gameId, required this.status});

  Topics.fromSnapshot(DataSnapshot dataSnapshot)
  {
    id = dataSnapshot.key!;
    title = dataSnapshot.value["title"];
    duration = dataSnapshot.value["duration"];
    icon = dataSnapshot.value["icon"];
    gameId= dataSnapshot.value["gameId"];
  }
}