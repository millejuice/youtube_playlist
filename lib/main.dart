// import 'package:flutter/material.dart';
// // import 'package:permission_handler/permission_handler.dart';
// import 'package:youtube/screen/list.dart';
// import 'package:youtube/screen/player.dart';
// import 'package:audio_service/audio_service.dart';
// import 'service/background_service.dart';
// // import 'package:just_audio/just_audio.dart';
// // import 'package:youtube/service/notify.dart';

// late AudioHandler _audioHandler;
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // store this in a singleton
//   _audioHandler = await AudioService.init(
//     builder: () => MyAudioHandler(),
//     config: const AudioServiceConfig(
//       androidNotificationChannelId: 'com.example.youtube',
//       androidNotificationChannelName: 'youtube',
//       androidNotificationOngoing: true,
//     ),
//   );
//   runApp(const MyApp());
// }

// // void main() {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   // await Permission.notification.isDenied.then((value) {
// //   //   Permission.notification.request();
// //   // });
// //   // await initializeService();
// //   runApp(const MyApp());
// // }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       color: Colors.red,
//       title: 'YouTube API',
//       initialRoute: '/playlist',
//       routes: {
//         '/playlist': (context) => const PlaylistScreen(),
//         '/player': (context) => PlayerScreen(
//             videoUrl:
//                 ModalRoute.of(context)!.settings.arguments as List<String>),
//       },
//     );
//   }
// }

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Youtube Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AudioServiceWidget(child: HomePage()),
    );
  }
}

class HomePage extends StatelessWidget {
  final yt = YoutubeExplode();
  final List<String> videoUrl = [
    'https://www.youtube.com/watch?v=amOSaNX7KJg',
    'https://www.youtube.com/watch?v=7XdadYIxdEE',
    'https://www.youtube.com/watch?v=pAcfgzpN-TU',
    'https://www.youtube.com/watch?v=manv6AFUbM8'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Youtube Player'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            for (String url in videoUrl) {
              var videoId = VideoId(
                  url.replaceFirst("https://www.youtube.com/watch?v=", ""));
              var manifest = await yt.videos.streamsClient.getManifest(videoId);
              var audio = manifest.audioOnly.withHighestBitrate();
              await AudioService.start(
                backgroundTaskEntrypoint: entrypoint,
                androidNotificationChannelName: 'Youtube Player',
                // Enable this if you want the Android service to exit the foreground state on pause.
                //androidStopForegroundOnPause: true,
                androidNotificationColor: 0xFF2196f3,
                androidNotificationIcon: 'mipmap/ic_launcher',
                androidEnableQueue: true,
              );
              AudioService.playFromMediaId(audio.url.toString());
            }
          },
          child: Text('Play Youtube'),
        ),
      ),
    );
  }
}

void entrypoint() async {
  AudioServiceBackground.run(() => AudioPlayerTask());
}

class AudioPlayerTask extends BackgroundAudioTask {
  final _player = AudioPlayer();

  @override
  Future<void> onStart(Map<String, dynamic>? params) async {
    // Configure the audio session for playback
    await _player.setAudioSource(ConcatenatingAudioSource(children: []));
  }

  @override
  Future<void> onPlayMediaItem(MediaItem mediaItem) async {
    await _player.setAudioSource(AudioSource.uri(Uri.parse(mediaItem.id)));
    _player.play();
  }

  @override
  Future<void> onStop() async {
    await _player.stop();
    await _player.dispose();
    await super.onStop();
  }
}
