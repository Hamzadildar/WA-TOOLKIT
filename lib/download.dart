// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:ext_storage/ext_storage.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);
//
//   final String title;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   Future _futureGetPath;
//   List<dynamic> listImagePath = List<dynamic>();
//   var _permissionStatus;
//
//   @override
//   void initState() {
//     super.initState();
//     _listenForPermissionStatus();
//     // Declaring Future object inside initState() method
//     // prevents multiple calls inside stateful widget
//     _futureGetPath = _getPath();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: <Widget>[
//           Expanded(
//             flex: 1,
//             child: FutureBuilder(
//               future: _futureGetPath,
//               builder: (BuildContext context, AsyncSnapshot snapshot) {
//                 if (snapshot.hasData) {
//                   var dir = Directory(snapshot.data);
//                   print('permission status: $_permissionStatus');
//                   if (_permissionStatus) _fetchFiles(dir);
//                   return Text(snapshot.data);
//                 } else {
//                   return Text("Loading");
//                 }
//               },
//             ),
//           ),
//           Expanded(
//             flex: 19,
//             child: GridView.count(
//               primary: false,
//               padding: const EdgeInsets.all(20),
//               crossAxisSpacing: 10,
//               mainAxisSpacing: 10,
//               crossAxisCount: 3,
//               children: _getListImg(listImagePath),
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   // Check for storage permission
//   void _listenForPermissionStatus() async {
//     final status = await Permission.storage.request().isGranted;
//     // setState() triggers build again
//     setState(() => _permissionStatus = status);
//   }
//
//   // Get storage path
//   // https://pub.dev/documentation/ext_storage/latest/
//   Future<String> _getPath() {
//     return ExtStorage.getExternalStoragePublicDirectory(
//         ExtStorage.DIRECTORY_DOWNLOADS);
//   }
//
//   _fetchFiles(Directory dir) {
//     List<dynamic> listImage = List<dynamic>();
//     dir.list().forEach((element) {
//       RegExp regExp =
//           new RegExp("\.(gif|jpe?g|tiff?|png|webp|bmp)", caseSensitive: false);
//       // Only add in List if path is an image
//       if (regExp.hasMatch('$element')) listImage.add(element);
//       setState(() {
//         listImagePath = listImage;
//       });
//     });
//   }
//
//   List<Widget> _getListImg(List<dynamic> listImagePath) {
//     List<Widget> listImages = List<Widget>();
//     for (var imagePath in listImagePath) {
//       listImages.add(
//         Container(
//           padding: const EdgeInsets.all(8),
//           child: Image.file(imagePath, fit: BoxFit.cover),
//         ),
//       );
//     }
//     return listImages;
//   }
// }
