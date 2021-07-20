import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
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

  @override
  void initState() {
    // initialise your tab controller here

    categoryList = ['Main Course', 'Beverages'];
    callAPIinLoop();
    _tabController = TabController(length: categoryList.length, vsync: this);
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

  void callAPIinLoop() async {
    for (int cat = 1; cat <= categoryList.length; cat++) {
      await callListApi(cat);
    }
  }

  Future<void> callListApi(int cat_id) async {
    var response;
    String decodedResponse = '';
    //API call here
    var urlSent = Uri.encodeFull(
        'http://35.154.190.204/Restaurant/index.php/customer/Api/getMenuListDataCustomer');
    var map = new Map<String, dynamic>();
    map['admin_id'] = 'HRGR00001';
    map['cat_id'] = cat_id.toString();
    var url = Uri.parse(urlSent);
    try {
      response = await http.post(url,
          body: map,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          encoding: Encoding.getByName("utf-8"));
      decodedResponse = utf8.decode(response.bodyBytes);

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

    }
  }

  void addToCart(MenuJsonParser menuItem) {
    setState(() {
      menuItem.quantity++;
      cart.add(menuItem);
      counter = counter + 1;
    });
  }

  void removeFromCart(MenuJsonParser menuItem) {
    if (menuItem.quantity != 0) {
      setState(() {
        menuItem.quantity--;
      });
    }
  }

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
                        child: _displayImage(
                            base64Decode(completeList[cat][index].menu_image)),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        completeList[cat][index].sub_cat_name,
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'COST: Rs ' +
                                            completeList[cat][index]
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
                                        border: Border.all(color: Colors.red),
                                        borderRadius: BorderRadius.circular(4)),
                                    child: Row(
                                      children: [
                                        InkWell(
                                            onTap: () => removeFromCart(
                                                completeList[cat][index]),
                                            child: Container(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 3, right: 3),
                                                child: Icon(
                                                  Icons.delete_outline,
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
                                                  .quantity
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ))),
                                        InkWell(
                                            onTap: () => addToCart(
                                                completeList[cat][index]),
                                            child: Container(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 3, right: 3),
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
                                    Row(children: [
                                      Icon(Icons.timer, color: Colors.grey),
                                      Text(' 30 mins | ',
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.grey)),
                                      Icon(Icons.location_on,
                                          color: Colors.grey),
                                      Text(' 3.8 kms',
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.grey))
                                    ])
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
                                  Text('3.7',
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
                                  Text('350',
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
                      panel: Column(
                        children: [
                          //Make CART UI here
                          Container(
                            child: Text('This is column text'),
                          ),
                          InkWell(
                          child: Text('VIEW CART', style: TextStyle(color: Colors.white)),
                          onTap: () {
                            _pc.open();
                          }
                        )
                        ],
                      ),
                      minHeight: 50,
                      maxHeight: 300,
                      backdropColor: Colors.red,
                      color: Colors.red,
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
  String menu_name;
  String menu_full_price;
  String menu_image;
  int quantity;

  MenuJsonParser(this.sub_cat_name, this.sub_cat_id, this.menu_name,
      this.menu_full_price, this.menu_image, this.quantity);

  factory MenuJsonParser.fromJson(dynamic json) {
    if (!json['foodItem'].isEmpty) {
      return MenuJsonParser(
          json['sub_cat_name'] as String,
          json['sub_cat_id'] as String,
          json['foodItem'][0]['menu_name'] as String,
          json['foodItem'][0]['menu_full_price'] as String,
          json['foodItem'][0]['menu_image'] as String,
          0);
    } else {
      return MenuJsonParser(json['sub_cat_name'] as String,
          json['sub_cat_id'] as String, '', '', '', 0);
    }
  }
}
