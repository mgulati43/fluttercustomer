import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:pinput/pin_put/pin_put.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomeScreen.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  String mobileno = '';

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
    if (!(otp == '')) {
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

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => HomePage()));
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: null,
          resizeToAvoidBottomInset : false,
          body: Center(

            child: Stack(
              fit: StackFit.expand,
              overflow: Overflow.visible,
              children: <Widget>[
                // Max Size Widget
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2,
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
                ),

                Positioned(
                  top: 210,
                  right: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2,
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
                ),
                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: Positioned(
                //     top: 0,
                //     right: 0,
                //     child: Container(
                //       height: 150,
                //       width: 150,
                //       decoration: BoxDecoration(
                //           color: Colors.white,
                //           borderRadius: BorderRadius.circular(20)),
                //       child: FlatButton(
                //         onPressed: () =>null,
                //         child: Text(
                //           'SEND OTP',
                //           style: TextStyle(
                //               color: Colors.red,
                //               fontSize: 15,
                //               fontWeight: FontWeight.bold),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),

                Positioned(
                  top: 200,
                  right: 0,
                  bottom: 200,
                  child: Container(
                    height: MediaQuery.of(context).size.height/2,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(60),
                        child: Text(
                          'We have sent OTP on your mobile number',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                  ),

                ),

                Positioned(
                  top: 210,
                  right: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2,
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
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                  ),

                ),
                Positioned(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Container(
                        height: 170,
                        width: 170,
                        child: Image.asset('assets/logo.jpg'),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: MediaQuery.of(context).size.height / 2,
                  right: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.orange,

                  ),
                ),




                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,50.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,

                    child: Container(
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
                  ),
                ),

                //
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0,0.0,0.0,250.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,

                          child: Container(
                            //margin: const EdgeInsets.fromLTRB(0.0, 150.0, 0.0, 0.0),
                            color: Colors.white,
                            width: 220.0,
                            height: 100.0,
                            padding: const EdgeInsets.only(top: 20.0),
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
                      ),









                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: Padding(
                //     padding: const EdgeInsets.fromLTRB(0.0,20.0,0.0,00.0),
                //     child: Positioned(
                //       top: 450,
                //       right: 70,
                //
                //
                //       child: Container(
                //         //margin: const EdgeInsets.fromLTRB(0.0, 150.0, 0.0, 0.0),
                //         color: Colors.white,
                //         width: 220.0,
                //         height: 180.0,
                //         padding: const EdgeInsets.only(top: 80.0),
                //         child: PinPut(
                //           fieldsCount: 4,
                //           eachFieldWidth: 50,
                //           eachFieldHeight: 50,
                //           focusNode: _pinPutFocusNode,
                //           controller: _pinPutController,
                //           submittedFieldDecoration: _pinPutDecoration.copyWith(
                //             borderRadius: BorderRadius.circular(20.0),
                //           ),
                //           selectedFieldDecoration: _pinPutDecoration,
                //           followingFieldDecoration: _pinPutDecoration.copyWith(
                //             borderRadius: BorderRadius.circular(20.0),
                //             border: Border.all(
                //               color: Colors.deepPurpleAccent.withOpacity(.5),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),

              ],
            ),
          )
      ),
    );
  }

}

