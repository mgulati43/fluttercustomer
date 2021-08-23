import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'HomeScreen.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
  var cartMap = new Map<String, FoodItem>();
  List completeList = [];
  bool _loading = true;
  List<String> categoryList = [];
  int counter = 0;
  var totalcounter = 0;
  List<Tag> tagObjs = [];
  @override
  void initState() {
    // initialise your tab controller here
    callList();
    super.initState();
  }

  Future<void> callList() async {
    String admin = widget.rest.admin_id;
    var response;
    String decodedResponse = '';
    // //API call here
    var urlSent = Uri.encodeFull(
        'http://dev.goolean.com/Restaurant/index.php/customer/Api/getRestaurantCategory');
    var map = new Map<String, dynamic>();
    map['admin_id'] = admin;
    var url = Uri.parse(urlSent);
    try {
      response = await http.post(url,
          body: map,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          encoding: Encoding.getByName("utf-8"));
      decodedResponse = utf8.decode(response.bodyBytes);

      var jsonObjects = jsonDecode(decodedResponse)['data'] as List;
      tagObjs = jsonObjects.map((tagJson) => Tag.fromJson(tagJson)).toList();
      setState(() {
        for (int i = 0; i < tagObjs.length; i++) {
          categoryList.insert(i, tagObjs[i].cat_name);
        }
      });
      _tabController = TabController(length: tagObjs.length, vsync: this);
      callAPIinLoop();
    } catch (e) {
      //Write exception statement here
      print(e);
    }
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
    for (int cat = 0; cat < tagObjs.length; cat++) {
      print('This is the category id: ' + tagObjs[cat].cat_id);
      await callListApi(tagObjs[cat].cat_id);
      setState(() {
        if(cat == tagObjs.length -1){
          print('set loading false');
          _loading = false;
        }
      });

    }
  }

  Future<void> callListApi(String cat_id) async {
    try {
      var response;
      String decodedResponse = '';
      //API call here
      var urlSent = Uri.encodeFull(
          'http://dev.goolean.com/Restaurant/index.php/customer/Api/getMenuListDataCustomer');
      var map = new Map<String, dynamic>();
      map['admin_id'] = 'HRGR00001';
      map['cat_id'] = cat_id;
      var url = Uri.parse(urlSent);

      response = await http.post(url,
          body: map,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          encoding: Encoding.getByName("utf-8"));
      decodedResponse = utf8.decode(response.bodyBytes);
      //Below line should be commented if there is no response from server, I have just hardcoded the response, please comment this and uncomment above part if server is working
      /*decodedResponse =
      '{"data":[{"sub_cat_name":"soup","sub_cat_id":"1","foodItem":[{"menu_name":"Soup","menu_full_price":"300","menu_category_id":4,"menu_id":"MENU_00006","cat_id":1,"sub_cat_id":1,"admin_id":"HRGR00001","qty":0,"half_qty":0,"full_qty":0,"positions":0,"menu_food_type":"Veg","cat_name":"Vegetarian","menu_image":"asd"}]}]}';
*/
      var jsonObjects = jsonDecode(decodedResponse)['data'] as List;
      print(jsonObjects);
      setState(() {
        completeList.add(jsonObjects
            .map((jsonObject) => MenuJsonParser.fromJson(jsonObject))
            .toList());
      }
      );
    } catch (e) {
      //Write exception statement here
      print('In exception');
    }
  }

  void addToCart(FoodItem foodItem) {
    setState(() {
      foodItem.quantity++;
      //String menuId = foodItem['menu_id'];
      cartMap[foodItem.menu_id ?? ""] = foodItem;
      print(cartMap);
      var price = int.tryParse(foodItem.menu_fix_price ?? "");
      if (price == null) {
        print("bad price");
      } else {
        totalcounter += price;
        print(totalcounter);
      }
    });
  }

  void removeFromCart(FoodItem foodItem) {
    if (foodItem.quantity != 0) {
      setState(() {
        foodItem.quantity--;
        var price = int.tryParse(foodItem.menu_fix_price ?? "");
        if (price == null) {
          print("bad price");
        } else {
          totalcounter -= price;
          print(totalcounter);
        }
        if (foodItem.quantity == 0) {
          cartMap.remove(foodItem.menu_id);
        }
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
                                    child: _displayImage(base64Decode(
                                        completeList[cat][index]
                                            .foodItem[indexAnother]
                                            .menu_image))),
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
                                                          .menu_fix_price,
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
                                                          removeFromCart(
                                                              completeList[cat][
                                                              index]
                                                                  .foodItem[
                                                              indexAnother]),
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
                                                      onTap: () => addToCart(
                                                          completeList[cat]
                                                          [index]
                                                              .foodItem[
                                                          indexAnother]),
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

  // Modal alert for order confirm
  onPressOfOrderPlace(context) {
    Alert(
        context: context,
        title: "Select Table",
        content: Column(
          children: <Widget>[
            Text('Please call the waiter for asking the table number and proceed with the order.'),
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter Table Number*',
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            color: Colors.red,
            onPressed: () => orderPlacement(context),
            child: Text(
              "Order Place",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  successfulOrderPlace(context) {
    Alert(
        context: context,
        title: "Success",
        content: Text('Your order has been placed'),
        buttons: [
          DialogButton(
            color: Colors.red,
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Close",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]
    ).show();
  }

  void orderPlacement(context){
    //Here make the api call to submit cart items
    Navigator.pop(context);
    successfulOrderPlace(context);
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
                      margin:
                      EdgeInsets.only(top: 35, bottom: 5, left: 10),
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Your Items',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 10, right: 20),
                        child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Menu Name',
                                  style: TextStyle(color: Colors.white)),
                              Text('Quantity',
                                  style: TextStyle(color: Colors.white)),
                              Text('Price',
                                  style: TextStyle(color: Colors.white))
                            ])),
                    Padding(
                        padding: EdgeInsets.only(left: 10, right: 20),
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: cartMap.length,
                            itemBuilder: (context, index) {
                              String key = cartMap.keys.elementAt(index);
                              return Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(cartMap[key]?.menu_name ?? '',
                                      style:
                                      TextStyle(color: Colors.white)),
                                  Text(
                                      (cartMap[key]?.quantity).toString(),
                                      style:
                                      TextStyle(color: Colors.white)),
                                  Text(
                                      (cartMap[key]?.menu_fix_price ?? '')
                                          .toString(),
                                      style:
                                      TextStyle(color: Colors.white))
                                ],
                              );
                            })),

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
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text('Total Items ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 10, 100, 10),
                                      child: Text(
                                          cartMap.length.toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20)),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text('Total Amount ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 10, 100, 10),
                                      child: Text(totalcounter.toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20)),
                                    ),
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
                                //comments
                                ElevatedButton(
                                  child: Text('PLACE ORDER'),
                                  onPressed: () => onPressOfOrderPlace(context),
                                ),
                              ],
                            ))),
                  ],
                ),
                minHeight: 40,
                maxHeight:400,
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
  String? menu_fix_price;
  String? menu_image;
  String? menu_id;
  int quantity = 0;

  FoodItem(
      {this.menu_name, this.menu_fix_price, this.menu_image, this.menu_id});

  factory FoodItem.fromJson(dynamic json) {
    return FoodItem(
        menu_name: json['menu_name'],
        menu_fix_price: json['menu_fix_price'],
        menu_image: json['menu_image'],
        menu_id: json['menu_id']);
  }
}

class Tag {
  String cat_name;
  String cat_id;
  Tag(this.cat_name, this.cat_id);

  factory Tag.fromJson(dynamic json) {
    return Tag(json['cat_name'] as String,json['cat_id'] as String);
  }
}