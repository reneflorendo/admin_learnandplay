import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
//import 'package:equatable/equatable.dart';
class GameRanking
{
  late String? id;
  late String topic;
  late String student;
  late String game;
  late String scoreOrTime;

  GameRanking({required this.id,
    required this.topic,
    required this.student,
    required this.game,
    required this.scoreOrTime});

  GameRanking.fromSnapshot(DataSnapshot dataSnapshot)
  {
    id = dataSnapshot.key;
    topic = dataSnapshot.value["topic"];
    student = dataSnapshot.value["student"];
    game = dataSnapshot.value["game"];
    scoreOrTime = dataSnapshot.value["scoreOrTime"];
  }
}