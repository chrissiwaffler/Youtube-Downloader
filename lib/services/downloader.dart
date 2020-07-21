import 'dart:io';

import 'package:youtube_downloader/index.dart';
import 'package:path/path.dart' as path;
import 'package:youtube_explode_dart/youtube_explode_dart.dart';


class Downloader {

  YoutubeExplode ytExp;
  VideoId id;

  Downloader(String id) {
    this.ytExp = new YoutubeExplode();
    this.id = new VideoId(id);
  }

  Future<void> downloadVideo(String title, String artist, String album) async {
    print(">> Start Download");
    var video = await ytExp.videos.get(this.id);
    
    // Request permission to write in an external directory.
    // (In this case downloads)
    await Permission.storage.request();

    // Get the streams manifest and the audio track.
    var manifest = await ytExp.videos.streamsClient.getManifest(this.id.toString());
    var audio = manifest.audioOnly.last;

    // TODO for video here
    // var video = manifest.video.first;

    // Build the directory.
    var dir = await DownloadsPathProvider.downloadsDirectory;
    var filePath = path.join(dir.uri.toFilePath(),
        '$title.${audio.container.name}');

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




}

