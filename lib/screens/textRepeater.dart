import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tech_vision/screens/home%20screen.dart';
import 'package:url_launcher/url_launcher.dart';

class TextRepeater extends StatefulWidget {
  static String id = 'textRepeater';
  @override
  _TextRepeaterState createState() => _TextRepeaterState();
}

class _TextRepeaterState extends State<TextRepeater> {
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

  TextEditingController field = TextEditingController();
  List<String> textList = [];
  String pasteValue = '';
  int counter = 0;
  String text;
  bool checkedValue = false;
  List<String> recipents = [];
  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
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
      content: Text("You can't go down from 0."),
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
    void _launchWatsapp({@required number, @required msg}) async {
      String url = "whatsapp://send?phone=$whatsAppNumber&text=$msg";

      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
    }

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
              whatsAppNumber = null;
            },
          ),
          title: Text('Repeated Text'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * .6,
                  color: Color(0xffece1d4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 20.0, top: 20.0),
                        child: TextButton(
                          onPressed: () async {
                            if (await Permission.contacts.request().isGranted &&
                                whatsAppNumber == null) {
                              // Either the permission was already granted before or the user just granted it.
                              final FullContact contact =
                                  await FlutterContactPicker.pickFullContact();
                              setState(() {
                                if (contact.phones[0].number != null) {
                                  recipents.add(contact.phones[0].number);
                                  whatsAppNumber = contact.phones[0].toString();
                                } else {}
                              });
                            }
                          },
                          style: TextButton.styleFrom(
                            primary: Color(0xff02544b),
                          ),
                          child: Text(
                            'Select Contact',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color(0xff02544b),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 20.0, top: 20.0, right: 20),
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            hintText: recipents != null
                                ? '${recipents.join('')}'
                                : null,
                            fillColor: Colors.white60,
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Color(0xff02544b),
                            ),
                            filled: true,
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20.0, top: 20.0),
                        child: Text(
                          'Enter Text',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color(0xff02544b),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 20.0, top: 20.0, right: 20),
                        child: TextField(
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
                            text = value;
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20.0, top: 20.0),
                        child: Text(
                          'Set Limit',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color(0xff02544b),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .04,
                              ),
                              RawMaterialButton(
                                child: Icon(
                                  Icons.remove,
                                  color: Color(0xff02544b),
                                  size: 30.0,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (counter < 0 || counter == 1) {
                                      showAlertDialog(context);
                                    }
                                    counter--;
                                  });
                                },
                                elevation: 0.0,
                                constraints: BoxConstraints.tightFor(
                                  width: 56.0,
                                  height: 56.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(
                                    color: Color(0xff02544b),
                                  ),
                                ),
                                fillColor: Color(0xffece1d4),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .04,
                              ),
                              Text(
                                counter.toString(),
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .04,
                              ),
                              RawMaterialButton(
                                child: Icon(
                                  Icons.add,
                                  color: Color(0xff02544b),
                                  size: 30.0,
                                ),
                                onPressed: () {
                                  setState(() {
                                    counter++;
                                  });
                                },
                                elevation: 0.0,
                                constraints: BoxConstraints.tightFor(
                                  width: 56.0,
                                  height: 56.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(
                                    color: Color(0xff02544b),
                                  ),
                                ),
                                fillColor: Color(0xffece1d4),
                              ),
                            ],
                          ),
                        ),
                      ),
                      CheckboxListTile(
                        title: Text("new Line"),
                        value: checkedValue,
                        onChanged: (newValue) {
                          setState(() {
                            checkedValue = newValue;
                          });
                        },
                        controlAffinity: ListTileControlAffinity
                            .leading, //  <-- leading Checkbox
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 3,
                      child: RaisedButton(
                        color: Color(0xff02544b),
                        child: Row(
                          children: [
                            Icon(
                              Icons.settings_backup_restore,
                              color: Colors.white,
                              size: 15.0,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Reset",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onPressed: () {
                          setState(() {
                            counter = 0;
                            textList = [];
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 3,
                      child: RaisedButton(
                        color: Color(0xff02544b),
                        child: Row(
                          children: [
                            Icon(
                              Icons.gesture,
                              color: Colors.white,
                              size: 15.0,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Generate",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            )
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onPressed: () {
                          setState(() {
                            for (var i = 0; i < counter; i++) {
                              textList.add(text);
                            }
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 3,
                      child: RaisedButton(
                        color: Color(0xff02544b),
                        child: Row(
                          children: [
                            Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 15.0,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Send",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onPressed: () {
                          _launchWatsapp(
                              number: whatsAppNumber,
                              msg: checkedValue == true
                                  ? "${textList.join("\n")}"
                                  : "${textList.join(",")}");
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30.0,
                ),
                SelectableText(checkedValue == true
                    ? "${textList.join("\n")}"
                    : "${textList.join(",")}"),
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

class CopyableText extends StatelessWidget {
  final String data;
  final TextStyle style;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final bool softWrap;
  final TextOverflow overflow;
  final double textScaleFactor;
  final int maxLines;
  CopyableText(
    this.data, {
    this.style,
    this.textAlign,
    this.textDirection,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
  });
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new Text(data,
          style: style,
          textAlign: textAlign,
          textDirection: textDirection,
          softWrap: softWrap,
          overflow: overflow,
          textScaleFactor: textScaleFactor,
          maxLines: maxLines),
      onLongPress: () {
        Clipboard.setData(new ClipboardData(text: data));
      },
    );
  }
}
