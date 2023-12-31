import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube/screen/list.dart';
import 'package:youtube/screen/player.dart';
import 'package:youtube/service/notify.dart';
Future<void> main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.notification.isDenied.then(
    (value){
      Permission.notification.request();
    }
  );
  await initializeService();
  runApp(const MyApp());
}

  
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      color: Colors.red,
      title: 'YouTube API',
      initialRoute: '/playlist', 
      routes: {
        '/playlist' :(context) => const PlaylistScreen(),
        '/player': (context) => PlayerScreen(videoUrl: ModalRoute.of(context)!.settings.arguments as List<String>),
      },
    );
  }
}