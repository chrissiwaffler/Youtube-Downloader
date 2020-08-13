import 'package:youtube_downloader/index.dart';


class Homepage extends StatefulWidget {
  Homepage({Key key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  
  // controller for controlling the texfield
  // also need to add the methods 'initState' and 'dispose'
  TextEditingController _controller;


  bool isStart;
  String query;

  // determines whether the TextInputField should be in focus
  bool focusInputField;

  // Scrollcontroller to check if the end is reached
  ScrollController _scrollController;
  int numSearchResults;

  void initState() {
    super.initState();
    isStart = true;
    _controller = TextEditingController();
    
    focusInputField = false;

    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    numSearchResults = 10;

  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  Widget homescreenImage() {
    return Image(image: AssetImage('images/StartscreenBild.png'));
  }

  Widget homescreenText() {
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        // color: Colors.white,
        decoration: new BoxDecoration(
          color: Colors.white,         
          borderRadius: BorderRadius.all(Radius.circular(26)),
          boxShadow: [BoxShadow(
            offset: Offset(10, 10),
            color: Color.fromRGBO(0, 0, 0, 0.16),
            blurRadius: 30.0
          )]
        ),
        
        child: Text(
          "Kostenloser Musik- \nund Videodownload", 
          style: TextStyle(
            fontFamily: "SF Pro Rounded",
            fontSize: 31,
            color: homescreen_text_color,
            // medium font weight
            fontWeight: FontWeight.w500
          )
        ),

        constraints: BoxConstraints.expand(width: MediaQuery.of(context).size.width - 50, height: MediaQuery.of(context).size.width/2)
      ),

      // tap on the text focuses the TextInputField
      onTap: () {
        setState(() {
          focusInputField = true;
          // TODO doesnt work right 
          // https://flutter.dev/docs/cookbook/forms/focus#focus-a-text-field-when-a-button-is-tapped
          print(focusInputField);
        });
      },
    );
  }

  Widget homescreenInputField() {
    return Container(
      color: homescreen_inputfield_color,
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(
          top: 10, left: 20, right: 20, bottom: 10),
          child: Container(
            child: TextFormField(
              controller: _controller,
              textAlign: TextAlign.center,
              cursorColor: Colors.redAccent,
              decoration: InputDecoration(
                // labelText: "Suche",
                labelStyle: TextStyle(
                  color: Colors.grey,
                  fontFamily: "SF Pro Rounded"
                ),
                // use hintText so the pre text is in the middle
                hintText: "Suche Youtube Videos",
                
                // different border styles:

                // cursor in border is active
                focusedBorder: OutlineInputBorder(
                  gapPadding: 3,
                  borderRadius: BorderRadius.circular(22),
                  borderSide: BorderSide(
                    color: Colors.redAccent,
                    width: 3
                  ) 
                ),

                // style for normal, not-focused border
                enabled: true,
                enabledBorder: OutlineInputBorder(
                  gapPadding: 3,
                  borderRadius: BorderRadius.circular(22),
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 0
                  )
                ),


                filled: true,
                fillColor: Colors.white,

                
                prefixIcon: IconButton(
                  icon: Icon(
                    Icons.mic,
                    color: Colors.red[300],
                  ),
                  onPressed: () {
                    // TODO
                  },

                  padding: EdgeInsets.only(left: 10),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.red[300],
                  ),

                  // when you tap on the search item
                  onPressed: () {
                    callSearch(_controller.text);
                  },

                  padding: EdgeInsets.only(right: 10),
                )
              ),

              // when you click enter on the keyboard
              onFieldSubmitted: (String value) async {
                callSearch(_controller.text);
              },
              
              autofocus: focusInputField,

            ),
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(
                offset: Offset(5, 5),
                color: Color.fromRGBO(0, 0, 0, 0.16),
                blurRadius: 15
              )]
            ),
          ),
      ),
      
    );
  }

  // one of the two following widgets is used 
  Widget homescreenColumnONSTART() {
    // use SingleChildScrollView to avoid overflowing
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          homescreenInputField(),
          SizedBox(height: 50),
          homescreenText(),
          SizedBox(height: 50),
          homescreenImage(),
          SizedBox(height: 50)
        ]
      ),

      physics: BouncingScrollPhysics(),
    );
  }

  Widget homescreenColumnONSEARCH() {
    return Column(
        children: <Widget>[
          homescreenInputField(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            alignment: Alignment.center,
            child: Text(
              "Suchergebnisse",
              style: TextStyle(
                fontFamily: "SF Pro Rounded",
                fontSize: 31,
                color: homescreen_text_color,
                fontWeight: FontWeight.w500
              ),
            ),
          ),

          // YT Search Results in shape of a list
          Flexible(child: SearchResultsView(numSearchResults, query, _scrollController))
        ],
    );
  }

  _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      
      // TODO maybe animation something :D
      // setState(() async {
      //   print("reach the bottom");
      //   await _scrollController.animateTo(MediaQuery.of(context).size.height + 300 * numSearchResults,
      //     curve: Curves.linear, 
      //     duration: Duration (milliseconds: 500));
      // });

    }
    
    if (numSearchResults < 100) {
      numSearchResults += 10;
    }    
  }

  /// Vorlage aus vorherigen Verisionen
  Widget makeInputFields(String inputDecorationText, TextEditingController txt) {
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 10),

      child: TextFormField(

        controller: txt,
        cursorColor: Colors.redAccent,
        decoration: InputDecoration(

          labelText: inputDecorationText,
          // suffixText: '$suffix',
          labelStyle: TextStyle(
            fontSize: 17,
            color: Colors.blue

          ),

          border: OutlineInputBorder(
            gapPadding: 3,
            borderRadius: BorderRadius.circular(22),

            borderSide: BorderSide(
              color: Colors.blueAccent,
              width: 2
            ),

          ),

        ),

        style: TextStyle(
          fontFamily: "Poppins",
          color: Colors.blueAccent
        ),

      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Youtube Downloader",
          textAlign: TextAlign.center,
          style: TextStyle(
            // fontSize: 31,
            fontFamily: "SF Pro Rounded"
            
          ),
        ),
        backgroundColor: Colors.red,
      ),
      backgroundColor: background_app_color,
      // drawer: SwipeBar(),
      body: isStart?homescreenColumnONSTART():homescreenColumnONSEARCH(),
    );
  }

  void callSearch(String query) {
    print(query);
    // TODO Wiederumändern
    setState(() {
      isStart = false;
      this.query = query;
    });

    // folgende Zeilen wieder entfernen
    // Navigator.of(context).push(
    //   MaterialPageRoute(builder: (context) => new DownloadPage(title: "Lucid Dreams Juice WRLD", videoID: "mzB1VGEGcSU"),)
    // );

  } 



}



