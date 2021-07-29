import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'HomeScreen.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class RestDetail extends StatefulWidget {
  _RestDetailState createState() => _RestDetailState();
  final RestaurantJsonParser rest;

// receive data from the FirstScreen as a parameter
  RestDetail({required this.rest});
}

class _RestDetailState extends State<RestDetail>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final PanelController _pc = new PanelController();
  List<MenuJsonParser> cart = [];
  List<MenuJsonParser> foodCategoryOne = [];
  List<MenuJsonParser> foodCategoryTwo = [];
  List<MenuJsonParser> foodCategoryThree = [];
  List<MenuJsonParser> foodCategoryFour = [];
  List completeList = [];
  bool _loading = true;
  List<String> categoryList = [];
  int counter = 0;

  int totalcounter = 0;

  List<Tag> tagObjs = [];

  @override
  void initState() {
    // initialise your tab controller here
    callList();
    //categoryList = ['Main Course', 'Beverages'];
    callAPIinLoop();
    _tabController = TabController(length: categoryList.length, vsync: this);
    super.initState();
  }

  Future<void> callList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String admin = prefs.getString('adminid').toString();
    String arrayObjsText =
        '{"status":"1","data":[{"id":"1","cat_id":"1","cat_name":"Vegetarian ","admin_id":"HRGR00001","creation_date":"2021-07-06 16:12:29","status":"1"},{"id":"5","cat_id":"5","cat_name":"Bakery","admin_id":"HRGR00001","creation_date":"2021-07-06 16:24:52","status":"1"},{"id":"6","cat_id":"6","cat_name":"main course","admin_id":"HRGR00001","creation_date":"2021-07-06 16:32:14","status":"1"}]}';
    print('dhoni1');
    var tagObjsJson = jsonDecode(arrayObjsText)['data'] as List;
    print('dhoni2');
    tagObjs = tagObjsJson.map((tagJson) => Tag.fromJson(tagJson)).toList();
    print('dhon3');
    setState(() {
      for (int i = 0; i < tagObjs.length; i++) {
        categoryList.insert(i, tagObjs[i].cat_name);
      }

      print('dhoni4' + categoryList[0].toString());
    });

    // var response;
    // String decodedResponse = '';
    // //API call here
    // var urlSent = Uri.encodeFull(
    //     'http://35.154.190.204/Restaurant/index.php/customer/Api/getRestaurantCategory');
    // var map = new Map<String, dynamic>();
    // map['admin_id'] = 'HRGR00001';
    // var url = Uri.parse(urlSent);
    // try {
    //   response = await http.post(url,
    //       body: map,
    //       headers: {"Content-Type": "application/x-www-form-urlencoded"},
    //       encoding: Encoding.getByName("utf-8"));
    //   decodedResponse = utf8.decode(response.bodyBytes);
    //   print('gulati'+decodedResponse);
    //   var jsonObjects = jsonDecode(decodedResponse)['data'] as List;

    // setState(() {
    //   categoryList.add(jsonObjects
    //       .map((jsonObject) => MenuJsonParser.fromJson(jsonObject))
    //       .toList());
    //
    //    print('heya'+categoryList.length.toString());
    // });
    // } catch (e) {
    //   //Write exception statement here
    //
    // }

    // try {
    //   var response;
    //   String decodedResponse = '';
    //API call here
    /* var urlSent = Uri.encodeFull(
        'http://35.154.190.204/Restaurant/index.php/customer/Api/getMenuListDataCustomer');
    var map = new Map<String, dynamic>();
    map['admin_id'] = 'HRGR00001';
    map['cat_id'] = cat_id.toString();
    var url = Uri.parse(urlSent);

      response = await http.post(url,
          body: map,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          encoding: Encoding.getByName("utf-8"));
      decodedResponse = utf8.decode(response.bodyBytes); */

    //Below line should be commented if there is no response from server, I have just hardcoded the response, please comment this and uncomment above part if server is working
    // decodedResponse =
    // '{"status":"1","data":[{"id":"1","cat_id":"1","cat_name":"Vegetarian ","admin_id":"HRGR00001","creation_date":"2021-07-06 16:12:29","status":"1"},{"id":"5","cat_id":"5","cat_name":"Bakery","admin_id":"HRGR00001","creation_date":"2021-07-06 16:24:52","status":"1"},{"id":"6","cat_id":"6","cat_name":"main course","admin_id":"HRGR00001","creation_date":"2021-07-06 16:32:14","status":"1"}]}';
    //
    // var jsonObjects = jsonDecode(decodedResponse)['data'] as List;
    // setState(() {
    //   completeList.add(jsonObjects
    //       .map((jsonObject) => MenuJsonParser.fromJson(jsonObject))
    //       .toList());
    //
    //   print('mayank'+completeList[0]['']);

    //   });
    // } catch (e) {
    //   //Write exception statement here
    //   print('In exception');
    // }
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

  void callAPIinLoop() async {
    for (int cat = 1; cat <= categoryList.length; cat++) {
      await callListApi(cat);
    }
  }

  Future<void> callListApi(int cat_id) async {
    try {
      var response;
      String decodedResponse = '';
      //API call here
      /* var urlSent = Uri.encodeFull(
        'http://35.154.190.204/Restaurant/index.php/customer/Api/getMenuListDataCustomer');
    var map = new Map<String, dynamic>();
    map['admin_id'] = 'HRGR00001';
    map['cat_id'] = cat_id.toString();
    var url = Uri.parse(urlSent);

      response = await http.post(url,
          body: map,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          encoding: Encoding.getByName("utf-8"));
      decodedResponse = utf8.decode(response.bodyBytes); */

      //Below line should be commented if there is no response from server, I have just hardcoded the response, please comment this and uncomment above part if server is working
      decodedResponse =
      '{"data":[{"sub_cat_name":"soup","sub_cat_id":"1","foodItem":[{"menu_name":"Soup","menu_full_price":"300","menu_category_id":4,"menu_id":"MENU_00006","cat_id":1,"sub_cat_id":1,"admin_id":"HRGR00001","qty":0,"half_qty":0,"full_qty":0,"positions":0,"menu_food_type":"Veg","cat_name":"Vegetarian","menu_image":"asd"}]}]}';

      var jsonObjects = jsonDecode(decodedResponse)['data'] as List;
      setState(() {
        completeList.add(jsonObjects
            .map((jsonObject) => MenuJsonParser.fromJson(jsonObject))
            .toList());

        if (cat_id == categoryList.length) {
          _loading = false;
        }
      });
    } catch (e) {
      //Write exception statement here
      print('In exception');
    }
  }

  /* void addToCart(MenuJsonParser menuItem) {
    setState(() {});
    // menuItem.quantity++;
    //
    //
    // cart.add(menuItem);
    // for(int i =0;i<cart.length;i++)
    // {
    //   var n = int.parse(cart[i].menu_fix_price);
    //   totalcounter = menuItem.quantity*n;
    // }
    //
    //
    // print('mayank'+totalcounter.toString());

    menuItem.quantity++;

    cart.add(menuItem);
    for (int i = 0; i < cart.length; i++) {
      int n = int.parse(cart[i].menu_fix_price);

      totalcounter = cart.length * n;
      //a = totalcounter;
    }
    // for (int count = 0; count < cart.length; count++) {
    //   var myInt = int.parse(cart[count].menu_fix_price);
    //   assert(myInt is int);
    //   totalcounter = totalcounter + myInt;
    //   print('mayank'+totalcounter.toString());
    // }
  }

  void removeFromCart(MenuJsonParser menuItem) {
    if (menuItem.quantity != 0) {
      setState(() {
        menuItem.quantity--;
      });
    }
  } */

  List<Widget> tabHeaders() {
    List<Widget> headersReturn = [];
    for (int cat = 0; cat < categoryList.length; cat++) {
      headersReturn.add(Text(categoryList[cat]));
    }
    return headersReturn;
  }

  List<Widget> tabDataEach() {
    List<Widget> widgetReturn = [];

    for (int cat = 0; cat < categoryList.length; cat++) {
      widgetReturn.add(
        ListView.builder(
            itemCount: completeList[cat].length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.all(2.0),
                child: ExpansionTile(
                  backgroundColor: Colors.green[50],
                  collapsedBackgroundColor: Colors.green[50],
                  onExpansionChanged: (e) {
                    //Your code
                  },
                  title: Text(completeList[cat][index].sub_cat_name),
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: completeList[cat][index].foodItem.length,
                        itemBuilder: (BuildContext context, int indexAnother) {
                          return Container(
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
                                  child: Image.asset(
                                      'assets/dummyRestaurant.png',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover)

                                  /* _displayImage(
                            base64Decode(completeList[cat][index].menu_image)) */
                                  ,
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
                                                  completeList[cat][index]
                                                      .foodItem[indexAnother]
                                                      .menu_name,
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.black,
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                                Text(
                                                  'COST: Rs ' +
                                                      completeList[cat][index]
                                                          .foodItem[
                                                      indexAnother]
                                                          .menu_full_price,
                                                  style: TextStyle(
                                                    fontSize: 10.0,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.red),
                                                  borderRadius:
                                                  BorderRadius.circular(4)),
                                              child: Row(
                                                children: [
                                                  InkWell(
                                                      onTap: () =>
                                                      {} /* removeFromCart(
                                                completeList[cat][index]) */
                                                      ,
                                                      child: Container(
                                                        child: Padding(
                                                          padding:
                                                          EdgeInsets.only(
                                                              left: 3,
                                                              right: 3),
                                                          child: Icon(
                                                            Icons
                                                                .delete_outline,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      )),
                                                  Container(
                                                      height: double.infinity,
                                                      width: 30,
                                                      color: Colors.red,
                                                      child: Center(
                                                          child: Text(
                                                            completeList[cat][index]
                                                                .foodItem[
                                                            indexAnother]
                                                                .quantity
                                                                .toString(),
                                                            style: TextStyle(
                                                                color:
                                                                Colors.white),
                                                          ))),
                                                  InkWell(
                                                      onTap: () =>
                                                      {} /*addToCart(
                                                completeList[cat][index]) */
                                                      ,
                                                      child: Container(
                                                        child: Padding(
                                                          padding:
                                                          EdgeInsets.only(
                                                              left: 3,
                                                              right: 3),
                                                          child: Icon(
                                                            Icons.add_outlined,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ))
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        })
                  ],
                ),
              );
            }),
      );
    }

    return widgetReturn;
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
              Container(
                decoration:
                BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 5.0,
                      blurRadius: 10.0),
                ]),
                margin: EdgeInsets.all(2.0),
                child: Row(
                  children: [
                    ClipRRect(
                        child: widget.rest.image.isEmpty
                            ? Image.asset('assets/dummyRestaurant.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover)
                            : Image.network(widget.rest.image,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover)),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: SizedBox(
                        width: 250, // set this
                        child: Column(
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
                                      fontSize: 12.0,
                                      color: Colors.grey)),
                              Text('Cuisines ' + widget.rest.cuisines,
                                  style: TextStyle(
                                      fontSize: 11.0,
                                      color: Colors.grey)),
                            ]),
                      ),
                    )
                  ],
                ),
              ),
              IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                          child: Container(
                            decoration:
                            BoxDecoration(color: Colors.white, boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 2.0,
                                  blurRadius: 5.0),
                            ]),
                            margin: EdgeInsets.all(2.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Image.asset(
                                  'assets/star.png',
                                  width: 50,
                                  height: 50,
                                ),
                                Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('RATINGS',
                                            style: TextStyle(
                                                fontSize: 12.0, color: Colors.black)),
                                        Text(widget.rest.rating,
                                            style: TextStyle(
                                                fontSize: 11.0, color: Colors.grey))
                                      ],
                                    ))
                              ],
                            ),
                          )),
                      Expanded(
                          child: Container(
                            decoration:
                            BoxDecoration(color: Colors.white, boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 2.0,
                                  blurRadius: 5.0),
                            ]),
                            margin: EdgeInsets.all(2.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Image.asset(
                                  'assets/card.PNG',
                                  width: 50,
                                  height: 50,
                                ),
                                Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('COST FOR 2',
                                            style: TextStyle(
                                                fontSize: 12.0, color: Colors.black)),
                                        Text(widget.rest.cost,
                                            style: TextStyle(
                                                fontSize: 11.0, color: Colors.grey))
                                      ],
                                    ))
                              ],
                            ),
                          ))
                    ],
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      primary: Colors.white,
                      side: BorderSide(color: Colors.red, width: 1),
                    ),
                    label: Text(
                      'Call',
                      style: TextStyle(color: Colors.red),
                    ),
                    icon: Icon(
                      Icons.phone_outlined,
                      color: Colors.red,
                      size: 20,
                    ),
                    onPressed: () {
                      print('Pressed');
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      primary: Colors.white,
                      side: BorderSide(color: Colors.red, width: 1),
                    ),
                    label: Text(
                      'Directions',
                      style: TextStyle(color: Colors.red),
                    ),
                    icon: Icon(Icons.pin_drop_outlined,
                        color: Colors.red, size: 20),
                    onPressed: () {
                      print('Pressed');
                    },
                  )
                ],
              ),
              TabBar(
                controller: _tabController,
                labelColor: Colors.red,
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.label,
                //indicator: BoxDecoration(color: Colors.red),
                indicatorColor: Colors.red,
                unselectedLabelColor: Colors.grey,
                unselectedLabelStyle: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  //fontWeight: FontWeight.w700,
                ),
                labelStyle: TextStyle(
                  fontSize: 20,
                  //fontWeight: FontWeight.w700,
                ),
                tabs: tabHeaders(),
              ),
              Expanded(
                child: TabBarView(
                    controller: _tabController, children: tabDataEach()
                  /* [Column(children: tabDataList(),),Container(),Container(),Container(),] */
                ),
              ),
              SlidingUpPanel(
                collapsed: Column(
                  children: [
                    InkWell(
                        child: Text('VIEW CART',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                        onTap: () {
                          _pc.open();
                        })
                  ],
                ),
                panel: Column(
                  children: [
                    //Make CART UI here
                    Container(
                      margin: EdgeInsets.only(top: 35, bottom: 5),
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Your Items',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),

                    Expanded(
                        child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [Colors.white, Colors.white],
                                )),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.all(15),
                                    alignment: Alignment.topLeft,
                                    child: Text("Bill Detail",
                                        style: TextStyle(
                                            color: Colors.orange,
                                            fontSize: 25,
                                            fontWeight:
                                            FontWeight.bold))),
                                Divider(
                                  color: Colors.orange,
                                  thickness: 2,
                                  height: 1,
                                ),
                                Row(
                                  children: [
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.all(10.0),
                                          child: Text('Total Items ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20)),
                                        )),
                                    Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.fromLTRB(
                                              100.0, 0.0, 0.0, 0.0),
                                          child: Text(
                                              cart.length.toString(),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20)),
                                        )),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.all(10.0),
                                          child: Text('Total Amount ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20)),
                                        )),
                                    Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.fromLTRB(
                                              100.0, 0.0, 0.0, 0.0),
                                          child: Text(
                                              totalcounter.toString(),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20)),
                                        )),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.all(10.0),
                                          child: Text('GST amount ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20)),
                                        )),
                                    Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.fromLTRB(
                                              100.0, 0.0, 0.0, 0.0),
                                          child: Text('',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20)),
                                        )),
                                  ],
                                ),
                              ],
                            ))),
                  ],
                ),
                minHeight: 40,
                maxHeight: 300,
                color: Colors.orange,
                backdropOpacity: 0.5,
                controller: _pc,
              ),
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
  List<FoodItem> foodItem;

  MenuJsonParser(this.sub_cat_name, this.sub_cat_id, this.foodItem);

  factory MenuJsonParser.fromJson(dynamic json) {
    if (!json['foodItem'].isEmpty) {
      var list = json['foodItem'] as List;
      List<FoodItem> foodItemList =
      list.map((i) => FoodItem.fromJson(i)).toList();
      return MenuJsonParser(json['sub_cat_name'] as String,
          json['sub_cat_id'] as String, foodItemList);
    } else {
      return MenuJsonParser(
          json['sub_cat_name'] as String, json['sub_cat_id'] as String, []);
    }
  }
}

class FoodItem {
  String? menu_name;
  String? menu_full_price;
  String? menu_image;
  int quantity = 0;

  FoodItem({this.menu_name, this.menu_full_price, this.menu_image});

  factory FoodItem.fromJson(dynamic json) {
    return FoodItem(
        menu_name: json['menu_name'],
        menu_full_price: json['menu_full_price'],
        menu_image: json['menu_image']);
  }


}

class Tag {
  String cat_name;

  Tag(this.cat_name);

  factory Tag.fromJson(dynamic json) {
    return Tag(json['cat_name'] as String);
  }
}