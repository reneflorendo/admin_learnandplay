import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:learnandplay/AllScreens/loginscreen.dart';
import 'package:learnandplay/AllScreens/mainscreen.dart';
import 'package:learnandplay/AllScreens/registrationscreen.dart';

FirebaseDatabase database = new FirebaseDatabase();
DatabaseReference usersRef= database.reference().child("users");
DatabaseReference topicsRef=database.reference().child("topics");
DatabaseReference pagesRef= database.reference().child("pages");
DatabaseReference studentTopicsRef= database.reference().child("studentTopics");

User? currentFirebaseUser;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  database.setPersistenceEnabled(true);
  database.setPersistenceCacheSizeBytes(10000000);

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
      initialRoute: currentFirebaseUser!=null? MainScreen.idScreen: LoginScreen.idScreen,
      routes: {
        RegistrationScreen.idScreen:(context)=> RegistrationScreen(),
        LoginScreen.idScreen:(context)=> LoginScreen(),
        MainScreen.idScreen:(context)=> MainScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}


