import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayerScreen extends StatefulWidget {
  final List<String> videoUrl;
  const PlayerScreen({super.key, required this.videoUrl,});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> with WidgetsBindingObserver{
  late YoutubePlayerController con;
  bool isAppInBackground = false;
  int currentIndex = 0;
  static late String youtubeId;
  String? url;

   @override
  void initState() {
    super.initState();
    youtubeId = widget.videoUrl[currentIndex];
    con = YoutubePlayerController(initialVideoId: youtubeId,
    flags: const YoutubePlayerFlags(
    autoPlay: true,
    mute: false,
  )
  )..addListener(videoListener);
    startForegroundService();
     WidgetsBinding.instance.addObserver(this);

  }

   @override
  void dispose() {
    con.dispose();
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void didChangeAppLifeCycleState(AppLifecycleState state){
    if(state == AppLifecycleState.paused){
      isAppInBackground == true;
      startForegroundService();
    }
    else if(state == AppLifecycleState.resumed){
      isAppInBackground == false;
      final service = FlutterBackgroundServiceAndroid();
      service.on('stopService').listen((event) { });
    }
    // else if(state == AppLifecycleState.detached){
    //   final service = FlutterBackgroundServiceAndroid();
    //   service.on('stopService').listen((event) { });
    // }
  }

  Future<void> startForegroundService() async{
    if (Platform.isAndroid) {
      final service = FlutterBackgroundServiceAndroid();
      service.on('SetAsForeground').listen((event) {});
        if(isAppInBackground){
          con.play();
        }
    }
  }

  void videoListener() {
    if (con.value.playerState == PlayerState.ended) {
        setState(() {
          currentIndex = (currentIndex + 1) % widget.videoUrl.length;
          con.load(widget.videoUrl[currentIndex]);
          currentIndex++;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back_ios)),
        title: const Text('플레이리스트', style: TextStyle(color: Colors.white, ),),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: Column(
          children: [
            SizedBox(height: height*0.15,),
            YoutubePlayer(controller: con),
            SizedBox(height: height*0.15,),
            const Divider(color: Colors.white,),
            const SizedBox(height: 10,),
            const Text('다음곡', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );
  }
}