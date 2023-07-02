import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:youtube_parser/youtube_parser.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {

  final List<String> videoUrl = [
    'https://www.youtube.com/watch?v=amOSaNX7KJg',
    'https://www.youtube.com/watch?v=7XdadYIxdEE',
    'https://www.youtube.com/watch?v=pAcfgzpN-TU',
    'https://www.youtube.com/watch?v=manv6AFUbM8'
  ];
  List<String> parsed = [];
  List<String> title = [];
  List<String> thumb = [];

@override
  void initState() {
    super.initState();
    parseVideoUrls();
  }

  Future<void> parseVideoUrls() async {
    for (String url in videoUrl) {
      final String? videoId = getIdFromUrl(url);
      parsed.add(videoId!);
      final videoTitle = await getVideoTitle(url);
      title.add(videoTitle);
      thumb.add('https://img.youtube.com/vi/$videoId/0.jpg');
    }
    setState(() {});
  }

  Future<String> getVideoTitle(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final document = parser.parse(response.body);
      final titleElement = document.querySelector('title');
      return titleElement?.text ?? 'Unknown Title';
    }
    return 'Unknown Title';
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
          if (index >= thumb.length || index >= title.length) {
          return const CircularProgressIndicator(); 
        }
          return GestureDetector(
            onTap: () async{
        List<String> updatedParsed = parsed.sublist(index) + parsed.sublist(0, index);
        Navigator.pushNamed(context, '/player', arguments: updatedParsed);
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: ListTile(
  leading: CachedNetworkImage(
    imageUrl: thumb[index],
    placeholder: (context, url) => const CircularProgressIndicator(),
    errorWidget: (context, url, error) => const Icon(Icons.error),
  ),
  title: Text(
    title[index],
    style: const TextStyle(color: Colors.white),
  ),
),

            ),
          );
        },
        ),
    );
  }
}