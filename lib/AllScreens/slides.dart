import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:learnandplay/AllScreens/mainscreen.dart';
import 'package:learnandplay/AllScreens/registrationscreen.dart';
import 'package:learnandplay/Models/Pages.dart';
import 'package:learnandplay/main.dart';
import 'package:learnandplay/widget/slider.dart';

String _topicId="";
String _topicKey="";
final _pages= <Widget>[];
int _currentPage = 0;
String _title="";
class Slides extends StatefulWidget {
  Slides(List<Pages> pages, index, topicId, topicKey,title){
    _topicId=topicId;
    _topicKey =topicKey;
    _currentPage=index;
    _title=title;
    _pages.clear();
    pages.forEach((element) {
      _pages.add(SliderPage(title: element.text,description: element.description ,image: "images/"+ element.pageImage, sourceType: element.sourceType,));
    });

  }

  @override
  _SlidesState createState() => _SlidesState();

}

class _SlidesState extends State<Slides> {

  PageController _controller = PageController();

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: _currentPage);
  }

  _onchanged(int index) {

    Map<String, dynamic> studentTopicMap={
      "currentPage":index,
    };
    studentTopicsRef.child(_topicKey).update(studentTopicMap);

    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
        title: Text(_title),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),

      body: Stack(
        children: <Widget>[
          PageView.builder(
            scrollDirection: Axis.horizontal,
            onPageChanged: _onchanged,
            controller: _controller,
            itemCount: _pages.length,
            itemBuilder: (context, int index) {
              return _pages[index];
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(_pages.length, (int index) {
                    return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        height: 10,
                        width: (index == _currentPage) ? 30 : 10,
                        margin:
                        EdgeInsets.symmetric(horizontal: 5, vertical: 30),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: (index == _currentPage)
                                ? Colors.blue
                                : Colors.blue.withOpacity(0.5)));
                  })),
              InkWell(
                onTap: () {
                  _controller.nextPage(
                      duration: Duration(milliseconds: 800),
                      curve: Curves.easeInOutQuint);
                },
                child: AnimatedContainer(
                  alignment: Alignment.center,
                  duration: Duration(milliseconds: 300),
                  height: 70,
                  width: (_currentPage == (_pages.length - 1)) ? 200 : 75,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(35)),
                  child: (_currentPage == (_pages.length - 1))
                      ? FlatButton(
                    onPressed: (){

                      Map<String, dynamic> studentTopicMap={
                        "status":"Complete",
                      };
                      studentTopicsRef.child(_topicKey).update(studentTopicMap);

                      Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (BuildContext context) => MainScreen()),
                        ModalRoute.withName('/'),);

                    },
                    child: Text(
                      "Done",
                    ),
                  )
                      : Icon(
                    Icons.navigate_next,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ],
      ),
    );
  }
}
