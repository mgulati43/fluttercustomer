import 'dart:convert';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'HomeScreen.dart';
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

getStringValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String? stringValue = prefs.getString('name');
  return stringValue;
}

// create order class having fields like amount,item name, quantity,restaurant name,gst
//create an orders instance than  on click call a function which adds order details to a list of clicked item
//make list global
//remove item on item clicked from list
//on click of item list pass the menu current clicked object to addtocart function which first creates an instance and then adds it to a global list
class LoginDemo extends StatefulWidget {
  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {
  final TextEditingController _phoneController = TextEditingController();

  CountDownController _controller = CountDownController();

  String mobileno = '';

  @override
  void initState() {
    super.initState();
  }

  void _navigateToNextScreen(BuildContext context) {
    print('hii' + _phoneController.text);
    _nameSaver(_phoneController.text);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => HomePage()));
  }

  void _otpenter() async {
    //get device id for android device
    print('hii'+_phoneController.text);
    _navigateToNextScreen(context);
    if (_phoneController.text == '') {
      Fluttertoast.showToast(
          msg: 'Enter Mobile Number',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      if (_phoneController.text.length == 10) {

        String decodedResponse = '';
        String name;
        //API call here for verifying otp
        var urlSent = Uri.encodeFull(
            'http://dev.goolean.com/Restaurant/index.php/customer/Api/login');
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

          String cus_id = mapOtpResponse['data']['cus_id'];
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('cus_id', cus_id);
          //if messageResponse is invalid otp display the message of invalid otp
          //else proceed to homescreen
          print('demo' + messageResponse);

          if (messageResponse == 'Success') {
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
            msg: 'Please Enter ten digit number',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  Future<String> _nameSaver(String mobileno) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('phone', _phoneController.text);
    return 'saved';
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
                        padding: const EdgeInsets.all(40.0),
                        child: Text(
                          'SIGN IN',
                          style: TextStyle(
                              color: Colors.red,
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
                        padding: const EdgeInsets.all(30),
                        child: Text(
                          'Enter your mobile number',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
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
                      padding: const EdgeInsets.all(70.0),
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
                    color: getColorFromHex('#f54c31'),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(50, 10, 50, 0),
                      child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            hintText: "Enter a Mobile Number",
                            hintStyle:
                            TextStyle(fontSize: 15.0, color: Colors.white),
                          ),
                          style: TextStyle(color: Colors.white, fontSize: 15,fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),

                Positioned(
                  top: MediaQuery.of(context).size.height / 2 + 90.0,
                  right: MediaQuery.of(context).size.width / 3,
                  child: Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: FlatButton(
                      onPressed: () =>_otpenter(),
                      child: Text(
                        'SEND OTP',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      height: 120,
                      width: 120,
                      child: Image.asset('assets/back1.png'),
                    ),
                  ),
                ),

                Positioned(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 120,
                      width: 120,
                      child: Image.asset('assets/back2.png'),
                    ),
                  ),
                ),

                Positioned(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      height: 120,
                      width: 120,
                      child: Image.asset('assets/back3.png'),
                    ),
                  ),
                ),
    //Text('heya',style: TextStyle(color: Colors.black,fontSize: 20))
              ],
            ),
          )
      ),
    );
  }

  Color getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');

    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }

    return Color(int.parse(hexColor, radix: 16));
  }
}
