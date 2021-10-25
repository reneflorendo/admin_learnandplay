import 'package:firebase_database/firebase_database.dart';
class Users {
  late String? id;
  late String email;
  late String name;
  late String year;
  late bool isActive;
  late bool isArchive;
  late String photo;

  Users(
      {required this.id, required this.email, required this.name, required this.year, required this.isActive, required this.isArchive, required this.photo});

  Users.fromSnapshot(DataSnapshot dataSnapshot)
  {
    id = dataSnapshot.key;
    email = dataSnapshot.value["email"];
    name = dataSnapshot.value["name"];
    year = dataSnapshot.value["year"] ?? "1st";
    isActive = dataSnapshot.value["isActive"];
    isArchive = dataSnapshot.value["isArchive"];
    photo = dataSnapshot.value["photo"];
  }
}