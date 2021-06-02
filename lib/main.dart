import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

void main() => runApp(MyApp());



class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


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
    map['mobile_no'] = '9899988817';
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
      print('demo'+messageResponse);

      if (messageResponse == 'Success') {
        Fluttertoast.showToast(
          msg: messageResponse,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.red,
          textColor: Colors.black,
          fontSize: 16.0,
        );
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
    //Navigator.of(context)
        //.push(MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: Text('Login')),
            body: Padding(
                padding: EdgeInsets.all(15),
                child: Column(

                  children: <Widget>[

                    Center(

                      child:TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Mobile number',
                            hintText: 'Enter Your Mobile Number')
                      )
                        ),




                    RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,

                      child: Text('Sign In'),

                      onPressed: () => _otpenter(),
                    )
                  ],
                ))));
  }
}
