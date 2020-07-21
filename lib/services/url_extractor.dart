import 'package:youtube_downloader/index.dart';

/// Extract the Audio URL of given VideoID
class YTExtractor {
  
  YouTubeExtractor extractor;
  String videoId;

  YTExtractor() {
    extractor = new YouTubeExtractor();
  } 

  void setVideo(String videoId) {
    this.videoId = videoId;
  }

  Future<String> getAudioUrl(String videoId) async {
    var streamInfo = await extractor.getMediaStreamsAsync(videoId);
    String url = streamInfo.audio.first.url;
    print(url);
    print('${streamInfo.audio.first.url}');
    return streamInfo.audio.first.url;
  }
}