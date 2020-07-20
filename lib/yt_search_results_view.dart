import 'package:youtube_downloader/index.dart';

class SearchResultsView {
  SearchResultsView(int maxResults, String query) {
    ytData = new YouTubeData(maxResults);
    this.query = query;
  }

  String query;
  YouTubeData ytData;

  
  Widget buildView() {
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
      physics: const AlwaysScrollableScrollPhysics(),

      itemCount: results.length,
      itemBuilder: (BuildContext context, int index) {
        
        // TODO: Add GestureDetector

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          padding: EdgeInsets.all(10.0),
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
              )
            ],
          ),
        );
      },
    );
  }

}