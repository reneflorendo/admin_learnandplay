import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:learnandplay/AllScreens/loginscreen.dart';
import 'package:learnandplay/config.dart';
import 'package:learnandplay/main.dart';
import 'package:learnandplay/widget/changepassword.dart';
import 'package:learnandplay/widget/profile.dart';
import 'package:learnandplay/widget/topicscomplete.dart';

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  final padding = EdgeInsets.symmetric(horizontal: 5);
  String _url="";
  @override
  void initState() {
    // TODO: implement initState
    getImage();
    super.initState();
  }
  
  getImage() async{
    String url="";
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(userCurrentInfo.photo);
    await firebaseStorageRef.getDownloadURL().then((value) => {
      url=value
    });
    
    setState(() {
      _url=url;
    });
  }
  @override
  Widget build(BuildContext context) {

    final name =userCurrentInfo.name;
    final email= userCurrentInfo.email;
    final photo= userCurrentInfo.photo; 

    //"https://firebasestorage.googleapis.com/v0/b/learnandplay-bfa40.appspot.com/o/user_icon.png?alt=media&token=d1ea60d2-2bd0-46f5-b49c-56438c2dae14";

    return Drawer(
      child: Material(
        color: Colors.blue,
        child: ListView(
          padding:padding,
          children: <Widget>[
            buildHeader(
              photo:_url,
              name:name,
              email:email
            ),
            const SizedBox(height:10),
            Divider(color: Colors.white70,thickness: 1,),
            const SizedBox(height: 20),
            buildMenuItem(
              text:"My Account",
              icon:Icons.people,
              onClicked: ()=> selectedItem(context, 0)
            ),
            const SizedBox(height: 20),
            buildMenuItem(
              text:"Change Password",
              icon:Icons.vpn_key,
              onClicked: ()=> selectedItem(context, 1)
            ),
             const SizedBox(height:20),
            Divider(color: Colors.white70,),
            const SizedBox(height: 20),
            buildMenuItem(
                text:"Log out",
                icon:Icons.logout,
                onClicked: ()=> selectedItem(context, 3)

            ),
          ],
        ) ,

      ),
    );
  }
  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked
  })
  {
    final color =Colors.white;
    final hoverColor = Colors.red;

    return ListTile(
     leading: Icon(icon, color:color),
    title: Text(text, style: TextStyle(color:color)),
    hoverColor: hoverColor,
    onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index){

    //Navigator.of(context).pop();

    switch (index){
      case 0:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Profile()));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChangePassword()));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Topics()));
        break;
      case 3:
        //_firebaseAuth.signOut();
        database.setPersistenceEnabled(false);
        database.setPersistenceCacheSizeBytes(0);
        Navigator.of(context).pop();
        signOut(context);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
            }
  }

  void signOut(BuildContext context)async {
  Navigator.of(context).pop();
  await _firebaseAuth.signOut();
}

  Widget buildHeader(
  {
   required String photo,
   required String name,
   required String email
  }) =>
      InkWell(
        child: Container(
        padding:padding.add(EdgeInsets.symmetric(vertical: 30)),
        child:
        Row(
          children: [

          //  SizedBox(width:30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(photo),
                ),
                SizedBox(height: 10),
                Text(
                    name,
                    style: TextStyle(fontSize: 20, color: Colors.white)
            ),
                    SizedBox(height: 4),
                    Text(
                      email,
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    )
              ],
            ),

          ],
        ),
      )
      );

}
