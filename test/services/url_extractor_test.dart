import 'package:flutter_test/flutter_test.dart';
import 'package:youtube_downloader/services/url_extractor.dart';

void main() {
  test('API for URL Extraction', () async {

    final extractor = new YTExtractor();

    extractor.setVideo("8lM60EdpNBs");

    var s = await extractor.getAudioUrl("8lM60EdpNBs");
    
    print(s.toString());

  });

}