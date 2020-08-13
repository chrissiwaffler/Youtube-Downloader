import 'package:youtube_downloader/index.dart';
import 'package:youtube_downloader/view_download_video_page.dart';

class SearchResultsView extends StatefulWidget {
  
  SearchResultsView(int maxResults, String query, ScrollController sc) {
    ytData = new YouTubeData(maxResults);
    this.query = query;
    _scrollController = sc;
    this.maxResults = maxResults;
  }
  int maxResults;
  String query;
  YouTubeData ytData;

  // Scrollcontroller to check if the end is reached
  ScrollController _scrollController;

  @override
  _SearchResultsViewState createState() => _SearchResultsViewState(maxResults, query, _scrollController);
}

class _SearchResultsViewState extends State<SearchResultsView> {
  
  _SearchResultsViewState(int maxResults, String query, ScrollController sc) {
    ytData = new YouTubeData(maxResults);
    this.query = query;
    _scrollController = sc;
  }



  String query;
  YouTubeData ytData;

  // Scrollcontroller to check if the end is reached
  ScrollController _scrollController;

  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ytData.search(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text("Laden fehlgeschlagen \n Bitte erneut versuchen!");
          } 
          return _listViewBuilder(snapshot.data);
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }


  Widget _listViewBuilder(results) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),

      itemCount: results.length,
      itemBuilder: (BuildContext context, int index) {
        
        // TODO: Add GestureDetector

        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DownloadPage(title: results[index].title, videoID: results[index].id)
            )
          ),


          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            padding: EdgeInsets.all(10),
            height: 140.0,
            // rounded corners and shadow
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(26)),
              boxShadow: [BoxShadow(
                offset: Offset(0, 6),
                color: Color.fromRGBO(0, 0, 0, 0.36),
                blurRadius: 25.0
              )]
            ),
            
            child: Row(
              children: <Widget>[
              
                Image(
                  width: 150.0,
                  image: NetworkImage(results[index].thumbnail['default']['url'])
                ),
                
                Column(
                  children: <Widget>[
                    // Container with Title
                    Container(
                      // make text wrapping; so rest of a text is in a new line
                      width: MediaQuery.of(context).size.width*0.5,
                      child: Text(
                        results[index].title,
                        style: TextStyle(
                          fontFamily: "SF Pro Rounded",
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 18
                        ),
                      ),
                    ),

                    // Container with Description
                    Container(
                      padding: EdgeInsets.only(top: 5),
                      height: MediaQuery.of(context).size.height*0.07,
                      // margin: EdgeInsets.only(bottom: -10),
                      width: MediaQuery.of(context).size.width*0.5,
                      child: Text(
                        results[index].description,
                        style: TextStyle(
                          fontFamily: "SF Pro Rounded",
                          color: Colors.grey[800]
                        )
                      )
                    )
                  ],
                )
              ],

            ),
          ),
        );
      },
    
      controller: _scrollController,
    );
  }

}