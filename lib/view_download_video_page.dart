import 'package:youtube_downloader/index.dart';

class DownloadPage extends StatefulWidget {
  
  final String title, videoID;
  
  DownloadPage({this.title, this.videoID});

  // DownloadPage(String title, String videoID) {
  //   this.title = title;
  //   this.videoID = videoID;
  // }

  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  
  String title, videoID;

  YoutubePlayerController _controller;

  // _DownloadPageState(String title, String videoID) {
  //   this.title = title;
  //   this.videoID = videoID;
  // }

  TextEditingController txtTitle, txtArtist, txtAlbum;

  MusicMetadata mmd;


  @override
  void initState() { 
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoID,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true
      )
    );

    // TextEditingController for InputFields
    txtTitle = TextEditingController();
    txtArtist = TextEditingController();
    txtAlbum = TextEditingController();

    // Autocompletion of the music metadata
    mmd = MusicMetadata();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            fontFamily: "SF Pro Rounded",
          )
        ),
        backgroundColor: Colors.red,
      ),

      body: SingleChildScrollView( 
        child: Column(
          children: <Widget>[
            watchVideo(),
            metadataContainer(),          
            SizedBox(height: 10),
            downloadContainer(),
            SizedBox(height: 50)
          ],
        ),

        // some physics
        physics: BouncingScrollPhysics()
      ),
    );
  }

  /// returns a widget to watch the given youtube video
  Widget watchVideo() {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
    );
  }

  Widget makeInputFields(String inputDecorationText, TextEditingController txt) {
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 10),

      child: TextFormField(
      
        controller: txt,
        cursorColor: Colors.redAccent,
      
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          labelText: inputDecorationText,
          // suffixText: '$suffix',
          labelStyle: TextStyle(
            fontSize: 17,
            color: Colors.grey[400],


          ),

          border: OutlineInputBorder(
            gapPadding: 3,
            borderRadius: BorderRadius.circular(17),
            borderSide: BorderSide(
              color: Colors.redAccent,
              width: 5
            ),
          ),

        ),

        style: TextStyle(
          fontFamily: "Poppins",
          color: Colors.grey[850]
        ),

      ),
    );
  }

  /// following lines are for editing the metadata
  Widget metadataContainer() {
    return Container(
      margin: EdgeInsets.only(top: 18, left: 10, right: 10),
      padding: EdgeInsets.only(bottom: 20, top: 20, left: 25, right: 25),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Color.fromRGBO(249, 136, 136, 100),
        borderRadius: BorderRadius.circular(34),
        boxShadow: [BoxShadow(
          offset: Offset(0, 3), 
          color: Color.fromRGBO(0, 0, 0, 0.16),
          blurRadius: 6
        )]
      ),
      child: Column(
        children: <Widget>[
          // text
          Text(
            "Eingabe der Metadata",
            style: TextStyle(
              fontSize: 25,
              fontFamily: "SF Pro Rounded",
              color: Colors.white,
              fontWeight: FontWeight.w600
            )
          ),
          SizedBox(height: 20),
          // input field for title
          makeInputFields("Title", txtTitle),
          SizedBox(height: 10),
          // input field for artist name
          makeInputFields("Artist Name", txtArtist),
          SizedBox(height: 10),
          makeInputFields("Album Name", txtAlbum),
          SizedBox(height: 10),
          autoCompleteButton()
          

        ],
      )
    );
  }

  Widget autoCompleteButton() {
    return RaisedButton(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),

      ),
      child: Text(
        "Auto-Complete",
        style: TextStyle(
          fontSize: 16,
          fontFamily: "SF Pro Rounded", 
          fontWeight: FontWeight.w600,
          color: download_page_button_color
        ),
        
      ),
      
      // calling the MusicMetadata to complete the metadata
      onPressed: () async {
        await mmd.search(widget.title);
        String title = mmd.getTitleName();
        String artist = mmd.getArtistName();
        String album = mmd.getAlbumName();
        
        print(">> Auto-Complete of Metadata:");
        print(" > Title: " + title);
        print(" > Artist: " + artist);
        print(" > Album: " + album);

        setState(() {
          txtTitle.text = title;
          txtArtist.text = artist;
          txtAlbum.text = album;
        });
      },
      
      
    );
  }


  /// following lines are for the download functionality
  Widget downloadContainer() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 10, right: 10),
      padding: EdgeInsets.only(bottom: 20, top: 20, left: 10, right: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background_app_color,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [BoxShadow(
          offset: Offset(0, 3), 
          color: Color.fromRGBO(0, 0, 0, 0.16),
          blurRadius: 6
        )]
      ),

      child: Column(
        children: <Widget>[
          Text(
            "Download",
            style: TextStyle(
              fontSize: 25,
              fontFamily: "SF Pro Rounded",
              color: Colors.white,
              fontWeight: FontWeight.w600
            )
          ),
          
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              downloadAudioButton(),
              downloadVideoButton()
            ],

            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
          
        ],
      )
    );
  }

  Widget downloadAudioButton() {
    return RaisedButton(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),

      ),
      child: Text(
        "als Audio",
        style: TextStyle(
          fontSize: 22,
          fontFamily: "SF Pro Rounded",
          fontWeight: FontWeight.w600,
          color: download_page_button_color
        )
      ),

      onPressed: () {
        print("Download Audio");
        // TODO Implementation of download audio

      },
    );
  }

  Widget downloadVideoButton() {
    return RaisedButton(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),

      ),
      child: Text(
        "als Video",
        style: TextStyle(
          fontSize: 22,
          fontFamily: "SF Pro Rounded",
          fontWeight: FontWeight.w600,
          color: download_page_button_color
        )
      ),

      onPressed: () async {
        print("Download Video"); 
        //TODO Implementation of download video

        var d = Downloader(widget.videoID);
        await d.downloadVideo(txtTitle.text, txtArtist.text, txtAlbum.text);

        // Show that the file was downloaded.
        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                  'Download completed and saved to: Downloads'),
            );
          },
        );
      },
    );
  }
}