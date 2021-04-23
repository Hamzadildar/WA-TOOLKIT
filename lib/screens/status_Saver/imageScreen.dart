import 'dart:io';
import 'package:flutter/material.dart';
import 'viewphotos.dart';

final Directory _photoDir =
    Directory('/storage/emulated/0/WhatsApp/Media/.Statuses');

class ImageScreen extends StatefulWidget {
  const ImageScreen({Key key}) : super(key: key);
  @override
  ImageScreenState createState() => ImageScreenState();
}

class ImageScreenState extends State<ImageScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!Directory('${_photoDir.path}').existsSync()) {
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
      try {
        final imageList = _photoDir
            .listSync()
            .map((item) => item.path)
            .where((item) => item.endsWith('.jpg') || item.endsWith('.png'))
            .toList(growable: false);
        if (imageList.length > 0) {
          return Container(
            margin: const EdgeInsets.only(left: 1, right: 1),
            child: GridView.builder(
              scrollDirection: Axis.vertical,
              itemCount: imageList.length,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 100,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final imgPath = imageList[index];
                return Material(
                  elevation: 8.0,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewPhotos(
                            imgPath: imgPath,
                          ),
                        ),
                      );
                    },
                    child: Hero(
                      tag: imgPath,
                      child: Image.file(
                        File(imgPath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: Container(
                  padding: const EdgeInsets.only(bottom: 60.0),
                  child: const Text(
                    'Sorry, No Image Found!',
                    style: TextStyle(fontSize: 18.0),
                  )),
            ),
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
}
