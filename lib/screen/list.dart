import 'package:flutter/material.dart';
import 'package:youtube_parser/youtube_parser.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {

  final List<String> videoUrl = [
    'https://www.youtube.com/watch?v=amOSaNX7KJg',
    'https://www.youtube.com/watch?v=QxM4fvBLhDk',
    'https://www.youtube.com/watch?v=pAcfgzpN-TU',
  ];
  List<String> parsed = [];

@override
  void initState() {
    super.initState();
    parseVideoUrls();
  }

  Future<void> parseVideoUrls() async {
    for (String url in videoUrl) {
      final String? videoId = getIdFromUrl(url);
      parsed.add(videoId!);
    }
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_back_ios)),
        title: const Text('플레이리스트', style: TextStyle(color: Colors.white, ),),
      ),
      body: ListView.builder(
        itemCount: videoUrl.length,
        itemBuilder: (context, index){
          return GestureDetector(
            onTap: () {
        List<String> updatedParsed = parsed.sublist(index) + parsed.sublist(0, index);
        Navigator.pushNamed(context, '/player', arguments: updatedParsed);
            },

            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: ListTile(
               // leading: Image.network(),
                title: Text(parsed[index], style: const TextStyle(color: Colors.white),),
              ),
            ),
          );
        },
        ),
    );
  }
}