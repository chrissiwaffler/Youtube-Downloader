import 'package:audiotagger/audiotagger.dart';
import 'package:youtube_downloader/index.dart';
import 'package:audiotagger/models/tag.dart';

class MetadataEditor2 {
  // https://pub.dev/packages/audiotagger

  Audiotagger tagger;

  MetadataEditor2() {
    tagger = new Audiotagger();
  }
  
  Future _checkPermissions() async {
    // Request permission to write in an external directory.
    // (In this case downloads)
    if (!await Permission.storage.request().isGranted) {
      await _checkPermissions();
    }
  }

  Future<void> setTags2(String filePath, String title, String artist, String album) async {
    final tags = <String, String> {
      "title": title,
      "artist": artist,
      "album": album,
      "genre": null,
    };
    _checkPermissions();
    
    // final filePath = "//storage//emulated//0//Download//Youtube Downloader Music//Conversations.mp3";
    final result = await tagger.writeTagsFromMap(path: filePath, tags: tags);
    print("Schreiben: " + result.toString());
  }

  Future<void> setTags(String filePath, String title, String artist, String album) async {
    Tag tags = Tag(
      title: title,
      artist: artist,
      album: album
    );
    
    final result = await tagger.writeTags(path: filePath, tag: tags);
    print("Schreiben: " + result.toString());
  }

}
