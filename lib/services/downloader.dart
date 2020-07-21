import 'dart:io';

import 'package:youtube_downloader/index.dart';
import 'package:path/path.dart' as path;
import 'package:youtube_explode_dart/youtube_explode_dart.dart';


class Downloader {

  YoutubeExplode ytExp;
  VideoId id;

  String musicFileEnding, videoFileEnding;

  Downloader(String id) {
    this.ytExp = new YoutubeExplode();
    this.id = new VideoId(id);
    
    // default values
    musicFileEnding = "mp3";
    videoFileEnding = "mp4";
  }



  Future<void> downloadVideo(String title, String artist, String album) async {
    print(">> Start Download");
    var v = await ytExp.videos.get(this.id);
    
    // Request permission to write in an external directory.
    // (In this case downloads)
    await Permission.storage.request();

    // Get the streams manifest and the audio track.
    var manifest = await ytExp.videos.streamsClient.getManifest(this.id.toString());
    var video = manifest.video.first;

    // TODO for video here
    // var video = manifest.video.first;

    // Build the directory.
    var dir = await DownloadsPathProvider.downloadsDirectory;
    // create a new Directory to save all Youtube Downloader files
    var newDir;
    await new Directory(dir.path + "/Youtube Downloader Video/").create(recursive: true)
      .then((Directory d) {
        newDir = d;
      });

    var filePath = path.join(newDir.uri.toFilePath(),
        '$title.$videoFileEnding');

    // Open the file to write.
    var file = File(filePath);
    var fileStream = file.openWrite();

    // Pipe all the content of the stream into our file.
    await ytExp.videos.streamsClient.get(video).pipe(fileStream);

    // TODO Here implementation of a % of download possible

    // Close the file.
    await fileStream.flush();
    await fileStream.close();

    // TODO show finished
    // // Show that the file was downloaded.
    // await showDialog(
    //   context: context,
    //   builder: (context) {
    //     return AlertDialog(
    //       content: Text(
    //           'Download completed and saved to: ${filePath}'),
    //     );
    //   },
    // );

    print(">> Download finished");
  }



  Future<void> downloadMusic(String title, String artist, String album) async {
    print(">> Start Download");
    var video = await ytExp.videos.get(this.id);
    
    // Request permission to write in an external directory.
    // (In this case downloads)
    await Permission.storage.request();

    // Get the streams manifest and the audio track.
    var manifest = await ytExp.videos.streamsClient.getManifest(id);
    var audio = manifest.audioOnly.last;

    // TODO for video here
    // var video = manifest.video.first;

    // Build the directory.
    var dir = await DownloadsPathProvider.downloadsDirectory;
    var newDir;
    await new Directory(dir.path + "/Youtube Downloader Music/").create(recursive: true)
      .then((Directory d) {
        newDir = d;
      });

    var filePath = path.join(newDir.uri.toFilePath(),
        '$title.$musicFileEnding');
    
    // Open the file to write.
    var file = File(filePath);
    var fileStream = file.openWrite();

    // Pipe all the content of the stream into our file.
    await ytExp.videos.streamsClient.get(audio).pipe(fileStream);

    // TODO Here implementation of a % of download possible

    // Close the file.
    await fileStream.flush();
    await fileStream.close();

    // TODO show finished
    // // Show that the file was downloaded.
    // await showDialog(
    //   context: context,
    //   builder: (context) {
    //     return AlertDialog(
    //       content: Text(
    //           'Download completed and saved to: ${filePath}'),
    //     );
    //   },
    // );

    print(">> Download finished");
  }


  // Future<void> init() async {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   await FlutterDownloader.initialize(
  //     debug: true
  //   );

    // download
  


  /// set new ending for music file e.g. mp3, wav or webm
  /// without the .
  void setMusicFileEnding(String musicFileEnding) {
    if (musicFileEnding.contains(".")) {
      musicFileEnding.replaceFirst(".", "");
    }

    this.musicFileEnding = musicFileEnding;
  }

  String getMusicFileEnding() {
    return musicFileEnding;
  }

  /// set the new ending for video file e.g. mp4, webm or wmv
  void setVideoFileEnding(String videoFileEnding) {
    if (videoFileEnding.contains(".")) {
      videoFileEnding.replaceFirst(".", "");
    }
    this.videoFileEnding = videoFileEnding;
  }


  String getVideoFileEnding() {
    return videoFileEnding;
  }



}

