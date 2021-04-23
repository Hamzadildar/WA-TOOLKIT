import 'package:flutter/material.dart';
import 'package:tech_vision/screens/status_Saver/imageScreen.dart';
import 'package:tech_vision/screens/status_Saver/videoScreen.dart';

class SeeAllStatus extends StatefulWidget {
  static String id = 'seeAll';
  @override
  _SeeAllStatusState createState() => _SeeAllStatusState();
}

class _SeeAllStatusState extends State<SeeAllStatus>
    with TickerProviderStateMixin {
  TabController _nestedTabController;

  @override
  void initState() {
    super.initState();

    _nestedTabController = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _nestedTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff02544b),
        title: Text('WhatsApp Status'),
        bottom: TabBar(
          isScrollable: true,
          labelStyle: TextStyle(fontSize: 20.0),
          controller: _nestedTabController,
          indicatorWeight: 5.0,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black,
          tabs: <Widget>[
            Tab(
              child: Row(
                children: [
                  Icon(Icons.image),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text('Images'),
                ],
              ),
              //  text: "Images",
            ),
            Tab(
              child: Row(
                children: [
                  Icon(Icons.video_label),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text('Videos'),
                ],
              ),
              // text: "Videos",
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.70,
              margin: EdgeInsets.only(left: 16.0, right: 16.0),
              child: TabBarView(
                controller: _nestedTabController,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white70,
                    ),
                    child: ImageScreen(),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white70,
                    ),
                    child: VideoScreen(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
// ListView(
// scrollDirection: Axis.vertical,
// shrinkWrap: true,
// physics: const ClampingScrollPhysics(),
// children: <Widget>[
// GridView.count(
// shrinkWrap: true,
// primary: true,
// padding: const EdgeInsets.all(10.0),
// crossAxisSpacing: 10.0,
// crossAxisCount: 1,
// children: <Widget>[
// ImageScreen(),
// // VideoScreen(),
// ],
// ),
// ],
// ),
