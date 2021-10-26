import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:learnandplay/AllScreens/arraygame.dart';
import 'package:learnandplay/AllScreens/pagelist.dart';
import 'package:learnandplay/AllScreens/ranking.dart';
import 'package:learnandplay/AllScreens/registrationscreen.dart';
import 'package:learnandplay/AllScreens/topic.dart';
import 'package:learnandplay/Models/GameRanking.dart';
import 'package:learnandplay/Models/Pages.dart';
import 'package:learnandplay/Models/Topics.dart';
import 'package:learnandplay/main.dart';
import "package:collection/collection.dart";
class Leaderboard  extends StatefulWidget {

  static const String idScreen = "mainScreen";

  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  List<GameRanking> _ranking = [];
  @override
  void initState() {
    super.initState();
    getData(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Leaderboard"),
        ),
        body: ListView.builder(
            itemCount: _ranking.length,
            itemBuilder: (context, index) {
              GameRanking ranking = _ranking[index];
              return ListTile(
                tileColor: (index%2==0)?Colors.white:Colors.blue,
                title: Text( ranking.topic.toUpperCase(), style:TextStyle(fontSize: 12.0, fontFamily: "Brand-Bold")),
                subtitle:Container(
                    width:200 ,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        FlatButton(
                          textColor: (index%2==0)?Colors.blue:Colors.white,
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Ranking()));
                          },
                          child: Text("View Ranking",style:TextStyle(fontSize: 10.0, fontFamily: "Brand-Bold"),),
                        ),

                      ],
                    )
                ),
              );
            }
        )
    );
  }

  void getData(BuildContext context) async {
    List<GameRanking> ranking = [];
    await gameRankingRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        snapshot.value.forEach((key, values) async {
          GameRanking topic = new GameRanking(id: key,
              topic: values["topic"] ,
              student: values["student"],
              game: values["game"],
              scoreOrTime: values["scoreOrTime"]);

          setState(() {
            ranking.add(topic);
          });
        });

        setState(() {
           // ranking.reduce((value, element) => null)

          _ranking = ranking;
        });
      }
    }).catchError((errMsg) {
      displayToastMessage("Error" + errMsg, context);
    });
  }

}
