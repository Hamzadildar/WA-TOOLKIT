import 'dart:io';
import 'package:flutter/material.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:tech_vision/video_play.dart';

final Directory _videoDir =
    Directory('/storage/emulated/0/WhatsApp/Media/.Statuses');
//Directory dir = Directory('/storage/emulated/0/SaveIt/WhatsApp');
Directory thumbDir = Directory('/storage/emulated/0/.saveit/.thumbs/');

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key key}) : super(key: key);
  @override
  VideoScreenState createState() => VideoScreenState();
}

class VideoScreenState extends State<VideoScreen> {
  @override
  Widget build(BuildContext context) {
    if (!Directory('${_videoDir.path}').existsSync()) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Install WhatsApp\n',
            style: TextStyle(fontSize: 18.0),
          ),
          const Text(
            "Your Friend's Status Will Be Available Here",
            style: TextStyle(fontSize: 18.0),
          ),
        ],
      );
    } else {
      return
          // true
          // ? Container(
          //     color: Colors.red,
          //     width: 50,
          //     height: 50,
          //     child: CircularProgressIndicator())
          // :
          VideoGrid(directory: _videoDir);
    }
  }
}

class VideoGrid extends StatefulWidget {
  final Directory directory;

  const VideoGrid({Key key, this.directory}) : super(key: key);

  @override
  _VideoGridState createState() => _VideoGridState();
}

class _VideoGridState extends State<VideoGrid> {
  // Future<String> _getImage(videoPathUrl) async {
  //   await Future.delayed(Duration(milliseconds: 500));
  //   final thumb = await VideoThumbnail.thumbnailFile(
  //     video: videoPathUrl,
  //     imageFormat: ImageFormat.PNG,
  //   );
  //   // // final thumb = await Thumbnails.getThumbnail(
  //   // //     videoFile: videoPathUrl,
  //   // //     imageType:
  //   // //         ThumbFormat.PNG, //this image will store in created folderpath
  //   // //     quality: 1);
  //   //
  //   return thumb;
  // }

  // Future<void> _downloadFile(String filePath) async {
  //   File originalVideoFile = File(filePath);
  //   String filename =
  //       'WA-${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}${DateTime.now().millisecond}.mp4';
  //   String path = dir.path;
  //   String newFileName = "$path/$filename";
  //
  //   File thumbFile = File(tmpThumbnail);
  //   String thumbname = filename.replaceAll('.mp4', '.jpg');
  //   String newThumbName = '${thumbDir.path}/$thumbname';
  //
  //   await thumbFile.copy(newThumbName);
  //
  //   await originalVideoFile.copy(newFileName);
  // }

  bool indicator = false;
  GlobalKey<ScaffoldState> scaffoldKey;
  String tmpThumbnail;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        indicator = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    try {
      final videoList = widget.directory
          .listSync()
          .map((item) => item.path)
          .where((item) => item.endsWith('.mp4'))
          .toList(growable: false);
      if (videoList != null) {
        if (videoList.length > 0) {
          return Container(
            // padding: EdgeInsets.only(bottom: 3.0),
            //margin: EdgeInsets.all(5.0),
            child: GridView.builder(
              itemCount: videoList.length,
              itemBuilder: (context, index) {
                String videoPath = videoList[index];
                String thumbnailPath = thumbDir.path +
                    '/' +
                    videoPath.substring(45, videoPath.length - 4) +
                    '.png';
                return Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        tmpThumbnail = thumbnailPath;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlayStatus(
                              videoFile: videoList[index],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Stack(
                          children: <Widget>[
                            ProgressiveImage(
                              placeholder:
                                  AssetImage('images/placeholder_video.gif'),
                              thumbnail: FileImage(File(thumbnailPath)),
                              image: FileImage(File(thumbnailPath)),
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(Icons.videocam),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(top: 5.0),
                    //   child: FlatButton(
                    //     child: Text('press me'),
                    //     onPressed: () {
                    //       print(videoList[index]);
                    //       tmpThumbnail = thumbnailPath;
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => PlayStatus(
                    //             videoFile: videoList[index],
                    //           ),
                    //         ),
                    //       );
                    //       scaffoldKey.currentState.showSnackBar(
                    //           mySnackBar(context, 'Video Played'));
                    //     },
                    //   ),
                    // ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 2.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 0.4,
              ),
            ),
          );
        } else {
          return const Center(
            child: Text(
              'Sorry, No Videos Found.',
              style: TextStyle(fontSize: 18.0),
            ),
          );
        }
      } else {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    } catch (exp) {
      return Container(
        child: Center(
          child: Text(
            'Please Allow the Storage Access...',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
  }
}
