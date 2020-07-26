import 'package:flutter_test/flutter_test.dart';
import 'package:youtube_downloader/services/song_title_api.dart';

void main() {
  test('API for Song Metadata', () async {

    final mmd = MusicMetadata();    

    // await mmd.search("Juice Wrld Lucid Dreams (Offical Music Video)");

    await mmd.search("DaBaby - Rockstar feat. Roddy Ricch");
    print("Title: " + mmd.getTitleName());
    print("Artist Name: " + mmd.getArtistName());
    print("Album Name: "+ mmd.getAlbumName());

    final mmd2 = MusicMetadata();
    await mmd2.search("DaBaby - Rockstar feat. Roddy Ricch (Official Music Video)");
    print("Title: " + mmd2.getTitleName());
    print("Artist Name: " + mmd2.getArtistName());
    print("Album Name: "+ mmd2.getAlbumName());
  });
}