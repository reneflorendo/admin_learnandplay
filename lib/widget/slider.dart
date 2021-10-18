import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:learnandplay/widget/videoplayer.dart';
import 'package:chewie/chewie.dart';
import 'package:learnandplay/widget/youtubevideoplayer.dart';
import 'package:video_player/video_player.dart';
class SliderPage extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final String sourceType;

  SliderPage(
      {required this.title, required this.description, required this.image, required this.sourceType});

  @override
  Widget build(BuildContext context) {
    return getContainerLayout(context,sourceType);
  }

  getContainerLayout(BuildContext context, String sourceType) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    switch (sourceType) {
      case "1":
        return Container(
            color: Colors.white,

            child: Column(

                children: <Widget>[
                  SizedBox(height: 80,),
                  Text(
                    title,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80),
                    child: Text(
                      description,
                      style: TextStyle(
                        height: 1.5,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        letterSpacing: 0.7,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),

                ]));
        break;
      case "2":
      return Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text(
              title,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Image.asset(
              image,
              width: width * 0.6,
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      );
        break;
      case "3":
        return Container(
            color: Colors.white,
            child: Column(
                children: <Widget>[
                  SizedBox(height: 80,),
                  Text(
                    title,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 80,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Html(data:description),
                  ),
                ]));
        break;
      case "4":

        return Container(
          color:Colors.white,
          child: Column(
            children: <Widget>[
              SizedBox(height: 100,),
              YoutubeVideoPlayer(title: title, url: description.trim())
            ],
          ),
        );
        // return Container(
        //     color: Colors.white,
        //     child: Column(
        //         children: <Widget>[
        //         LandPVideoPlayer(videoPlayerController: VideoPlayerController.network("https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_480_1_5MG.mp4"), looping: true),
        //         ]));
        break;
    }
  }
}