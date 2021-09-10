import 'dart:convert';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pinput/pin_put/pin_put.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomeScreen.dart';
import 'sideBar.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
  //mayank
}

class _NotesPageState extends State<NotesPage> {
  String mobileno = '';
  bool resendBool = true;
  bool resendButtonBool = false;
  

  CountDownController _controller = CountDownController();

  final FocusNode _pinPutFocusNode = FocusNode();
  final TextEditingController _pinPutController = TextEditingController();

  //ui for pinput
  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
        border: Border.all(color: Colors.deepPurpleAccent),
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white);
  }

  void _otpResend() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mobileno = prefs.getString('phone').toString();
    print('testing' + mobileno);

    String decodedResponse = '';
        String name;
        //API call here for verifying otp
        var urlSent = Uri.encodeFull(
            'http://dev.goolean.com/Restaurant/index.php/customer/Api/login');
        //map of string and object type used in http post
        var map = new Map<String, dynamic>();
        //get mobile number from phone textfield
        map['mobile_no'] = mobileno;
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
          } else {
            Fluttertoast.showToast(
                msg: 'Failure',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } catch (e) {
          //Write exception statement here

        }
  }

  void _otpenter(String otp) async {
    if (!(otp == '')) {
      //get device id for android device
      SharedPreferences prefs = await SharedPreferences.getInstance();

      mobileno = prefs.getString('phone').toString();
      print('checking' + mobileno);
      String decodedResponse = '';
      String name;
      //API call here for verifying otp
      var urlSent = Uri.encodeFull(
          'http://dev.goolean.com/Restaurant/index.php/customer/Api/verification_otp_customer');
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
        } else {
          Fluttertoast.showToast(
              msg: 'Failure',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } catch (e) {
        //Write exception statement here

      }
    } else {
      Fluttertoast.showToast(
          msg: 'Enter OTP',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Widget _buildOTP() {
    return Container(
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

  Widget _countdown() {
    return Align(
          alignment: Alignment.bottomCenter,

          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).

          child: CircularCountDownTimer(
            // Countdown duration in Seconds.
            duration: 10,

            // Countdown initial elapsed Duration in Seconds.
            initialDuration: 0,

            // Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
            controller: _controller,

            // Width of the Countdown Widget.
            width: MediaQuery.of(context).size.width / 10,

            // Height of the Countdown Widget.
            height: MediaQuery.of(context).size.height / 10,

            // Ring Color for Countdown Widget.
            ringColor: Colors.grey,

            // Ring Gradient for Countdown Widget.
            ringGradient: null,

            // Filling Color for Countdown Widget.
            fillColor: Colors.purpleAccent,

            // Filling Gradient for Countdown Widget.
            fillGradient: null,

            // Background Color for Countdown Widget.
            backgroundColor: Colors.purple[500],

            // Background Gradient for Countdown Widget.
            backgroundGradient: null,

            // Border Thickness of the Countdown Ring.
            strokeWidth: 10.0,

            // Begin and end contours with a flat edge and no extension.
            strokeCap: StrokeCap.round,

            // Text Style for Countdown Text.
            textStyle: TextStyle(
                fontSize: 15.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),

            // Format for the Countdown Text.
            textFormat: CountdownTextFormat.S,

            // Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
            isReverse: true,

            // Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
            isReverseAnimation: true,

            // Handles visibility of the Countdown Text.
            isTimerTextShown: true,

            // Handles the timer start.
            autoStart: true,

            // This Callback will execute when the Countdown Starts.
            onStart: () {
              // Here, do whatever you want
              print('Countdown Started');
            },

            onComplete: () {
              setState(() {
                resendBool = false;
                resendButtonBool = true;
              });
              // Here, do whatever you want
              print('Countdown Ended');
            },

            // This Callback will execute when the Countdown Ends.

            // Here, do whatever you want
          ),
      // Container(
      //   height: 3,
      //   width: 70,
      //   color: Colors.red,
      //   child: Text('heya',style: TextStyle(color: Colors.black,fontSize: 20)),
      //
      // )
    );
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: SideBar(),
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          title: Text("Smart Dine"),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        resizeToAvoidBottomInset: false,
        body: Column(
          children: <Widget>[
            // Max Size Widget
            Container(
                //height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Text(
                      'Enter verification code',
                      style: TextStyle(
                          color: Colors.orange,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 170,
                    width: 170,
                    child: Image.asset('assets/logo.jpg'),
                  ),
                ),           
            Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'Enter OTP',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            Expanded(
                child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Colors.orange, Colors.orange],
                    )),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(50),
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
                          ),),
                          Container(
                            height: 50,
                            width: 150,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: FlatButton(
                              onPressed: () => _otpenter(_pinPutController.text),
                              child: Text(
                                'VERIFY',
                                style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          resendBool == true
                    ? _countdown()
                    : Container(
                      margin: EdgeInsets.only(top: 10),
                            height: 50,
                            width: 150,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: FlatButton(
                              onPressed: () => _otpResend(),
                              child: Text(
                                'Resend OTP',
                                style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ]))),
          ],
        ),
      ),
    );
  }
}
