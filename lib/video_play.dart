import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_fab_dialer/flutter_fab_dialer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

import 'video_controller.dart';

class PlayStatus extends StatefulWidget {
  final String videoFile;
  const PlayStatus({
    Key key,
    this.videoFile,
  }) : super(key: key);
  @override
  _PlayStatusState createState() => _PlayStatusState();
}

class _PlayStatusState extends State<PlayStatus> {
  @override
  void initState() {
    super.initState();
    print('Video file you are looking for:' + widget.videoFile);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onLoading(bool t, String str) {
    if (t) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return SimpleDialog(
              children: <Widget>[
                Center(
                  child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: const CircularProgressIndicator()),
                ),
              ],
            );
          });
    } else {
      Navigator.pop(context);
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SimpleDialog(
                children: <Widget>[
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: <Widget>[
                          const Text(
                            'Great, Saved in Gallary',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                          ),
                          Text(str,
                              style: const TextStyle(
                                fontSize: 16.0,
                              )),
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                          ),
                          const Text('FileManager > wa_status_saver',
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.teal)),
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                          ),
                          MaterialButton(
                            child: const Text('Close'),
                            color: Colors.teal,
                            textColor: Colors.white,
                            onPressed: () => Navigator.pop(context),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _fabMiniMenuItemList = [
      FabMiniMenuItem.withText(
          const Icon(Icons.sd_storage), Colors.teal, 4.0, 'Button menu',
          () async {
        _onLoading(true, '');

        final originalVideoFile = File(widget.videoFile);
        final directory = await getExternalStorageDirectory();
        print('directory: $directory');
        if (!Directory('/storage/emulated/0/wa_status_saver').existsSync()) {
          Directory('/storage/emulated/0/wa_status_saver')
              .createSync(recursive: true);
        }
        // final path = directory.path;
        final curDate = DateTime.now().toString();
        final newFileName =
            '/storage/emulated/0/wa_status_saver/VIDEO-$curDate.mp4';
        print(newFileName);
        await originalVideoFile.copy(newFileName);

        _onLoading(
          false,
          'If Video not available in gallary\n\nYou can find all videos at',
        );
      }, 'Save', Colors.black, Colors.white, true),
      FabMiniMenuItem.withText(const Icon(Icons.share), Colors.teal, 4.0,
          'Button menu', () {}, 'Share', Colors.black, Colors.white, true),
      FabMiniMenuItem.withText(const Icon(Icons.reply), Colors.teal, 4.0,
          'Button menu', () {}, 'Repost', Colors.black, Colors.white, true),
      FabMiniMenuItem.withText(const Icon(Icons.wallpaper), Colors.teal, 4.0,
          'Button menu', () {}, 'Set As', Colors.black, Colors.white, true),
      FabMiniMenuItem.withText(
          const Icon(Icons.delete_outline),
          Colors.teal,
          4.0,
          'Button menu',
          () {},
          'Delete',
          Colors.black,
          Colors.white,
          true),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: StatusVideo(
        videoPlayerController:
            VideoPlayerController.file(File(widget.videoFile)),
        looping: true,
        videoSrc: widget.videoFile,
      ),
      // ),
      floatingActionButton:
          FabDialer(_fabMiniMenuItemList, Colors.teal, const Icon(Icons.add)),
    );
  }
}
