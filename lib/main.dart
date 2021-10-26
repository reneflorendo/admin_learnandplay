import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:learnandplay/AllScreens/loginscreen.dart';
import 'package:learnandplay/AllScreens/mainscreen.dart';
import 'package:learnandplay/AllScreens/studentsforapproval.dart';
FirebaseDatabase database = new FirebaseDatabase();
DatabaseReference usersRef= database.reference().child("users");
DatabaseReference topicsRef=database.reference().child("topics");
DatabaseReference mainTopicsRef=database.reference().child("mainTopics");
DatabaseReference pagesRef= database.reference().child("pages");
DatabaseReference studentTopicsRef= database.reference().child("studentTopics");
DatabaseReference adminUsersRef= database.reference().child("adminUsers");
DatabaseReference gameRankingRef= database.reference().child("gameRanking");

User? currentFirebaseUser;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //database.setPersistenceEnabled(true);
  //database.setPersistenceCacheSizeBytes(10000000);

  currentFirebaseUser = FirebaseAuth.instance.currentUser;
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learn and Play',
      theme: ThemeData(
        fontFamily: "Brand-Bold",
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
     // initialRoute: currentFirebaseUser!=null? MainScreen.idScreen: RegistrationScreen.idScreen,
      initialRoute: LoginScreen.idScreen,
      routes: {
        LoginScreen.idScreen:(context)=> LoginScreen(),
        MainScreen.idScreen:(context)=> MainScreen(),
        StudentsForApproval.idScreen :(context)=> StudentsForApproval()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}


