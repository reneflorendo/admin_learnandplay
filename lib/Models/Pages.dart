import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Pages
{
  late String? id;
  late String text;
  late String description;
  late String sourceType;
  late String pageImage;
  late bool isActive;
  late int order;
  late String topicId;

  Pages({required this.id, required this.text, required this.description, required this.sourceType,required this.pageImage,required this.isActive,required this.order, required this.topicId});

  Pages.fromSnapshot(DataSnapshot dataSnapshot)
  {
    id = dataSnapshot.key;
    text = dataSnapshot.value["text"];
    description = dataSnapshot.value["description"];
    sourceType = dataSnapshot.value["sourceType"];
    pageImage = dataSnapshot.value["pageImage"];
    isActive = dataSnapshot.value["isActive"];
    order = dataSnapshot.value["order"];
    topicId = dataSnapshot.value["topicId"];
  }
}