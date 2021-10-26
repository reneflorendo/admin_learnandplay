import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learnandplay/AllScreens/pagelist.dart';
import 'package:learnandplay/AllScreens/registrationscreen.dart';
import 'package:learnandplay/Models/Pages.dart';
import 'package:learnandplay/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:flutter_summernote/flutter_summernote.dart';

bool _isAdd=false;
String _url="";
String _topicId="";
String _topic="";
String _pageId="";
String _defaultImage="blank.jpg";
class TopicPage extends StatefulWidget {


  // ignore: empty_constructor_bodies
  TopicPage(bool isAdd,String pageId, String topicId){
    _isAdd=isAdd;
    _topicId=topicId;
    _pageId=pageId;
  }

  @override
  _TopicPageState createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {

  File? _image;
  String _photoName="";
  TextEditingController titleController= new TextEditingController();
  TextEditingController descriptionController= new TextEditingController();
  TextEditingController orderController= new TextEditingController();
  GlobalKey<FlutterSummernoteState> htmlEditor = GlobalKey();


  bool value = false;
  String dropdownValue="1";
  String description="";
  // final listItem = [
  //   "Html",
  //   "Image",
  //   "Video",
  // ];
  List<ListItem> listItem = [
    ListItem("1", "Html"),
    ListItem("2", "Image"),
    ListItem("3", "Video")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text( _isAdd? "Add Page":"Edit Page"),
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
                      SizedBox(height:20.0,),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Source Type',
                              style: TextStyle(fontSize: 14.0),
                            ),
                            DropdownButton<String>(
                              value: dropdownValue,
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style: const TextStyle(color: Colors.deepPurple),
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                  this.description="";
                                  descriptionController.text="";
                                });
                              },
                              items: listItem.map((ListItem item) {
                                return DropdownMenuItem<String>(
                                  child: Text(item.name),
                                  value: item.value,
                                );
                              }).toList(),
                            )]),
                      SizedBox(height:5.0,width: 100,),
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
                      SizedBox(height:5.0,),
                      getWidgetBySourceTYpe(dropdownValue),
                      SizedBox(height:5.0,),
                      TextField(
                        controller: orderController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Order",
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
                      SizedBox(height: 5.0, width: 10), //SizedBox
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

                      SizedBox(height: 10.0),
                      RaisedButton(
                        color:Colors.blue,
                        textColor: Colors.white,
                        child: Container(
                          height: 50.0,
                          child: Center(
                            child: Text(
                              _isAdd?"Add Page": "Save Page",
                              style:TextStyle(fontSize: 14.0, fontFamily: "Brand-Bold"),
                            ) ,
                          ),
                        ),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(24.0)
                        ),
                        onPressed: () async {
                          await htmlEditor.currentState?.getText().then((value) async => {
                            // if (xvalue.length==0){
                            await htmlEditor.currentState?.getText().then((value) =>
                            {
                              this.description=value,
                            }),
                            //}
                          });

                          if (titleController.text.length < 5)
                          {
                            displayToastMessage("Title must be at least 5 characters!", context);
                          }
                          else if ( dropdownValue!="2" && this.description.length < 20)
                          {
                            displayToastMessage("Description is required", context);
                          }
                          else if (orderController.text.length == 0)
                          {
                            displayToastMessage("Order is required", context);
                          }
                          else{
                            if(_isAdd){
                              addPage(context);
                              getPage();
                            }
                            else{
                              editPage(context);

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
    if (_isAdd && dropdownValue=="2") {
      getDefaultImage(_defaultImage);
    }
    else{
      getPage();
    }

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

   getWidgetBySourceTYpe(String sourceType)
  {
    switch (sourceType) {
      case "1":

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Padding(
              padding:const EdgeInsets.only(top:8.0),
              child:  FlutterSummernote(
                          hint: "Your text here...",
                          key: htmlEditor,
                          hasAttachment: true,
                          value: this.description,

                       customToolbar: """
                              ['style', ['bold', 'italic', 'underline', 'clear']],
                              ['font', ['strikethrough', 'superscript', 'subscript']],
                              ['fontsize', ['fontsize']],
                              ['color', ['color']],
                              ['para', ['ul', 'ol', 'paragraph']],
                              ['height', ['height']],
                              ['table', ['table']], """,
                        ),
            )

          ]
        );

        break;
      case "2":
        return  Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              new SizedBox(height:5 ,),
              Text("Image"),
              Row(
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
            ],
          )

        );
        break;
      case "3":
         return Container(
          child:
          TextField(
            controller: descriptionController,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              labelText: "Youtube link",
              labelStyle: TextStyle(
                  fontSize: 14.0
              ),
              hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 10.0
              ),
            ),
            style: TextStyle(
                fontSize: 14.0
            ),
          ),
        );
        break;
    }
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

  Future<void> addPage(BuildContext context)async {

    //final html = await htmlEditor.currentState?.getText();
    Map<String, dynamic> pageDataMap={
      "text":titleController.text.trim(),
      "description": this.description, //descriptionController.text, //html,
      "Order": orderController.text,
      "IsActive":this.value,
      "pageImage": this._photoName.length>0? this._photoName: "blank.jpg",
      "sourceType":this.dropdownValue,
      "topicId":_topicId,
    };

    pagesRef.push().set(pageDataMap).then((value) => {
      displayToastMessage("Page created!", context),
      if(_image!=null){
        uploadPic(context).whenComplete(() => {

        }),
      },
      Navigator.of(context).pop(),
    });
  }

  Future<void> editPage(BuildContext context)async {

   // final html = await htmlEditor.currentState?.getText();

    Map<String, dynamic> pageDataMap={
      "text":titleController.text.trim(),
      "description": this.description, //descriptionController.text,//html,
      "Order": orderController.text,
      "IsActive":this.value,
      "pageImage": this._photoName.length>0? this._photoName: "blank.jpg",
      "sourceType":this.dropdownValue,
      "topicId":_topicId,
    };

    pagesRef.child(_pageId).update(pageDataMap).then((value) => {
      displayToastMessage("Page updated!", context),
      if(_image!=null){
        uploadPic(context),
      },
      Navigator.of(context).pop(),

    });
  }


  getPage() async
  {
    await pagesRef.child(_pageId).once().then((DataSnapshot dataSnapShot)
     async {
      if(dataSnapShot.value != null)
      {

        final page = Pages.fromSnapshot(dataSnapShot);
        titleController.text= page.text;
        this.description=page.description;
        //descriptionController.text= page.description;

        orderController.text= page.order.toString();
        _photoName=(page.pageImage.length>0)?page.pageImage:"blank.jpg";
       // _htmlEditorController.document.insert(0, quillHtmlToDelta(page.description));
        setState(() {
          this.value= page.isActive;
          this.dropdownValue=page.sourceType;
          descriptionController.text =page.description;
          htmlEditor.currentState?.text=this.description;
        });
        if (_photoName.length>0) {
           await getDefaultImage(_photoName).then((value) => {
            _url=value
          });
        }
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

class ListItem{
  String value;
  String name;
  ListItem(this.value, this.name);
}
