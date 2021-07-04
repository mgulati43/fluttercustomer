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
  // Fluttertoast.showToast(
  // msg: rest.admin_id,
  // toastLength: Toast.LENGTH_SHORT,
  // gravity: ToastGravity.SNACKBAR,
  // backgroundColor: Colors.red,
  // textColor: Colors.black,
  // fontSize: 16.0,
  // );
}

class _RestDetailState extends State<RestDetail>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<MenuJsonParser> foodCategoryOne = [];
  List<MenuJsonParser> foodCategoryTwo = [];
  List<MenuJsonParser> foodCategoryThree = [];
  List<MenuJsonParser> foodCategoryFour = [];
  bool _loading = true;

  @override
  void initState() {
    // initialise your tab controller here
    callListApi('1');
    callListApiTwo('2');
    callListApiThree('3');
    callListApiFour('4');
    _tabController = TabController(length: 4, vsync: this);
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
        foodCategoryOne = jsonObjects
            .map((jsonObject) => MenuJsonParser.fromJson(jsonObject))
            .toList();
        print('one' + foodCategoryOne.toString());
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
        foodCategoryTwo = jsonObjects
            .map((jsonObject) => MenuJsonParser.fromJson(jsonObject))
            .toList();
        print('two' + foodCategoryTwo.toString());
        _loading = false;
      });
    } catch (e) {
      //Write exception statement here

    }
  }

  void callListApiThree(String cat_id) async {
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
        foodCategoryThree = jsonObjects
            .map((jsonObject) => MenuJsonParser.fromJson(jsonObject))
            .toList();
        print('three' + foodCategoryThree.toString());
        _loading = false;
      });
    } catch (e) {
      //Write exception statement here

    }
  }

  void callListApiFour(String cat_id) async {
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
        foodCategoryFour = jsonObjects
            .map((jsonObject) => MenuJsonParser.fromJson(jsonObject))
            .toList();
        print('three' + foodCategoryFour.toString());
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
          backgroundColor: Colors.white,
          //add back arrow
        ),
        body: _loading == false
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Column(
                  children: <Widget>[
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            widget.rest.name,
                            style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Text(widget.rest.address,
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.grey)),
                          Text('Cuisines ' + widget.rest.cuisines,
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.grey)),
                          Row(children: [
                            Icon(Icons.timer, color: Colors.grey),
                            Text(' 30 mins | ',
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.grey)),
                            Icon(Icons.location_on, color: Colors.grey),
                            Text(' 3.8 kms',
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.grey))
                          ])
                        ]),

                    Row(
                      children: [
                        Card(
                          child: Container(
                            width: 200.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                              children: [
                                Text(
                                  'Rating',
                                  style: TextStyle(color: Colors.black),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
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
                        Text('MAIN COURSE'),
                        Text('BEVERAGES'),
                        Text('SWEETS'),
                        Text('DESSERTS')
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black12,
                                              spreadRadius: 2.0,
                                              blurRadius: 5.0),
                                        ]),
                                    margin: EdgeInsets.all(5.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10.0),
                                              bottomLeft:
                                                  Radius.circular(10.0)),
                                          child: _displayImage(base64Decode(
                                              foodCategoryOne[index]
                                                  .menu_image)),
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
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Text(
                                                          foodCategoryOne[index]
                                                              .sub_cat_name,
                                                          style: TextStyle(
                                                              fontSize: 15.0,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          'COST: Rs ' +
                                                              foodCategoryOne[
                                                                      index]
                                                                  .menu_full_price,
                                                          style: TextStyle(
                                                            fontSize: 10.0,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 4.0),
                                                      child: ElevatedButton(
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all<Color>(
                                                                        Colors
                                                                            .red)),
                                                        onPressed: () => null,
                                                        child: Text(
                                                          'SEE MENU',
                                                          style: TextStyle(
                                                              fontSize: 12.0,
                                                              color:
                                                                  Colors.white),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black12,
                                              spreadRadius: 2.0,
                                              blurRadius: 5.0),
                                        ]),
                                    margin: EdgeInsets.all(5.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10.0),
                                              bottomLeft:
                                                  Radius.circular(10.0)),
                                          child: _displayImage(base64Decode(
                                              foodCategoryTwo[index]
                                                  .menu_image)),
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
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Text(
                                                          foodCategoryTwo[index]
                                                              .sub_cat_name,
                                                          style: TextStyle(
                                                              fontSize: 15.0,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          'COST: Rs ' +
                                                              foodCategoryTwo[
                                                                      index]
                                                                  .menu_full_price,
                                                          style: TextStyle(
                                                            fontSize: 10.0,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 4.0),
                                                      child: ElevatedButton(
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all<Color>(
                                                                        Colors
                                                                            .red)),
                                                        onPressed: () => null,
                                                        child: Text(
                                                          'SEE MENU',
                                                          style: TextStyle(
                                                              fontSize: 12.0,
                                                              color:
                                                                  Colors.white),
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
                              itemCount: foodCategoryThree.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black12,
                                              spreadRadius: 2.0,
                                              blurRadius: 5.0),
                                        ]),
                                    margin: EdgeInsets.all(5.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10.0),
                                              bottomLeft:
                                                  Radius.circular(10.0)),
                                          child: _displayImage(base64Decode(
                                              foodCategoryThree[index]
                                                  .menu_image)),
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
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Text(
                                                          foodCategoryThree[
                                                                  index]
                                                              .sub_cat_name,
                                                          style: TextStyle(
                                                              fontSize: 15.0,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          'COST: Rs ' +
                                                              foodCategoryThree[
                                                                      index]
                                                                  .menu_full_price,
                                                          style: TextStyle(
                                                            fontSize: 10.0,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 4.0),
                                                      child: ElevatedButton(
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all<Color>(
                                                                        Colors
                                                                            .red)),
                                                        onPressed: () => null,
                                                        child: Text(
                                                          'SEE MENU',
                                                          style: TextStyle(
                                                              fontSize: 12.0,
                                                              color:
                                                                  Colors.white),
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
                              itemCount: foodCategoryFour.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black12,
                                              spreadRadius: 2.0,
                                              blurRadius: 5.0),
                                        ]),
                                    margin: EdgeInsets.all(5.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10.0),
                                              bottomLeft:
                                                  Radius.circular(10.0)),
                                          child: _displayImage(base64Decode(
                                              foodCategoryThree[index]
                                                  .menu_image)),
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
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Text(
                                                          foodCategoryFour[
                                                                  index]
                                                              .sub_cat_name,
                                                          style: TextStyle(
                                                              fontSize: 15.0,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          'COST: Rs ' +
                                                              foodCategoryFour[
                                                                      index]
                                                                  .menu_full_price,
                                                          style: TextStyle(
                                                            fontSize: 10.0,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 4.0),
                                                      child: ElevatedButton(
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all<Color>(
                                                                        Colors
                                                                            .red)),
                                                        onPressed: () => null,
                                                        child: Text(
                                                          'SEE MENU',
                                                          style: TextStyle(
                                                              fontSize: 12.0,
                                                              color:
                                                                  Colors.white),
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
                        ],
                      ),
                    ),
                    //Text('demo'),
                  ],
                ),
              )
            : Container(
                child: Image(
                image: AssetImage('assets/loading.gif'),
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

  MenuJsonParser(this.sub_cat_name, this.sub_cat_id, this.menu_name,
      this.menu_full_price, this.menu_image);

  factory MenuJsonParser.fromJson(dynamic json) {
    print(json['foodItem'].isEmpty);

    if (!json['foodItem'].isEmpty) {
      return MenuJsonParser(
          json['sub_cat_name'] as String,
          json['sub_cat_id'] as String,
          json['foodItem'][0]['menu_name'] as String,
          json['foodItem'][0]['menu_full_price'] as String,
          json['foodItem'][0]['menu_image'] as String);
    } else {
      return MenuJsonParser(json['sub_cat_name'] as String,
          json['sub_cat_id'] as String, '', '', '');
    }
  }
}

Widget _buildLoginBtn() {
  return Container();
}
