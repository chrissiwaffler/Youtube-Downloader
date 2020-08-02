import 'dart:io';

import 'package:youtube_downloader/index.dart';
import 'package:path/path.dart' as path;
import 'package:youtube_downloader/services/metadata_editor2.dart';
import 'package:youtube_downloader/services/metadata_editor3.dart';
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

  Future _checkPermissions() async {
    // Request permission to write in an external directory.
    // (In this case downloads)
    if (!await Permission.storage.request().isGranted) {
      await _checkPermissions();
    }
}



  Future<void> downloadVideo(String title, String artist, String album) async {
    print(">> Start Download");
    _checkPermissions();

    var v = await ytExp.videos.get(this.id);
  
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


    // TODO übermehmen aus Musik
    // editMetadata(filePath.toString(), title, artist, album);


    print(">> Download finished");  
  }

  Future<void> downloadMusic(String title, String artist, String album) async {
    print(">> Start Download");
    _checkPermissions();

    var video = await ytExp.videos.get(this.id);
  

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

    title = title.replaceAll(r'\', '')
      .replaceAll('/', '')
      .replaceAll('*', '')
      .replaceAll('?', '')
      .replaceAll('"', '')
      .replaceAll('<', '')
      .replaceAll('>', '')
      .replaceAll('|', '');

    var filePath = path.join(newDir.uri.toFilePath(),
        '$title.${audio.container.name.toString()}');

    // var filePath = path.join(newDir.uri.toFilePath(),
    // '$title.$musicFileEnding');
    
    // Open the file to write.
    var file = File(filePath);
    var fileStream = file.openWrite();

    // Pipe all the content of the stream into our file.
    await ytExp.videos.streamsClient.get(audio).pipe(fileStream);

    // TODO Here implementation of a % of download possible


    // TODO remove if unused
    // file = await editMetadata(file, filePath.toString(), title, artist, album);



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
    // );s
  
    // Use FFmpeg to convert to .mp3
    String outputPath = path.join(newDir.uri.toFilePath(),
      '$title.$musicFileEnding'); 

    var command = "-i \"$filePath\" -vn -ab 128k -ar 44100 -y -codec:a libmp3lame -qscale:a 2 \"$outputPath\"";
    await FlutterFFmpeg().execute(command)
      .then((rc) => print("FFmpeg process exited with rc $rc"));

    file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }



    // await editMetadata2(filePath.toString(), title, artist, album);
    
    // var stream = file.openWrite(mode: FileMode.append);
    await editMetadata2(outputPath.toString(), title, artist, album);
    // await stream.close();
    print(">> Download finished");
  }


  // modify the tags of the downloaded music file
  // Future<File> editMetadata(File file, String pathFile, String title, String artist, String album) async {
  //   MetadataEditor mde = MetadataEditor(pathFile);
  //   return await mde.setMetadata(file, title, artist, album);
  // }

  Future<void> editMetadata2(String pathFile, String title, String artist, String album) async {
    final mde = MetadataEditor2();
    await mde.setTags(pathFile, title, artist, album);
  }

  Future <void> editMetadata3(String pathFile, String title, String artist, String album) async {
    await MetadataEditor3().setMetadata(pathFile, title, artist, album);
    await MetadataEditor3().printMetadata(pathFile);
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

