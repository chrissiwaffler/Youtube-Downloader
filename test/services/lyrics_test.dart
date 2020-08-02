import 'package:flutter_test/flutter_test.dart';
import 'package:youtube_downloader/services/lyrics.dart';


void main() {
  final g = GeniusLyrics();
  g.getGeniusUrl("Lucid Dreams", "Juice Wrld");
}
