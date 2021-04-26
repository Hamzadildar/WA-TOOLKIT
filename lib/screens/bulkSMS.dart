import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class BulkSMS extends StatefulWidget {
  static String id = 'bulkSMS';
  @override
  _BulkSMSState createState() => _BulkSMSState();
}

class _BulkSMSState extends State<BulkSMS> {
  int counter = 0;
  String msg;
  int textSize = 0;
  List<String> recipents = [];

  static const _adUnitID = "ca-app-pub-3940256099942544/8135179316";

  final _nativeAdController = NativeAdmobController();

  Widget adsContainer() {
    return Container(
      //You Can Set Container Height
      height: 200,
      child: NativeAdmob(
        // Your ad unit id
        adUnitID: _adUnitID,
        controller: _nativeAdController,
        type: NativeAdmobType.full,
        error: CupertinoActivityIndicator(),
      ),
    );
  }

  void _bulksms({@required msg, @required String recipents}) async {
    String url = "whatsapp://send?phone=$recipents&text=$msg";

    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text(
        "OK",
        style: TextStyle(
          color: Color(0xff02544B),
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert..!"),
      content: Text("You can't type further more."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xfff9edde),
        appBar: AppBar(
          backgroundColor: Color(0xff02544B),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Bulk Massege'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 1.3,
                  color: Color(0xffece1d4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20.0, top: 10.0),
                            child: RaisedButton(
                              color: Color(0xff02544B),
                              child: Column(
                                children: [
                                  Text(
                                    "Select Contact ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                              onPressed: () async {
                                if (await Permission.contacts
                                    .request()
                                    .isGranted) {
                                  final FullContact contact =
                                      await FlutterContactPicker
                                          .pickFullContact();
                                  setState(() {
                                    if (contact.phones[0].number != null) {
                                      recipents.add(
                                          contact.phones[0].number.toString());
                                      print(recipents);
                                    } else {}
                                  });
                                }
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(15),
                            child:
                                Text("${recipents.length} No's are Selected."),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20.0, top: 20.0),
                        child: Text(
                          'Enter Text',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color(0xff02544B),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 20.0, top: 20.0, right: 20),
                        child: TextField(
                          maxLines: 11,
                          cursorWidth: 5.0,
                          cursorColor: Color(0xff02544b),
                          textAlign: TextAlign.start,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Enter Your Message',
                            fillColor: Colors.white60,
                            hintStyle: TextStyle(fontSize: 16),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white60,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xff02544b), width: 1.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            contentPadding: EdgeInsets.all(16),
                          ),
                          onChanged: (value) {
                            msg = value;
                            setState(() {
                              textSize = value.length;
                              if (textSize > 452 || textSize == 452) {
                                showAlertDialog(context);
                              }
                            });
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 100, top: 40, right: 100),
                        child: RaisedButton(
                          elevation: 10,
                          child: Row(
                            children: [
                              Icon(
                                Icons.send,
                                color: Colors.green,
                                size: 30.0,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                "Send",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              )
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          onPressed: () {
                            for (int i = 0; i < recipents.length; i++) {
                              String no = recipents[i];
                              print(recipents[i]);
                              _bulksms(msg: msg, recipents: no);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20.0),
                  child: adsContainer(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// FlatButton(
//   onPressed: () {
//     String msg = "This is a test message!";
//     List<String> recipents = [
//       "+92$toString" + "3347952888",
//       "+92$toString" + "3101606012",
//     ];
//     _bulksms(msg: msg, recipents: recipents);
//   },
//   child: Text('press me'),
// )
