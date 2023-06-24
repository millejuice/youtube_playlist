import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomeScreen extends StatefulWidget {
  final String id;
  const HomeScreen({required this.id, Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static late String youtubeId;
  late YoutubePlayerController _con;


   @override
  void initState() {
    super.initState();
    youtubeId = widget.id;
    _con = YoutubePlayerController(initialVideoId: youtubeId,
    flags: const YoutubePlayerFlags(
    autoPlay: true,
    mute: false,
  )
  );
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: const Text('Youtube'), 
      ),
      body: 
      
      Container(
        color: Colors.black,
        child: Center(
          child: YoutubePlayer(controller: _con),
        ),
      )
      ,
    );
  }
}