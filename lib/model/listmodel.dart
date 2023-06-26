

class PlayList {
      late final int no;
      late String artis;
      late String title;
      late String thumbURL;
      late String playTime;
      late String songURL;
      
      PlayList(
        {
          required this.no,
          required this.artis,
          required this.title,
          required this.thumbURL,
          required this.playTime,
          required this.songURL,
        });

        PlayList.fromJson(Map<String, dynamic> json){
          no= json['no'];
          artis = json['artist'];
          title = json['title'];
          thumbURL = json['thumbURL'];
          playTime = json['playTime'];
          songURL = json['songURL'];
        }

        Map<String, dynamic> toJson(){
          final Map<String,dynamic> data = <String, dynamic>{};
          data['no']=no;
          data['artist']=artis;
          data['title']=title;
          data['thumbURL']=thumbURL;
          data['playTime']=playTime;
          data['songURL']=songURL;
          return data;
        }
}