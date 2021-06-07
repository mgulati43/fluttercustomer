import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomeScreen.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  String mobileno = '';

  _nameRetriever() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    mobileno = prefs.getString('phone').toString();

    print('testing' + mobileno);
  }

  final FocusNode _pinPutFocusNode = FocusNode();
  final TextEditingController _pinPutController = TextEditingController();

  //ui for pinput
  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
        border: Border.all(color: Colors.deepPurpleAccent),
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white);
  }

  void _otpenter(String otp) async {
    //_nameRetriever();
    //get device id for android device
    SharedPreferences prefs = await SharedPreferences.getInstance();

    mobileno = prefs.getString('phone').toString();
    print('checking' + mobileno);
    String decodedResponse = '';
    String name;
    //API call here for verifying otp
    var urlSent = Uri.encodeFull(
        'http://35.154.190.204/Restaurant/index.php/customer/Api/verification_otp_customer');
//map of string and object type used in http post
    var map = new Map<String, dynamic>();
    //get mobile number from phone textfield
    map['mobile_no'] = mobileno;
    map['device_id'] = 'ldnxlnlxdnlngnxlgk';
    map['otp'] = otp; //otp here
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

      if (messageResponse == 'success') {
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

  Widget _buildOTP() {
    return Container(
      //color: Colors.white,
      padding: EdgeInsets.all(20.0),
      child: PinPut(
        fieldsCount: 4,
        focusNode: _pinPutFocusNode,
        controller: _pinPutController,
        submittedFieldDecoration: _pinPutDecoration.copyWith(
          borderRadius: BorderRadius.circular(20.0),
        ),
        selectedFieldDecoration: _pinPutDecoration,
        followingFieldDecoration: _pinPutDecoration.copyWith(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
            color: Colors.deepPurpleAccent.withOpacity(.5),
          ),
        ),
      ),
    );
  }

  void _navigateToNextScreen(BuildContext context) {

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: Text(
                'Enter Verification Code',
                style: TextStyle(
                  color: Colors.orange,
                  fontFamily: 'Courgette',
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Image(
              image: AssetImage(
                'assets/smartdine.jpeg',
              ),
              height: 150,
              width: 150,
            ),

            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                'Enter OTP',
                style: TextStyle(
                  color: Colors.orange,
                  fontFamily: 'Courgette',
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Text(
                'We have sent you OTP on your mobile number',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Courgette',
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Center(
              child: Container(
                color: Colors.orange,
                width: 250.0,
                height: 200.0,
                padding: const EdgeInsets.only(top: 70.0),
                child: PinPut(
                  fieldsCount: 4,
                  eachFieldWidth: 50,
                  eachFieldHeight: 50,
                  focusNode: _pinPutFocusNode,
                  controller: _pinPutController,
                  submittedFieldDecoration: _pinPutDecoration.copyWith(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  selectedFieldDecoration: _pinPutDecoration,
                  followingFieldDecoration: _pinPutDecoration.copyWith(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: Colors.deepPurpleAccent.withOpacity(.5),
                    ),
                  ),
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 25, bottom: 0),
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.cyan, borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () => _otpenter(_pinPutController.text),
                child: Text(
                  'VERIFY',
                  style: TextStyle(color: Colors.orange, fontSize: 25),
                ),
              ),
            ),

            //Text('New User? Create Account')
          ],
        ),
      ),
    );
    //child: Center(
    //   child: Container(
    //       width: 200,
    //       height: 150,
    //       /*decoration: BoxDecoration(
    //           color: Colors.red,
    //           borderRadius: BorderRadius.circular(50.0)),*/
    //       //child: Image.asset('asset/smartdine.jpeg')),
    // ),
  }
}
