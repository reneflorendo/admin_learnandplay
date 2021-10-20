import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


class AdminUsers
{
  late String? id;
  late String email;
  late String name;
  late bool isActive;
  late String photo;

  AdminUsers({required this.id, required this.email, required this.name, required this.isActive, required this.photo});

  AdminUsers.fromSnapshot(DataSnapshot dataSnapshot)
  {
    id = dataSnapshot.key;
    email = dataSnapshot.value["email"];
    name = dataSnapshot.value["name"];
    isActive = dataSnapshot.value["isActive"];
    photo = dataSnapshot.value["photo"];
  }
}