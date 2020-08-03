import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart';
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

  Future _checkPermissions() async {
    // Request permission to write in an external directory.
    // (In this case downloads)
    if (!await Permission.storage.request().isGranted) {
      await _checkPermissions();
    }
}

  String checkTitle(String title) {
    title = title.replaceAll(r'\', '')
      .replaceAll('/', '')
      .replaceAll('*', '')
      .replaceAll('?', '')
      .replaceAll('"', '')
      .replaceAll('<', '')
      .replaceAll('>', '')
      .replaceAll('|', '');
    return title;
  }

  Future<void> downloadVideo(String title, String artist, String album) async {
    print(">> Start Download");
    _checkPermissions();

    var v = await ytExp.videos.get(this.id);
  
    // Get the streams manifest and the audio track.
    var manifest = await ytExp.videos.streamsClient.getManifest(this.id.toString());
    var video = manifest.video.first;

    // Build the directory.
    var dir = await DownloadsPathProvider.downloadsDirectory;
    // create a new Directory to save all Youtube Downloader files
    var newDir;
    await new Directory(dir.path + "/Youtube Downloader Video/").create(recursive: true)
      .then((Directory d) {
        newDir = d;
      });

    title = checkTitle(title);

    var filePath = path.join(newDir.uri.toFilePath(),
        '$title.${video.container.name.toString()}');

    // Open the file to write.
    var file = File(filePath);
    var fileStream = file.openWrite();

    // Pipe all the content of the stream into our file.
    await ytExp.videos.streamsClient.get(video).pipe(fileStream);

    // TODO Here implementation of a % of download possible

    // Close the file.
    await fileStream.flush();
    await fileStream.close();

    if (video.container.name.toString() != videoFileEnding) {
      // Use FFmpeg to convert to .mp4
      String outputPath = path.join(newDir.uri.toFilePath(),
        '$title.$videoFileEnding');
      
      var command = "-i \"$filePath\" \"$outputPath\"";
      await FlutterFFmpeg().execute(command)
        .then((rc) => print("FFmpeg process exited with rc $rc"));
      
      file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    }

    // TODO übermehmen aus Musik
    // editMetadata(filePath.toString(), title, artist, album);


    print(">> Download finished");  
  }

  Future<void> downloadMusic(String title, String artist, String album, String albumCoverLink) async {
    print(">> Start Download");
    _checkPermissions();

    var video = await ytExp.videos.get(this.id);
  
    // Get the streams manifest and the audio track.
    var manifest = await ytExp.videos.streamsClient.getManifest(id);
    var audio = manifest.audioOnly.last;

    // Build the directory.
    var dir = await DownloadsPathProvider.downloadsDirectory;
    var newDir;
    await new Directory(dir.path + "/Youtube Downloader Music/").create(recursive: true)
      .then((Directory d) {
        newDir = d;
      });

    title = checkTitle(title);

    var filePath = path.join(newDir.uri.toFilePath(),
        '$title.${audio.container.name.toString()}');
    
    // Open the file to write.
    var file = File(filePath);
    var fileStream = file.openWrite();

    // Pipe all the content of the stream into our file.
    await ytExp.videos.streamsClient.get(audio).pipe(fileStream);

    // TODO Here implementation of a % of download possible

    // Close the file.
    await fileStream.flush();
    await fileStream.close();

    if (audio.container.name.toString() != musicFileEnding) {
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

      filePath = outputPath;
    }

    await editMetadata(filePath.toString(), title, artist, album, albumCoverLink);

    print(">> Download finished");
  }


  Future<void> editMetadata(String pathFile, String title, String artist, String album, String albumCoverLink) async {
    
    // downloads the image of the album cover 
    String artworkPath;
    if (albumCoverLink != "" || albumCoverLink == null) {
      
      try {
        // Saved with this method.
        var imageId = await ImageDownloader.downloadImage(albumCoverLink, destination: AndroidDestinationType.directoryDownloads
          ..subDirectory("/Youtube Downloader Music/artworks/artwork.jpg"));
        
        if (imageId == null) {
          return;
        }
        artworkPath = await ImageDownloader.findPath(imageId);
      } on PlatformException catch (error) {
        print(error);
      }
    }
    else {
      artworkPath = null;
    }
    
    final mde = MetadataEditor();
    await mde.setTags(pathFile, title, artist, album, artworkPath);

    if (artworkPath != null) {
      var file = File(artworkPath);
      await file.delete();
    }
  }

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

