import 'listmodel.dart';

class PlayListRepo{
  static List<PlayList> playlist = <PlayList>[
    PlayList(
      no:0,
      artis: "Shaun",
     title: 'Way Back Home',
      thumbURL: '"https://i.ytimg.com/vi/amOSaNX7KJg/default.jpg"', 
      playTime: '3:00',
      songURL: 'https://www.youtube.com/watch?v=amOSaNX7KJg',
      ),
      PlayList(
      no:1,
      artis: "주현", 
      title: "go home",
       thumbURL: 'url2',
        playTime: '3:00',
        songURL: '',
        ),

  ];
}