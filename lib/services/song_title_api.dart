import 'package:youtube_downloader/index.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_downloader/private/deezer_apikey.dart';

/* using the Deezer API */
class MusicMetadata {

  static const String base_url = "https://deezerdevs-deezer.p.rapidapi.com/search?";

  Map<String, String> headers;

  String title, artist, album, genre;
  int year;

  String albumCoverLink;

  MusicMetadata() {
    headers = {
      'x-rapidapi-host': "deezerdevs-deezer.p.rapidapi.com",
      'x-rapidapi-key': API_KEY
    };
  }

  Future<void> search(String yt_title) async {
    print("Search for metadata of music has started ... ");

    if (yt_title.contains("(")) {
      var parts = yt_title.split("(");
      assert(parts[0] != '(' && parts[0] != ')');

      yt_title = parts[0];

      print("Splitting wurde angewendet: \n >> neuer Titel: " + parts[0]);
    }

    String keyWordFt = " ft";
    String keyWordFt2 = " feat";
    if (yt_title.contains(keyWordFt2)) {
      keyWordFt = keyWordFt2;
    }
    if (yt_title.contains(keyWordFt)) {
      var parts = yt_title.split(keyWordFt);
      assert(!parts[0].contains(keyWordFt));

      yt_title = parts[0];
      print("neues Splitting wurde angewendet: \n >> neuer Titel: " + yt_title);
    }

    final response = await http.get(
      base_url + "q=" + yt_title,
      headers: headers
    );

    final data = json.decode(response.body)["data"];

    if (data.isNotEmpty) {
      //print("data "+ data[0]);
      title = data[0]["title"];
      artist = data[0]["artist"]["name"];
      album = data[0]["album"]["title"];

      // using 'big' quality
      albumCoverLink = data[0]["album"]["cover_big"];
      print(title + " | " + artist + " | " + album);

      print(albumCoverLink);
    }
  }

  /// Methods to get the MetaData out of the API
  String getArtistName() {
    return artist;
  }

  String getTitleName() {
    return title;
  }

  String getAlbumName() {
    return album;
  }

  String getAlbumCoverLink() {
    return albumCoverLink;
  }
}