import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeVideoPlayer extends StatefulWidget {
  final String title;
  final String url;

  YoutubeVideoPlayer({ required this.title, required this.url});

  @override
  _YoutubeVideoPlayerState createState() => _YoutubeVideoPlayerState();
}

class _YoutubeVideoPlayerState  extends State<YoutubeVideoPlayer>{

  late YoutubePlayerController _controller;

  void initiateYoutubePlayer(){
    _controller=YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.url).toString(),
      flags:YoutubePlayerFlags(
        enableCaption: true,
        isLive: false,
        autoPlay: true,
        controlsVisibleAtStart: true
      )
    );

  }

  @override
  void initState() {
    // TODO: implement initState
    initiateYoutubePlayer();
    super.initState();
  }

  @override
  void deactivate() {
    _controller.pause();
    // TODO: implement deactivate
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return  YoutubePlayerBuilder(
        player: YoutubePlayer(
            controller: _controller),
            builder:(context, player){
      return Container(
          color: Colors.white,
          child: Column(
              children: <Widget>[
                player,
              ]));

    });

  }

}
