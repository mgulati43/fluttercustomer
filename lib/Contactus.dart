import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'sideBar.dart';


class Contactus extends StatefulWidget {
  @override
  _ContactusState createState() => _ContactusState();
}

class _ContactusState extends State<Contactus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SideBar(),
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          title: Text("Smart Dine"),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Column(children: [
        TextFormField(
        decoration: InputDecoration(
        hintText: 'Enter your name',
          labelText: 'Name',
          prefixIcon: Icon(Icons.account_circle_rounded,size: 40),
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        ),

    ),

          TextFormField(
            decoration: InputDecoration(
              hintText: 'Enter your number',
              labelText: 'Contact Number',
              prefixIcon: Icon(Icons.call,size: 40),
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            ),

          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'info@gmail.com',
              labelText: 'Email-ID',
              prefixIcon: Icon(Icons.email,size: 40),
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            ),

          ),

          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              minLines: 15,
              maxLines: 15,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: 'Text message..',
                hintStyle: TextStyle(color:
                Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
              child: FlatButton(
                child: Text('SUBMIT',style: TextStyle(fontSize: 20),),
                color: Colors.red,
                textColor: Colors.white,
                onPressed: () => _contactus(),
              ),
            ),
          ),
        ]));
  }


  void _contactus() async {

      //get device id for android device
      SharedPreferences prefs = await SharedPreferences.getInstance();

      //mobileno = prefs.getString('phone').toString();
     // print('checking' + mobileno);
      String decodedResponse = '';
      String name;
      //API call here for verifying otp
      var urlSent = Uri.encodeFull(
          'https://itwwvhter2.execute-api.ap-south-1.amazonaws.com/LATEST/oyly_demo/index.php/customer/Api/add_contact_detail_for_customer');
      //map of string and object type used in http post
      var map = new Map<String, dynamic>();
      //get mobile number from phone textfield
      map['mobile_no'] = '9899988817';
      map['name'] = 'mayank';
      map['email'] = 'mgulati43@gmail.com'; //otp here
      map['message'] = 'fgdfgdddddddd';
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
        print('demo' + mapOtpResponse.toString());
        //fetch message Response status ie invalid otp or valid otp
        //String messageResponse = mapOtpResponse['data']['message'];
        //if messageResponse is invalid otp display the message of invalid otp
        //else proceed to homescreen



      } catch (e) {
        //Write exception statement here

      }
    }
  }

