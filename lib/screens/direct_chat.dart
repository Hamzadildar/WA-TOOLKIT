import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home screen.dart';
import 'package:tech_vision/ads.dart';

class DirectChat extends StatefulWidget {
  static String id = 'direct_chat';
  @override
  _DirectChatState createState() => _DirectChatState();
}

String code = '+1'.toString();

void _launchWatsapp({@required number, @required msg}) async {
  String url = "whatsapp://send?phone=$whatsAppNumber";

  await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
}

String phoneNumber = "";

class _DirectChatState extends State<DirectChat> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xfff9edde),
        appBar: AppBar(
          backgroundColor: Color(0xff02544b),
          title: Text(
            "Direct Chat",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Container(
                height: MediaQuery.of(context).size.height * .30,
                width: MediaQuery.of(context).size.width * 1,
                child: new Container(
                  color: Color(0xffece1d4),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 20, left: 10),
                            child: Text(
                              'Direct Chat',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: Color(0xff02544b),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          CountryCodePicker(
                            initialSelection: 'US',
                            favorite: ['+92', 'PK'],
                            showOnlyCountryWhenClosed: false,
                            alignLeft: false,
                            onChanged: (value) {
                              setState(() {
                                code = value.toString();
                              });
                            },
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * .5,
                            child: TextField(
                              keyboardType: TextInputType.phone,
                              cursorColor: Color(0xff02544b),
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                hintText: 'Enter WhatsApp number',
                                fillColor: Colors.white60,
                                hintStyle: TextStyle(fontSize: 16),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white60,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(0.0))),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xff02544b), width: 1.0),
                                  borderRadius: BorderRadius.circular(0.0),
                                ),
                                filled: true,
                                contentPadding: EdgeInsets.all(16),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  setState(() {
                                    whatsAppNumber = (code + value).toString();
                                    print(whatsAppNumber);
                                  });
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 50,
                          ),
                          FloatingActionButton(
                            elevation: 0.0,
                            child: new Icon(Icons.send),
                            backgroundColor: Color(0xff25d366),
                            onPressed: () {
                              _launchWatsapp(number: whatsAppNumber, msg: "hi");
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Select Country Code and Enter No.',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(bottom: 20.0),
                  child: adsContainer(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
