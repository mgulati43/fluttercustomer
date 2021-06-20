import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'HomeScreen.dart';
import 'dart:convert';
import 'dart:typed_data';

class RestDetail extends StatefulWidget {
  _RestDetailState createState() => _RestDetailState();
  final RestaurantJsonParser rest;
// receive data from the FirstScreen as a parameter
  RestDetail({required this.rest});
}

class FoodItem {
  String menu_id=;
  String qty;
  String admin_id;
  String menu_category_id;
  String menu_name;
  String rating;
  String cat_id;

  String menu_image;
  String menu_detail;
  String menu_full_price;
  String menu_half_price;
  String menu_fix_price;

  String cat_name;
  String nutrient_counts;
  String gst;
  String menu_food_type;
  String half_qty;
  String full_qty;
  String menu_full_price_gst;
  String positions;
  String shalfFull;
  String quantityStatus;
  String menu_fix_price_gst;
  String message;
  String status;
  String quantityStatusHalf;
  String quantityStatusFull;
  String halfQuantityStatus;
  String fullQuantityStatus;
  String menu_half_price_gst;
  String fullType;

  FoodItem(
      this.menu_id,
      this.quantityStatus,
      this.fullType,
      this.halfQuantityStatus,
      this.fullQuantityStatus,
      this.quantityStatusHalf,
      this.admin_id,
      this.shalfFull,
      this.menu_category_id,
      this.quantityStatusFull,
      this.positions,
      this.menu_food_type,
      this.menu_name,
      this.rating,
      this.cat_id,
      this.full_qty,
      this.qty,
      this.half_qty,
      this.menu_image,
      this.menu_detail,
      this.menu_full_price,
      this.menu_half_price,
      this.menu_fix_price,
      this.cat_name,
      this.nutrient_counts,
      this.gst,
      this.menu_half_price_gst,
      this.menu_full_price_gst,
      this.menu_fix_price_gst,
      this.message,
      this.status);
  factory FoodItem.fromJson(dynamic json) {
    return FoodItem(
        json['menu_id'] as String,
        json['menu_full_price_gst'] as String,
        json['admin_id'] as String,
        json['quantityStatus'] as String,
        json['fullQuantityStatus'] as String,
        json['fullType'] as String,
        json['halfQuantityStatus'] as String,
        json['quantityStatusFull'] as String,
        json['quantityStatusHalf'] as String,
        json['menu_category_id'] as String,
        json['menu_food_type'] as String,
        json['menu_name'] as String,
        json['rating'] as String,
        json['cat_id'] as String,
        json['qty'] as String,
        json['half_qty'] as String,
        json['shalfFull'] as String,
        json['menu_image'] as String,
        json['menu_detail'] as String,
        json['menu_full_price'] as String,
        json['menu_half_price'] as String,
        json['menu_fix_price'] as String,
        json['positions'] as String,
        json['cat_name'] as String,
        json['nutrient_counts'] as String,
        json['gst'] as String,
        json['menu_half_price_gst'] as String,
        json['full_qty'] as String,
        json['menu_fix_price_gst'] as String,
        json['message'] as String,
        json['status'] as String);
  }
}

class MenuJsonParser {
  List<FoodItem> foodItem;
  String sub_cat_name;
  String sub_cat_id;
  MenuJsonParser(
      this.sub_cat_name,
      this.sub_cat_id,
      this.foodItem);



  factory MenuJsonParser.fromJson(dynamic json) {
    return MenuJsonParser(json['sub_cat_name'] as String,
        json['sub_cat_id'] as String,
        json['foodItem'] as List<FoodItem>);
  }
}

class _RestDetailState extends State<RestDetail> {
  @override
  void initState() {
    // initialise your tab controller here
    callListApi();
    //_tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  void callListApi() async {
    var response;
    String decodedResponse = '';
    //API call here
    var urlSent = Uri.encodeFull(
        'http://35.154.190.204/Restaurant/index.php/customer/Api/getMenuListDataCustomer');
    var map = new Map<String, dynamic>();
    map['admin_id'] = 'ADMIN_00001';
    map['cat_id'] = '1';
    var url = Uri.parse(urlSent);
    try {
      response = await http.post(url,
          body: map,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          encoding: Encoding.getByName("utf-8"));
      decodedResponse = utf8.decode(response.bodyBytes);
      print('gulati' + decodedResponse.toString());
      var jsonObjects = jsonDecode(decodedResponse)['data'] as List;
      print('mayank' + jsonObjects.toString());
      //var jsonObjects1 =
          //jsonDecode(decodedResponse)['data']['foodItem'] as List;
     // print('mayank' + jsonObjects.toString());
      //jsonObjects.map((jsonObject) => print(jsonObject)).toList();
      setState(() {
        //foodItems = jsonObjects
        //.map((jsonObject) => MenuJsonParser.fromJson(jsonObject))
        //.toList();
        //print('debug' + foodItems.toString());
      });
    } catch (e) {
      //Write exception statement here

    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white24,
            title: Center(
              child: Text(
                'Restaurant Details',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 15.0),
              ),
            )),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Text(
                widget.rest.name,
                style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Text(widget.rest.address,
                  style: TextStyle(fontSize: 16.0, color: Colors.black)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Text('Cuisines ' + widget.rest.cuisines,
                  style: TextStyle(fontSize: 18.0, color: Colors.black)),
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
