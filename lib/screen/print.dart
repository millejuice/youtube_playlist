import 'package:flutter/material.dart';
import '../model/urlmodel.dart';

class PrintUrl extends StatefulWidget {
  const PrintUrl({super.key});

  @override
  State<PrintUrl> createState() => _PrintUrlState();
}

class _PrintUrlState extends State<PrintUrl> {
    var countUrl = 0;
@override
  void initState() {
    super.initState();
    countUrl = url.length; // url 리스트의 개수를 countUrl에 저장
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (String link in url)
            Text(link),
            ],
          ),
    );
  }
}

//url들로 playlist만들어서 audioplayer 패키지로 실행시키기