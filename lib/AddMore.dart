import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ViewOrder.dart';
import 'package:http/http.dart' as http;
import 'RestaurantDetail.dart';
import 'dart:convert';
import 'AddToCart.dart';
import 'sideBar.dart';

class AddMore extends StatefulWidget {

  final Order orderData;

// receive data from the FirstScreen as a parameter
  AddMore({required this.orderData});
  @override
  _AddMoreState createState() => _AddMoreState();
}

class _AddMoreState extends State<AddMore> with SingleTickerProviderStateMixin{
  TabController? _tabController;
  var cartMap = new Map<String, FoodItem>();
  List completeList = [];
  bool _loading = true;
  List<String> categoryList = [];
  int counter = 0;
  var totalcounter = 0;
  var totalGST = 0;
  List<Tag> tagObjs = [];
  String admin = '';
  ScrollController _controller = new ScrollController();

  @override
  void initState() {
    admin = widget.orderData.admin_id!;
    // initialise your tab controller here
    callList();
    super.initState();
  }

  Future<void> callList() async {

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
      map['admin_id'] = admin;
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
      var gstItem = int.tryParse(foodItem.menu_fix_price_gst ?? "");
      if (price == null) {
        print("bad price");
      } else {
        totalcounter += price;
        totalGST += gstItem ?? 0;
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

  void navigateToOrderPage(context){
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => AddToCart(cart: cartMap, admin_id: admin,totalcounter: totalcounter, gst: totalGST, tableNumber: widget.orderData.table_no!, order_id: widget.orderData.order_id,waiter_mobile_no: widget.orderData.waiter_mobile_no,)));
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
                                  // child: _displayImage(base64Decode(
                                  //     completeList[cat][index]
                                  //         .foodItem[indexAnother]
                                  //         .menu_image))
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawer: SideBar(),
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          title: Text("Add More Items"),
          iconTheme: IconThemeData(color: Colors.orange),
        ),
        body: _loading == false
            ? Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Column(
            children: <Widget>[
          TextFormField(
            readOnly: true,
            enabled: false,
          decoration: InputDecoration(
            hintText: 'Table Number: ' + widget.orderData.table_no!,
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          ),

        ),
              SizedBox(height: 10),
              Table(

                children: [
                  TableRow(
                      decoration: BoxDecoration(

                        color: Colors.deepOrange,
        ),
                      children: [
                        Container(
                            padding: EdgeInsets.all(10.0),
                            child:
                    Text('MENU',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                            FontWeight.bold,
                            color: Colors.white))),
                        Container(
                            padding: EdgeInsets.all(10.0),
                            child:
                    Text('QUANTITY',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                            FontWeight.bold,
                            color: Colors.white))),
                        Container(
                            padding: EdgeInsets.all(10.0),
                            child:
                    Text('PRICE',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                            FontWeight.bold,
                            color: Colors.white))),
                  ]),
                ],
              ),

              SizedBox(height: 5),
              ListView.builder(
                  controller: _controller,
                  physics:
                  const AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: widget.orderData
                      .orderItem
                      ?.length,
                  itemBuilder:
                      (context, anotherIndex) {
                    return Container(
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                  widget.orderData
                                      .orderItem![
                                  anotherIndex]
                                      .menuName,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color:
                                      Colors.black)),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                  widget.orderData
                                      .orderItem![
                                  anotherIndex]
                                      .quantity,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color:
                                      Colors.black)),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                  widget.orderData
                                      .orderItem![
                                  anotherIndex]
                                      .price,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                      FontWeight.bold,
                                      color:
                                      Colors.black)),
                            ),
                          ],
                        ));
                  }),
              SizedBox(height: 5),
              Divider(
                color: Colors.orange,
                thickness: 2,
                height: 1,
              ),
              SizedBox(height: 10),
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
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(20)),
                    child: FlatButton(
                      onPressed: () => navigateToOrderPage(context),
                      child: Text(
                        'View Cart',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              )
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
