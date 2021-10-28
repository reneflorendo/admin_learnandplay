import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:learnandplay/AllScreens/arraygame.dart';
import 'package:learnandplay/AllScreens/pagelist.dart';
import 'package:learnandplay/AllScreens/ranking.dart';
import 'package:learnandplay/AllScreens/registrationscreen.dart';
import 'package:learnandplay/AllScreens/topic.dart';
import 'package:learnandplay/Models/GameLeaderboard.dart';
import 'package:learnandplay/Models/GameRanking.dart';
import 'package:learnandplay/Models/Pages.dart';
import 'package:learnandplay/Models/Topics.dart';
import 'package:learnandplay/main.dart';
import "package:collection/collection.dart";
import 'package:supercharged/supercharged.dart';
class Leaderboard  extends StatefulWidget {

  static const String idScreen = "mainScreen";

  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  late List<Topics> _ranking=[];
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
              Topics ranking = _ranking[index];
              return ListTile(
                tileColor: (index%2==0)?Colors.white:Colors.blue,
                title: Text( ranking.title .toUpperCase(), style:TextStyle(fontSize: 12.0, fontFamily: "Brand-Bold")),
                subtitle:Container(
                    width:200 ,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text( ranking.gameId.length > 0 ? ranking.gameId.toUpperCase(): "GAME NOT AVAILABLE", style:TextStyle(fontSize: 12.0, fontFamily: "Brand-Bold")),
                        FlatButton(
                          textColor: (index%2==0)?Colors.blue:Colors.white,
                          onPressed: () {
                            if (ranking.gameId.length > 0) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Ranking(ranking.gameId)));
                            }
                          },
                          child: Text(

                            "View Ranking"
                            ,style:TextStyle(fontSize: 10.0, fontFamily: "Brand-Bold", color: (ranking.gameId.length > 0) ? Colors.blue : Colors.grey ),),
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
    List<Topics> topics = [];
    List<Pages> pg = [];
    await topicsRef.once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        snapshot.value.forEach((key, values) async {
          Topics topic = new Topics(
            id: key,
            title: values['title'],
            duration: values["duration"],
            icon: values["icon"],
            gameId: values['gameId'],
            isActive: values['isActive'],
          );
          // Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(topic.icon);
          // await firebaseStorageRef.getDownloadURL().then((value) => {
          //   topic.url = value
          // });

          setState(() {
            topics.add(topic);
          });
        });

        setState(() {
          _ranking = topics;
        });
      }
    }).catchError((errMsg) {
      displayToastMessage("Error" + errMsg, context);
    });
  }

// void getData(BuildContext context) async {
  //   List<GameRanking> ranking = [];
  //   await gameRankingRef.once().then((DataSnapshot snapshot) {
  //     if (snapshot.value != null) {
  //       snapshot.value.forEach((key, values) async {
  //         GameRanking topic = new GameRanking(id: key,
  //             topic: values["topic"] ,
  //             student: values["student"],
  //             game: values["game"],
  //             scoreOrTime: values["scoreOrTime"],
  //             studentGameId:values["studentGameId"]
  //         );
  //
  //         setState(() {
  //           var isExist;
  //           isExist=ranking.singleWhereOrNull((element) => element.studentGameId!=topic.studentGameId);
  //           if (isExist==null) {
  //             ranking.add(topic);
  //           }
  //         });
  //       });
  //
  //       setState(() {
  //
  //         _ranking=ranking;
  //         //  // ranking.reduce((value, element) => null)
  //         // var rnk= ranking.groupBy((p) => {p.studentGameId},
  //         //    valueTransform: (p) =>
  //         //   { "topic": p.topic, "game": p.game}).entries.map((e) => MapEntry(e.value, e.key));
  //         // for (var kv in rnk) {
  //         //
  //         // }
  //         //
  //         //
  //         // var ddd=rnk;
  //         //   .forEach((key, value) {
  //         //     var xxx=key;
  //         //     var zzz=value;
  //         // });
  //       });
  //
  //
  //     }
  //   }).catchError((errMsg) {
  //     displayToastMessage("Error" + errMsg, context);
  //   });
  // }

}

// extension UtilListExtension on List{
//   groupBy(String key) {
//     try {
//       List<Map<String, dynamic>> result = [];
//       List<String> keys = [];
//
//       this.forEach((f) => keys.add(f[key]));
//
//       [...keys.toSet()].forEach((k) {
//         List data = [...this.where((e) => e[key] == k)];
//         result.add({k: data});
//       });
//
//       return result;
//     } catch (e, s) {
//
//       return this;
//     }
//   }
// }
