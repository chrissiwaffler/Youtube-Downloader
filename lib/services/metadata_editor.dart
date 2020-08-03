import 'package:audiotagger/audiotagger.dart';
import 'package:http/http.dart';
import 'package:youtube_downloader/index.dart';
import 'package:audiotagger/models/tag.dart';

class MetadataEditor {
  // https://pub.dev/packages/audiotagger

  Audiotagger tagger;

  MetadataEditor() {
    tagger = new Audiotagger();
  }
  
  Future _checkPermissions() async {
    // Request permission to write in an external directory.
    // (In this case downloads)
    if (!await Permission.storage.request().isGranted) {
      await _checkPermissions();
    }
  }

  Future<void> setTags(String filePath, String title, String artist, String album, String artworkPath) async {    
    Tag tags = Tag(
      title: title,
      artist: artist,
      album: album,
      artwork: artworkPath
    );
    
    final result = await tagger.writeTags(path: filePath, tag: tags);
    print("Schreiben: " + result.toString());
  }
}
