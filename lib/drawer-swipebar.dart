import 'package:youtube_downloader/index.dart';

class SwipeBar extends StatefulWidget {
  
  @override
  _SwipeBarState createState() => _SwipeBarState();
}

class _SwipeBarState extends State<SwipeBar> {
  
  KFDrawerController _drawerController;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _drawerController = KFDrawerController(
      initialPage: ClassBuilder.fromString('Homepage'),
      items: [
        KFDrawerItem.initWithPage(
          text: Text('Home', style: TextStyle(color: Colors.white)),
          icon: Icon(Icons.home, color: Colors.white),
          page: ClassBuilder.fromString('Homepage')
        )
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return KFDrawer(
      controller: _drawerController,
      header: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          width: MediaQuery.of(context).size.width*0.5,
        )
      ),

      footer: KFDrawerItem(
        text: Text(
          "Settings",
          style: TextStyle(
            color: Colors.white
          ),
        ),
        icon: Icon(
          Icons.settings
        ),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color.fromRGBO(255, 255, 255, 1.0), Color.fromRGBO(44, 72, 171, 1.0)],
          tileMode: TileMode.repeated,
        )
      ) 
    );
  }
}