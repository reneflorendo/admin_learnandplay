import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:learnandplay/AllScreens/registrationscreen.dart';
import 'package:learnandplay/Models/GameRanking.dart';
import 'package:learnandplay/main.dart';

String _game="";
class Ranking extends StatefulWidget {
  Ranking (String game){
    _game=game;
  }

  @override
  _RankingState createState() => _RankingState();
}

class _RankingState extends State<Ranking> {


  List<GameRanking> _ranking=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Ranking"),
        ),
        body: ListView.builder(
            itemCount: _ranking.length,
            itemBuilder: (context, index) {
              GameRanking ranking = _ranking[index];
              return ListTile(
                tileColor: (index%2==0)?Colors.white:Colors.blue,
                title:Text( ranking.student.toUpperCase(), style:TextStyle(fontSize: 12.0, fontFamily: "Brand-Bold")),
                subtitle: Text("Time : ${ranking.scoreOrTime} secs" , style:TextStyle(fontSize: 12.0, fontFamily: "Brand-Bold")),
              );
            }
        )
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData(context);

  }
void getData(BuildContext context) async {
  List<GameRanking> ranking = [];
  await gameRankingRef
      .orderByChild("game")
      .equalTo(_game).get()
      .then((DataSnapshot snapshot) {
    if (snapshot.value != null) {
      snapshot.value.forEach((key, values) async {
        GameRanking topic = new GameRanking(id: key,
            topic: values["topic"] ,
            student: values["student"],
            game: values["game"],
            scoreOrTime: values["scoreOrTime"],
            studentGameId:values["studentGameId"]
        );

        setState(() {
            ranking.add(topic);
        });
      });

      setState(() {
        ranking.sort((a, b) => b.scoreOrTime.compareTo(a.scoreOrTime));
        _ranking=ranking.reversed.toList();

      });


    }
  }).catchError((errMsg) {
    displayToastMessage("Error" + errMsg, context);
  });
}
}

