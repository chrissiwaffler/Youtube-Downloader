import 'package:youtube_downloader/index.dart';
import 'package:youtube_downloader/secrets/youtube_data_apikey.dart';


class YouTubeData {

  YoutubeAPI ytApi;
  List<YT_API> ytResults;

  YouTubeData(int maxResults) {
    ytApi = new YoutubeAPI(API_KEY, maxResults: maxResults, type: "Video");
  }

  /// new Search with the given query to search via the youtube api
  Future<List> search(String query) async {
    ytResults = await ytApi.search(query);
    return ytResults;
  }

  void setMaxResults(int maxResults) {
    ytApi = new YoutubeAPI(API_KEY, maxResults: maxResults, type: "Video");
  }


  //TODO vllt brauch ich die folgenden Codezeilen gar nicht :/

  /// returning the title of the video with the given index of the video in the previous search
  String getTitle(int indexVideo) {
    return ytResults[indexVideo].title;
  }

  /// returning the title of the channel with the given index of the video in the previous search
  String getChannelTitle(int indexVideo) {
    return ytResults[indexVideo].channelTitle;
  }

  /// get the url of the default quality thumbnail of the video with the given index
  String getImageURL(int indexVideo) {
    return ytResults[indexVideo].thumbnail['default']['url'];
  }

  /// get the url of the video 
  String getVideoURL(int indexVideo) {
    return ytResults[indexVideo].url;
  }

  /// get the description of the video
  String getDescription(int indexVideo) {
    return ytResults[indexVideo].description;
  }

  /// get the id of the video
  String getVideoID(int indexVideo) {
    return ytResults[indexVideo].id;
  }

}