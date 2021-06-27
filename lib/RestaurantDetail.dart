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

class _RestDetailState extends State<RestDetail>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<MenuJsonParser> foodCategoryOne = [];
  List<MenuJsonParser> foodCategoryTwo = [];
  bool _loading = true;

  @override
  void initState() {
    // initialise your tab controller here
    callListApi('1');
    callListApiTwo('2');
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  //display image of restaurant from server and display dummy image if no image from server
  Widget _displayImage(Uint8List path) {
    if (path.isEmpty) {
      return Image.asset('assets/dummyRestaurant.png',
          width: 100, height: 100, fit: BoxFit.cover);
    } else {

      return Image.memory(path, width: 100, height: 100, fit: BoxFit.cover);
    }
  }

  void callListApi(String cat_id) async {
    var response;
    String decodedResponse = '';
    //API call here
    var urlSent = Uri.encodeFull(
        'http://35.154.190.204/Restaurant/index.php/customer/Api/getMenuListDataCustomer');
    var map = new Map<String, dynamic>();
    map['admin_id'] = 'HRGR00001';
    map['cat_id'] = cat_id;
    var url = Uri.parse(urlSent);
    try {
      response = await http.post(url,
          body: map,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          encoding: Encoding.getByName("utf-8"));
      decodedResponse = utf8.decode(response.bodyBytes);

      var jsonObjects = jsonDecode(decodedResponse)['data'] as List;

      setState(() {
        //fetched restaurant list
        foodCategoryOne = jsonObjects.map((jsonObject) => MenuJsonParser.fromJson(jsonObject)).toList();
        print(foodCategoryOne.toString());
        _loading = false;


      });
    } catch (e) {
      //Write exception statement here

    }
  }

  void callListApiTwo(String cat_id) async {
    var response;
    String decodedResponse = '';
    //API call here
    var urlSent = Uri.encodeFull(
        'http://35.154.190.204/Restaurant/index.php/customer/Api/getMenuListDataCustomer');
    var map = new Map<String, dynamic>();
    map['admin_id'] = 'HRGR00001';
    map['cat_id'] = cat_id;
    var url = Uri.parse(urlSent);
    try {
      response = await http.post(url,
          body: map,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          encoding: Encoding.getByName("utf-8"));
      decodedResponse = utf8.decode(response.bodyBytes);

      var jsonObjects = jsonDecode(decodedResponse)['data'] as List;

      setState(() {
        //fetched restaurant list
        foodCategoryTwo = jsonObjects.map((jsonObject) => MenuJsonParser.fromJson(jsonObject)).toList();
        print(foodCategoryTwo.toString());
        _loading = false;


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
        body: _loading == false?
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          child: Column(
            children: <Widget>[
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  widget.rest.name,
                  style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Text(widget.rest.address,
                    style: TextStyle(fontSize: 12.0, color: Colors.black)),
                Text('Cuisines ' + widget.rest.cuisines,
                    style: TextStyle(fontSize: 12.0, color: Colors.black)),
              ]),
              TabBar(
                controller: _tabController,
                labelColor: Colors.green,
                isScrollable: true,
                indicatorColor: Colors.transparent,
                unselectedLabelColor: Colors.grey,
                unselectedLabelStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w700,
                ),
                labelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                tabs: <Widget>[
                  Text('BROTCHEN'),
                  Text('KALTEGETRANKE'),
                  Text('HEIBGETRANKE')
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    ListView.builder(
                        itemCount: foodCategoryOne.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
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
                                    child:
                                    _displayImage(base64Decode(foodCategoryOne[index].menu_image)),
                                    //Image.memory(base64Decode(foodCategoryOne[index].menu_image),
                                        //width: 100, height: 100, fit: BoxFit.cover),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    foodCategoryOne[index].sub_cat_name,
                                                    style: TextStyle(
                                                        fontSize: 15.0,
                                                        color: Colors.black,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                  Text(
                                                    'COST: Rs ' +
                                                        foodCategoryOne[index].menu_full_price,
                                                    style: TextStyle(
                                                      fontSize: 10.0,
                                                      color: Colors.black,
                                                    ),
                                                  ),


                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                EdgeInsets.only(right: 4.0),
                                                child: ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                      MaterialStateProperty
                                                          .all<Color>(
                                                          Colors.red)),
                                                  onPressed: () => null,
                                                  child: Text(
                                                    'SEE MENU',
                                                    style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                    ListView.builder(
                        itemCount: foodCategoryTwo.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
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
                                    child:
                                    _displayImage(base64Decode(foodCategoryTwo[index].menu_image)),
                                    //Image.memory(base64Decode(foodCategoryOne[index].menu_image),
                                    //width: 100, height: 100, fit: BoxFit.cover),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    foodCategoryTwo[index].sub_cat_name,
                                                    style: TextStyle(
                                                        fontSize: 15.0,
                                                        color: Colors.black,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                  Text(
                                                    'COST: Rs ' +
                                                        foodCategoryTwo[index].menu_full_price,
                                                    style: TextStyle(
                                                      fontSize: 10.0,
                                                      color: Colors.black,
                                                    ),
                                                  ),


                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                EdgeInsets.only(right: 4.0),
                                                child: ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                      MaterialStateProperty
                                                          .all<Color>(
                                                          Colors.red)),
                                                  onPressed: () => null,
                                                  child: Text(
                                                    'SEE MENU',
                                                    style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),

                    Center(
                      child: Text(
                        'MILCHPPODUKE',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            Text('demo'),
            ],
          ),


        ):
        Container(
            child: Image(
              image: AssetImage(
                  'assets/loading.gif'),
            )),
        backgroundColor: Colors.white,
      ),
    );

  }
}

class MenuJsonParser {
  String sub_cat_name;
  String sub_cat_id;
  String menu_name;
  String menu_full_price;
  String menu_image;

  MenuJsonParser(this.sub_cat_name, this.sub_cat_id , this.menu_name, this.menu_full_price, this.menu_image);

  factory MenuJsonParser.fromJson(dynamic json) {
    print(json['foodItem'].isEmpty);

    if(!json['foodItem'].isEmpty){
      return MenuJsonParser(
          json['sub_cat_name'] as String,
          json['sub_cat_id'] as String,
          json['foodItem'][0]['menu_name'] as String,
          json['foodItem'][0]['menu_full_price'] as String,
          json['foodItem'][0]['menu_image'] as String
      );
    }
    else{
      return MenuJsonParser(
          json['sub_cat_name'] as String,
          json['sub_cat_id'] as String,
          '',
          '',
          ''
      );
    }
  }
}