import 'package:flutter_test/flutter_test.dart';
import 'package:youtube_downloader/services/youtube_data.dart';

void main() {
  test('API for Youtube DATA', () async {
    final ytData = new YouTubeData(5);


    var results = await ytData.search("Lucid Dreams");

    print(results[0].title);
    print(results[0].channelTitle);
    print(results[0].description);
    
  });
}