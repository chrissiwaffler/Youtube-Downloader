import 'package:flutter_test/flutter_test.dart';
import 'package:youtube_downloader/services/song_title_api.dart';

void main() {
  test('API for Song Metadata', () async {

    final mmd = MusicMetadata();    

    // await mmd.search("Juice Wrld Lucid Dreams (Offical Music Video)");

    await mmd.search("Juice WRLD - Bandit ft. NBA Youngboy");
    print("Title: " + mmd.getTitleName());
    print("Artist Name: " + mmd.getArtistName());
    print("Album Name: "+ mmd.getAlbumName());
  });
}