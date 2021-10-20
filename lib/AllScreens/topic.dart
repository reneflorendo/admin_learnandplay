import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learnandplay/AllScreens/mainscreen.dart';
import 'package:learnandplay/AllScreens/registrationscreen.dart';
import 'package:learnandplay/AllScreens/topiclist.dart';
import 'package:learnandplay/Models/Topics.dart';
import 'package:learnandplay/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';

bool _isAdd=false;
String _url="";
String _topicId="";
String _defaultImage="blank.jpg";
class Topic extends StatefulWidget {

  
  // ignore: empty_constructor_bodies
  Topic(bool isAdd, String topicId){
     _isAdd=isAdd;
     _topicId=topicId;
  }

  @override
  _TopicState createState() => _TopicState();
}

class _TopicState extends State<Topic> {
  File? _image;
  String _photoName="";
  TextEditingController titleController= new TextEditingController();
  TextEditingController durationController= new TextEditingController();
  TextEditingController gameIdController= new TextEditingController();
  TextEditingController imageController= new TextEditingController();
  bool value = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text( _isAdd? "Add Topic":"Edit Topic"),
       ) ,
      body:SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.all(15.0),
                  child:Column(
                    children: [

                      SizedBox(height:1.0,width: 100,),
                      TextField(

                        controller: titleController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Title",
                          labelStyle: TextStyle(
                              fontSize: 14.0
                          ),
                          hintStyle: TextStyle(
                              color:Colors.grey,
                              fontSize: 10.0
                          ),
                        ),
                        style: TextStyle(
                            fontSize: 14.0
                        ),
                      ),

                      SizedBox(height:1.0,),
                      TextField(
                        controller: durationController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Duration",
                          labelStyle: TextStyle(
                              fontSize: 14.0
                          ),
                          hintStyle: TextStyle(
                              color:Colors.grey,
                              fontSize: 10.0
                          ),
                        ),
                        style: TextStyle(
                            fontSize: 14.0
                        ),
                      ),
                      SizedBox(height:1.0,),
                      TextField(
                        controller: gameIdController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Game Id",
                          labelStyle: TextStyle(
                              fontSize: 14.0
                          ),
                          hintStyle: TextStyle(
                              color:Colors.grey,
                              fontSize: 10.0
                          ),
                        ),
                        style: TextStyle(
                            fontSize: 14.0
                        ),
                      ),
                      SizedBox(width: 10), //SizedBox
                      Container(
                        child: Row(
                          children: [
                            Text("Active"),
                            Checkbox(

                                value: this.value,
                                onChanged: (bool? value) {
                                  setState(() {
                                    this.value = value!;
                                  });
                                }
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 10,),
                      Container(
                        child:Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            new SizedBox(
                              width: 180.0,
                              height: 180.0,

                              child: (_image!=null)?Image.file(
                                _image!,
                                fit: BoxFit.fill,
                              ):Image.network(
                                _url,
                                fit: BoxFit.fill,
                              ),
                            ),
                            IconButton(onPressed: (){
                              pickImage();
                            }, icon: Icon(Icons.upload_file_rounded))
                          ]
                        ) ,
                      ),


                      SizedBox(height: 10.0),
                      RaisedButton(
                        color:Colors.blue,
                        textColor: Colors.white,
                        child: Container(
                          height: 50.0,
                          child: Center(
                            child: Text(
                               _isAdd?"Add Topic": "Save Topic",
                              style:TextStyle(fontSize: 14.0, fontFamily: "Brand-Bold"),
                            ) ,
                          ),
                        ),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(24.0)
                        ),
                        onPressed: (){
                          if (titleController.text.length < 5)
                          {
                            displayToastMessage("Title must be at least 5 characters!", context);
                          }
                          else if (durationController.text.length==0)
                          {
                            displayToastMessage("Duration is required", context);
                          }
                          else if (gameIdController.text.length==0)
                          {
                            displayToastMessage("Game Id is required", context);
                          }
                          else{
                            if(_isAdd){
                              addTopic(context);
                            }
                            else{
                              editTopic(context);
                            }
                          }

                        },
                      )
                    ],
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (_isAdd) {
      getDefaultImage(_defaultImage);
    }
    else{
      getTopic();
    }

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  Future uploadPic(BuildContext context) async{
    String fileName = basename(_image!.path);
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = firebaseStorageRef.putFile(_image!);
    TaskSnapshot taskSnapshot=await uploadTask.whenComplete(() => {
      // setState(() {
      //   print("Profile Picture uploaded");
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
      // })
    });

  }

  Future<void> addTopic(BuildContext context)async {
    Map topicDataMap={
      "title":titleController.text.trim(),
      "duration":durationController.text.trim(),
      "gameId": int.parse(gameIdController.text),
      "isActive":this.value,
      "icon": this._photoName.length>0? this._photoName: "blank.png"
    };

    topicsRef.push().set(topicDataMap).then((value) => {
      displayToastMessage("Topic created!", context),
      if(_image!=null){
        uploadPic(context),
      },
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => MainScreen()), ModalRoute.withName('/'),)

    });
  }

  Future<void> editTopic(BuildContext context)async {
    Map<String, dynamic> topicDataMap={
      "title":titleController.text.trim(),
      "duration":durationController.text.trim(),
      "gameId": int.parse(gameIdController.text),
      "isActive":this.value,
      "icon": this._photoName.length>0? this._photoName: "blank.png"
    };

    topicsRef.child(_topicId).update(topicDataMap).then((value) => {
      displayToastMessage("Topic updated!", context),
    if(_image!=null){
        uploadPic(context),
      },
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => MainScreen()), ModalRoute.withName('/'),)

    });
  }

  getTopic() async
  {
    await topicsRef.child(_topicId).once().then((DataSnapshot dataSnapShot)
    async {
      if(dataSnapShot.value != null)
      {

        final topic = Topics.fromSnapshot(dataSnapShot);
        titleController.text= topic.title;
        durationController.text= topic.duration;
        gameIdController.text= topic.gameId.toString();
        _photoName=topic.icon;

        setState(() {
          this.value= topic.isActive;
        });

        _url= await getDefaultImage(topic.icon );
      }
    });

  }

  Future<String> getDefaultImage(String image)async
  {
    var url="";
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(image);
      await firebaseStorageRef.getDownloadURL().then((value) => {
      url=value
    });

    setState(() {
      _url=url;
    });

    return _url;
  }

  pickImage() async
  {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final permanentImage= await saveImagePermanently(image.path);
      setState(() {
        this._image = permanentImage;

      });
    } on PlatformException catch (e){
    }
  }

  Future<File> saveImagePermanently(String imagePath) async{
    final directory = await getApplicationDocumentsDirectory();
    this._photoName =basename(imagePath);
    final image=File('${directory.path}/$_photoName');
    return File(imagePath).copy(image.path);

  }


}
