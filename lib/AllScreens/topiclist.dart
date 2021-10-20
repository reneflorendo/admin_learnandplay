import 'package:flutter/material.dart';
import 'package:learnandplay/Models/Pages.dart';

class TopicList extends StatefulWidget {
  // ignore: empty_constructor_bodies
  TopicList(){

  }
  static const String idScreen = "topicListScreen";
  @override
  _TopicListState createState() => _TopicListState();
}

class _TopicListState extends State<TopicList> {
  final _pages= <Pages>[];
  final items = List.generate(2000, (counter) => 'Item: $counter');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text("Array Slides"),
      automaticallyImplyLeading: false,
      actions: <Widget>[
      FlatButton(
      textColor: Colors.white,
      onPressed: () {},
      child: Text("+",style:TextStyle(fontSize: 30.0, fontFamily: "Brand-Bold"),),
      shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
      ),
      ],

    ) ,
        body:  buildVerticalListView(),
    );
  }

  Widget buildVerticalListView() => ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, index) {
      final item = items[index];

      return ListTile(
        tileColor: (index%2==0)?Colors.white:Colors.blue,
        title: Text(item, style:TextStyle(fontSize: 14.0, fontFamily: "Brand-Bold")),
        trailing:Container(
           width:200 ,
            child: Row(

          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FlatButton(
              textColor: (index%2==0)?Colors.blue:Colors.white,
              onPressed: () {
                print("Edit");
              },
              child: Text("Edit",style:TextStyle(fontSize: 14.0, fontFamily: "Brand-Bold"),),
            ),
            SizedBox(width:2),
            FlatButton(
              textColor: (index%2==0)?Colors.blue:Colors.white,
              onPressed: () {

                print("Delete");
              },
              child: Text("Delete",style:TextStyle(fontSize: 14.0, fontFamily: "Brand-Bold"),),
            ),
          ],
        )
        ),
        );
    },
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
