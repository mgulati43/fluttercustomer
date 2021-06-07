import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<RestaurantJsonParser> restaurantList = [];
  List<RestaurantJsonParser> searchableRestaurantList = [];

  TextEditingController editingController = TextEditingController();
  var _loading;

  @override
  void initState() {
    super.initState();
    _loading = true;
    callListApi();
  }

  Widget _displayImage(String media) {
    if (media == null || media.isEmpty) {
      return Image.asset('assets/dummyRestaurant.png',
          width: 80, height: 80, fit: BoxFit.cover);
    } else {
      return Image.network(media, width: 80, height: 80, fit: BoxFit.cover);
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

      var jsonObjects = jsonDecode(decodedResponse)['spots'] as List;

      setState(() {
        restaurantList = jsonObjects
            .map((jsonObject) => RestaurantJsonParser.fromJson(jsonObject))
            .toList();
        searchableRestaurantList = restaurantList;
      });
    } catch (e) {
      //Write exception statement here

    }
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (value) {
          value = value.toLowerCase();
          setState(() {
            searchableRestaurantList = restaurantList.where((restaurant) {
              var restaurantTitle = restaurant.name.toLowerCase();
              return restaurantTitle.contains(value);
            }).toList();
          });
        },
        controller: editingController,
        decoration: InputDecoration(
            labelText: "Search",
            hintText: "Search",
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)))),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(19, 22, 40, 1),
        title: Text("Smart Dine"),
      ),
      body: Column(children: [
        _searchBar(),
        Expanded(
          child: ListView.builder(
              itemCount: searchableRestaurantList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              spreadRadius: 2.0,
                              blurRadius: 5.0),
                        ]),
                    margin: EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0)),
                          child: _displayImage(searchableRestaurantList[index].image,)
                        ),
                        SizedBox(
                          width: 250,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(searchableRestaurantList[index].name),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 2.0, bottom: 2.0),
                                  child: Text(
                                    searchableRestaurantList[index].address,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.black54,
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                                Text(
                                  searchableRestaurantList[index].openingTime +
                                      ' - ' +
                                      searchableRestaurantList[index]
                                          .closingTime,
                                  style: TextStyle(
                                      fontSize: 12.0, color: Colors.black54),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
        )
      ]),
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
