import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<RestaurantJsonParser> restaurantList = [];
  var _loading;

  @override
  void initState() {
    super.initState();
    _loading = true;
    callListApi();
  }

  Widget _displayImage(String media) {
    if(media == null || media.isEmpty) {
      return Image.asset('assets/dummyRestaurant.png');
    }
    else{
    return Image.network(media);
    }



    }

  void callListApi() async {
    var response;
    String decodedResponse = '';
    //API call here
    var urlSent = Uri.encodeFull(
        'http://35.154.190.204/Restaurant/index.php/customer/Api/getNearbySpots');
    var map = new Map<String, dynamic>();
    map['city'] = '';
    var url = Uri.parse(urlSent);
    try {
      response = await http.post(url,
          body: map,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          encoding: Encoding.getByName("utf-8"));
      decodedResponse = utf8.decode(response.bodyBytes);

      print('demo' + decodedResponse);

      var jsonObjects = jsonDecode(decodedResponse)['spots'] as List;
      print('testing' + jsonObjects.toString());
      //print(jsonObjects);
      //jsonObjects.map((jsonObject) => print(jsonObject)).toList();

      setState(() {
        jsonObjects.map((jsonObject) => print('mayank' + jsonObject));

        restaurantList = jsonObjects
            .map((jsonObject) => RestaurantJsonParser.fromJson(jsonObject))
            .toList();
      });
    } catch (e) {
      //Write exception statement here

    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(19, 22, 40, 1),
        title: Text("Smart Dine"),
      ),
      body: Container(
          child: ListView.builder(
              itemCount: restaurantList.length,
              itemBuilder: (context, index) {
                return Card(
                    child: ListTile(
                        title: Text(restaurantList[index].name),
                        trailing: Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          color: Colors.orange,
                          child: Text(restaurantList[index].rating,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold)),
                        ),
                        subtitle: Column(
                          children: [
                            Text(restaurantList[index].address),
                          ],
                        ),
                        leading: _displayImage(restaurantList[index].image)
                    )
                );
              }
              )
      ),
    );


  }
}

class RestaurantJsonParser {
  //String time;
  String verified;
  String admin_id;
  String city;
  String spotId;
  String trending;
  String name;
  String image;
  String rating;
  String lat;
  String lng;
  String location;
  String cuisines;
  String priceLevel;
  String cost;
  String openStatus;
  String openingTime;
  String closingTime;
  String phone;
  String address;

  RestaurantJsonParser(
      //this.time,
      this.admin_id,
      this.verified,
      this.city,
      this.spotId,
      this.trending,
      this.name,
      this.rating,
      this.image,
      this.lat,
      this.lng,
      this.location,
      this.cuisines,
      this.priceLevel,
      this.cost,
      this.openStatus,
      this.openingTime,
      this.closingTime,
      this.phone,
      this.address);
  //this.message,
  //this.status);

  factory RestaurantJsonParser.fromJson(dynamic json) {
    return RestaurantJsonParser(
      json['verified'] as String,
      //json['time'] as String,
      json['admin_id'] as String,
      json['city'] as String,
      json['spotId'] as String,
      json['trending'] as String,
      json['name'] as String,
      json['rating'] as String,
      json['image'] as String,
      json['lat'] as String,
      json['lng'] as String,
      json['location'] as String,
      json['cuisines'] as String,
      json['priceLevel'] as String,
      json['cost'] as String,
      json['openStatus'] as String,
      json['openingTime'] as String,
      json['closingTime'] as String,
      json['phone'] as String,
      json['address'] as String,

      // json['message'] as String,
      // json['status'] as String);
    );
  }
}
