import 'package:http/http.dart';
import 'package:youtube_downloader/index.dart';
import 'package:youtube_downloader/private/genius_apikey.dart';

/// using the Genius API
class GeniusLyrics {

  static const String base_url = "https://genius.p.rapidapi.com/search";

  Map<String, String> headers;

  GeniusLyrics() {
    headers = {
      'x-rapidapi-host': "genius.p.rapidapi.com",
      'x-rapidapi-key': API_KEY
    };
  }

  Future <String> getGeniusUrl(String songTitle, String artistName) async {
    print("Lyrics of song via Genius API has started ... ");
    
    /// Doesnt work with http.client

    // final client = http.Client();
    // final request = http.Request('GET', Uri.parse(base_url+"?q=Lucid+Dreams+Juice+Wrld"));
    // final response = await client.send(request);
    // print(response.statusCode);
    // response.stream.listen((_) {}).cancel();

    /////////////// ############################
    ///https://rapidapi.com/canarado/api/canarado-lyrics is a good API for lyrics
    /// vllt noch nach jedem . ? ! : neue Zeile einfügen
    /// #############################/// #############################/// #############################



    // final response = await http.get(
    //   base_url + "q=Lucid+Dreams+Juice+Wrld",
    //   headers: headers,      
    // );

    // final data = json.decode(response.body)["hits"];
    // print(data.toString());

    

  }

}