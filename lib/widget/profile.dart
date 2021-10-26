import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learnandplay/AllScreens/mainscreen.dart';
import 'package:learnandplay/AllScreens/registrationscreen.dart';
import 'package:learnandplay/AllScreens/studentsforapproval.dart';
import 'package:learnandplay/Models/AdminUsers.dart';
import 'package:learnandplay/Models/Users.dart';
import 'package:learnandplay/config.dart';
import 'package:learnandplay/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
class Profile extends StatefulWidget {


  @override
  _ProfileState createState() => _ProfileState();
}
class _ProfileState extends State<Profile> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController yearTextEditingController = TextEditingController();
  User? firebaseUser;
  String userId="";
  File? _image;
  String photoName="";
  String _url="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfile();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
        title: Text("Profile"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),

      body:SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height:20.0,),
              Padding(
                  padding: EdgeInsets.all(15.0),
                  child:Column(
                    children: [
                      SizedBox(height: 20,),

                      Stack(
                        children: <Widget>[
                           ClipOval(
                            child: new SizedBox(
                              width: 180.0,
                              height: 180.0,
                              child: (_image!=null)?Image.file(
                                _image!,
                                fit: BoxFit.fill,
                              ):Image.network(
                                _url,//"https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            right: 20,
                            child:InkWell(
                              onTap: (){
                                showModalBottomSheet(context: context
                                    , builder: ((builder)=> bottomSheet(context))
                                );
                              },
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.blue,
                                size: 30,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height:20.0,),
                      TextField(
                        enabled: false,
                        controller: emailTextEditingController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Email",
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
                      SizedBox(height:20.0,),
                      TextField(
                        enabled: true,
                        controller: nameTextEditingController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Name",
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

                      SizedBox(height: 20.0),
                      RaisedButton(
                        color:Colors.blue,
                        textColor: Colors.white,
                        child: Container(
                          height: 50.0,
                          width: 50,
                          child: Center(
                            child: Text(
                              "Update",
                              style:TextStyle(fontSize: 14.0, fontFamily: "Brand-Bold"),
                            ) ,
                          ),
                        ),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(24.0)
                        ),
                        onPressed: (){
                          if (nameTextEditingController.text.length < 3)
                          {
                            displayToastMessage("Name must be at least 3 characters", context);
                          }

                          else{
                            uploadPic(context);
                            updateUser(context);
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

  Widget bottomSheet(BuildContext context)
  {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20
      ),
      child: Column(
        children: <Widget>[
          SizedBox(height: 20,),
          Row(
            children: <Widget>[
              FlatButton.icon(
                  onPressed: (){
                    pickImage(ImageSource.camera);
                  }
                  , icon: Icon(Icons.camera)
                  , label: Text("Camera")
              ),
              FlatButton.icon(
                  onPressed: (){
                    pickImage(ImageSource.gallery);
                  }
                  , icon: Icon(Icons.camera)
                  , label: Text("Gallery")
              )
            ],
          )
        ],
      ),

    );
  }

  Future uploadPic(BuildContext context) async{
   // String fileName = basename(_image!.path);
    photoName = basename(_image!.path);
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(photoName);
    UploadTask uploadTask = firebaseStorageRef.putFile(_image!);
    TaskSnapshot taskSnapshot=await uploadTask.whenComplete(() => {
      setState(() {
      print("Profile Picture uploaded");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
      })
    });

  }

  pickImage(ImageSource source) async
  {
    try {
      final image = await ImagePicker().pickImage(source: source);
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
    //photoName =basename(imagePath);
    final image=File('${directory.path}/$photoName');
    return File(imagePath).copy(image.path);

  }

  void updateUser(BuildContext context) async
  {
    if (firebaseUser!=null)
    {
      var uid=firebaseUser!.uid;
      adminUsersRef.child(uid);
      Map<String, dynamic> userDataMap={
        "name":nameTextEditingController.text.trim(),
        "photo":photoName,
      };
     // Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(userCurrentInfo.photo);
    await  usersRef.child(uid).update(userDataMap).then((value) async => {
          // await firebaseStorageRef.getDownloadURL().then((value) => {
          // _url=value
          // }),
      userCurrentInfo.photo=photoName,
      displayToastMessage("Your account has been updated!", context),
      Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (BuildContext context) => StudentsForApproval()),
      ModalRoute.withName('/'),)
    });

    }
    else
    {
      displayToastMessage("User was not updated!", context);
    }
  }

  getProfile() async{
    firebaseUser = FirebaseAuth.instance.currentUser;
    userId = firebaseUser!.uid;
    DatabaseReference reference = FirebaseDatabase.instance.reference().child("adminUsers").child(userId);

    await reference.once().then((DataSnapshot dataSnapShot)
    async {
      if(dataSnapShot.value != null)
      {

        adminUserCurrentInfo = AdminUsers.fromSnapshot(dataSnapShot);
        emailTextEditingController.text= adminUserCurrentInfo.email;
        nameTextEditingController.text= adminUserCurrentInfo.name;
        photoName=adminUserCurrentInfo.photo;
        Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(photoName);
        await firebaseStorageRef.getDownloadURL().then((value) => {
          _url=value
        });

        setState(() {
        });

      }
    });
  }

}
