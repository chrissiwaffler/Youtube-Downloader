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

  void initState() {
    super.initState();
    isStart = true;
    _controller = TextEditingController();
    
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  Widget homescreenImage() {
    return Image(image: AssetImage('images/StartscreenBild.png'));
  }

  Widget homescreenText() {
    return Center(
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
    );
  }

  Widget homescreenInputField() {
    return Container(
      color: homescreen_inputfield_color,
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(
          top: 10, left: 20, right: 20, bottom: 10),
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
              border: OutlineInputBorder(
                gapPadding: 3,
                borderRadius: BorderRadius.circular(22),
              ),
              
              filled: true,
              fillColor: Colors.white,

              
              prefixIcon: Icon(Icons.mic),
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                // when you tap on the search item
                onPressed: () {
                  callSearch(_controller.text);
                },
              )
            ),

            // when you click enter on the keyboard
            onFieldSubmitted: (String value) async {
              callSearch(_controller.text);
            },
            

          ),
        )
      
    );
  }

  Widget homescreenColumnONSTART() {
    return Column(children: <Widget>[
      homescreenInputField(),
      SizedBox(height: 50),
      homescreenText(),
      SizedBox(height: 50),
      homescreenImage()
    ]);
  }



  Widget homescreenColumnONSEARCH() {
    return Column(
      children: <Widget>[
        homescreenInputField(),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          alignment: Alignment.centerLeft,
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
        SearchResultsView(10, query).buildView()
      ],
    );
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
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("YouTube",
          textAlign: TextAlign.right,
          style: TextStyle(
            // fontSize: 31,
            fontFamily: "SF Pro Rounded"
            
          ),
          ),
          backgroundColor: Colors.red,
        ),
        backgroundColor: background_app_color,

        drawer: SwipeBar(),

        body: isStart?homescreenColumnONSTART():homescreenColumnONSEARCH()
        

      ),
    );
  }

  void callSearch(String query) {
    print(query);
    // TODO Wiederumändern
    // setState(() {
    //   isStart = false;
    //   this.query = query;
    // });

    // folgende Zeilen wieder entfernen
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => new DownloadPage(title: "Lucid Dreams Juice WRLD", videoID: "mzB1VGEGcSU"),)
    );

  } 



}



