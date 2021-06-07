import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'OtpScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginDemo(),
    );
  }
}

class LoginDemo extends StatefulWidget {
  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {

  final TextEditingController _phoneController = TextEditingController();

  void _otpenter() async {
    //get device id for android device

    String decodedResponse = '';
    String name;
    //API call here for verifying otp
    var urlSent = Uri.encodeFull(
        'http://35.154.190.204/Restaurant/index.php/customer/Api/login');
//map of string and object type used in http post
    var map = new Map<String, dynamic>();
    //get mobile number from phone textfield
    map['mobile_no'] = _phoneController.text;
    map['device_id'] = 'ldnxlnlxdnlngnxlgk';
    map['notification_id'] = '123'; //otp here
    var url = Uri.parse(urlSent);
    var response;
    //http request by encoding request in utf8 format and decoding in utf8 format
    //content type application/x-www-form-urlencoded
    try {
      response = await http.post(url,
          body: map,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          encoding: Encoding.getByName("utf-8"));
      decodedResponse = utf8.decode(response.bodyBytes);
      //map of string and object type used for storing data coming from otp response
      Map<String, dynamic> mapOtpResponse = jsonDecode(decodedResponse);
      //fetch message Response status ie invalid otp or valid otp
      String messageResponse = mapOtpResponse['data']['message'];
      //if messageResponse is invalid otp display the message of invalid otp
      //else proceed to homescreen
      print('demo' + messageResponse);

      if (messageResponse == 'Success') {

        Fluttertoast.showToast(
          msg: messageResponse,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.red,
          textColor: Colors.black,
          fontSize: 16.0,

        );
        _navigateToNextScreen(context);
        // Fluttertoast.showToast(
        //     msg: messageResponse,
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.CENTER,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.red,
        //     textColor: Colors.black,
        //     fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: 'Failure',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        // _navigateToNextScreen(context);
      }
    } catch (e) {
      //Write exception statement here

    }
  }

  void _navigateToNextScreen(BuildContext context) {
    print('hii'+_phoneController.text);
    _nameSaver( _phoneController.text);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => NotesPage()));
  }

  Future<String> _nameSaver(String mobileno) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('phone',  _phoneController.text);
    return 'saved';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(19, 22, 40, 1),
        title: Text("Smart Dine"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
        child: Text('SIGN IN', style: TextStyle(
          color: Colors.orange,

          fontFamily: 'Courgette',
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ),
        ),
              ),

              //child: Center(
              //   child: Container(
              //       width: 200,
              //       height: 150,
              //       /*decoration: BoxDecoration(
              //           color: Colors.red,
              //           borderRadius: BorderRadius.circular(50.0)),*/
              //       //child: Image.asset('asset/smartdine.jpeg')),
              // ),

             Image(
              image: AssetImage(
                'assets/smartdine.jpeg'

              ),
               height: 150,
               width: 150,
            ),

      Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Text('ENTER YOUR MOBILE NUMBER', style: TextStyle(
          color: Colors.orange,

          fontFamily: 'Courgette',
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
        ),
      ),

            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Text('We will send you a OTP message', style: TextStyle(
                color: Colors.black,

                fontFamily: 'Courgette',
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _phoneController,

                decoration: InputDecoration(
                    //border: OutlineInputBorder(),
                    labelText: 'Enter Mobile Number',
                    hintText: 'Enter Mobile Number'),
              ),
            ),
            FlatButton(

              child: Text(
                '',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
              onPressed: () => _otpenter(),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.cyan, borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () => _otpenter(),
                child: Text(
                  'SEND OTP',
                  style: TextStyle(color: Colors.orange, fontSize: 25),
                ),
              ),
            ),

            //Text('New User? Create Account')
          ],
        ),
      ),
    );
  }
}