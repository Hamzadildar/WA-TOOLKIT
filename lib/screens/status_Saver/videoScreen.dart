import 'dart:io';

import 'package:flutter/material.dart';
import 'package:thumbnails/thumbnails.dart';
import 'package:tech_vision/video_play.dart';

final Directory _videoDir =
    Directory('/storage/emulated/0/WhatsApp/Media/.Statuses');

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key key}) : super(key: key);
  @override
  VideoScreenState createState() => VideoScreenState();
}

class VideoScreenState extends State<VideoScreen> {
  @override
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
  Future<String> _getImage(videoPathUrl) async {
    //await Future.delayed(Duration(milliseconds: 500));
    final thumb = await Thumbnails.getThumbnail(
        videoFile: videoPathUrl,
        imageType:
            ThumbFormat.PNG, //this image will store in created folderpath
        quality: 1);
    return thumb;
  }

  bool indicator = false;

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
    final videoList = widget.directory
        .listSync()
        .map((item) => item.path)
        .where((item) => item.endsWith('.mp4'))
        .toList(growable: false);
    if (videoList != null) {
      if (videoList.length > 0) {
        return !indicator
            ? Container(
                // color: Colors.red,
                width: 50,
                height: 50,
                // child: CircularProgressIndicator()
              )
            : Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: GridView.builder(
                  itemCount: videoList.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 100,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlayStatus(
                            videoFile: videoList[index],
                          ),
                        ),
                      ),
                      child: FutureBuilder(
                          future: _getImage(videoList[index]),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasData) {
                                return Hero(
                                  tag: videoList[index],
                                  child: Image.file(
                                    File(snapshot.data),
                                    fit: BoxFit.cover,
                                  ),
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            } else {
                              return Hero(
                                tag: videoList[index],
                                child: SizedBox(
                                  height: 280.0,
                                  child: Image.asset('images/giphy.gif'),
                                ),
                              );
                            }
                          }),
                    );
                  },
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
  }
}
