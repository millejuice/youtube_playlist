import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayerScreen extends StatefulWidget {
  final List<String> videoUrl;
  const PlayerScreen({super.key, required this.videoUrl,});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late YoutubePlayerController con;
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
  }

  void videoListener() {
    if (con.value.playerState == PlayerState.ended) {
      // 다음 동영상 재생
      if (currentIndex < widget.videoUrl.length - 1) {
        setState(() {
          currentIndex++;
          con.load(widget.videoUrl[currentIndex]);
        });
      }
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
            const Text('다음곡', style: TextStyle(color: Colors.white),),
          ],
        ),
      ),
    );
  }
}