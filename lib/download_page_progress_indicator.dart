import 'package:youtube_downloader/index.dart';

class ProgressIndi extends StatefulWidget {
  ProgressIndi();

  @override
  _ProgressIndiState createState() => _ProgressIndiState();
}

class _ProgressIndiState extends State<ProgressIndi> with SingleTickerProviderStateMixin{

  AnimationController _animationController;
  Animation<Color> _animationColor;

  final Color beginColor = Colors.red;
  final Color endColor = Colors.yellow; 

  @override
  void initState() { 
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1800),
      vsync: this
    );
    _animationColor = _animationController.
      drive(ColorTween(begin: beginColor, end: endColor));
    
    _animationController.repeat();
    
    super.initState(); 
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: MediaQuery.of(context).size.width * 0.9,
      height: 15,
      child: LinearProgressIndicator(
        valueColor: _animationColor,
        backgroundColor: download_page_blue_box_color,
        
      ),
    );
  }
}