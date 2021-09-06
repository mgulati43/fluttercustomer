import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'RestaurantDetail.dart';
import 'dart:convert';
import 'package:rflutter_alert/rflutter_alert.dart';

class AddToCart extends StatefulWidget {
  _AddToCartState createState() => _AddToCartState();
  final Map<String, FoodItem> cart;
  final totalcounter;
  final admin_id;
  final gst;

// receive data from the FirstScreen as a parameter
  AddToCart({required this.cart, required this.totalcounter, required this.admin_id, required this.gst});
}

class _AddToCartState extends State<AddToCart> {
  Map<String, String> cartPageInfo = new Map<String, String>();
  final tableController = TextEditingController();
  var totalGst = 0;
  void initState(){

    String menu_item_name = '';
    String menu_id = '';
    String gst_amount = '';
    String gst_amount_price = '';
    String quantity = '';
    String menu_price = '';
    String half_and_full_status = '';
    cartPageInfo['admin_id'] = widget.admin_id;
    cartPageInfo['cus_id'] = 'CUS_000007'; //put dynamic value from OTP API
    cartPageInfo['customer_mobile_no'] = '9899988817'; //put dynamic value from OTP API
    cartPageInfo['total_price'] = widget.totalcounter.toString();
    cartPageInfo['total_item'] = widget.cart.length.toString();
    cartPageInfo['net_pay_amount'] = widget.totalcounter.toString();

    cartPageInfo['order_status'] = 'Pending';

    for (var k in widget.cart.keys) {
      menu_item_name += widget.cart[k]!.menu_name.toString() + ',';
      menu_id += widget.cart[k]!.menu_id.toString() + ',';
      gst_amount += widget.cart[k]!.gst.toString() + ',';
      gst_amount_price += widget.cart[k]!.menu_fix_price_gst.toString() + ',';
      quantity += widget.cart[k]!.quantity.toString()+ ',';
      menu_price += widget.cart[k]!.menu_fix_price.toString() + ',';
      half_and_full_status += 'F,'; //Dont know what to do with this since this in not in API
    }

    cartPageInfo['menu_item_name'] = menu_item_name;
    cartPageInfo['menu_id'] = menu_id;
    cartPageInfo['gst_amount'] = gst_amount;
    cartPageInfo['gst_amount_price'] = gst_amount_price;
    cartPageInfo['quantity'] = quantity;
    cartPageInfo['menu_price'] = menu_price;
    cartPageInfo['half_and_full_status'] = half_and_full_status;
    print(cartPageInfo);

    super.initState();
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
              controller: tableController,
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

  void orderPlacement(context){
    //Here make the api call to submit cart items
    orderPlacementAPI();


  }

  Future<void> orderPlacementAPI() async {
    var response;
    String decodedResponse = '';
    cartPageInfo['table_no'] = tableController.text;
    print(cartPageInfo);
    // //API call here
    var urlSent = Uri.encodeFull(
        'http://dev.goolean.com/Restaurant/index.php/customer/Api/add_order_detail_for_restaurant');
    var url = Uri.parse(urlSent);
    try {
      response = await http.post(url,
          body: cartPageInfo,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          encoding: Encoding.getByName("utf-8"));
      decodedResponse = utf8.decode(response.bodyBytes);
      print(decodedResponse);
      var orderStatus = jsonDecode(decodedResponse)['data']["status"] as String;
      var orderMessage = jsonDecode(decodedResponse)['data']["message"] as String;
      Navigator.pop(context);
      if(orderStatus == '1'){
        successfulOrderPlace(context);
      }
      else{
        failedOrderPlace(context, orderMessage);
      }


    }
    catch(e){
      print('In exception');
    }
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

  failedOrderPlace(context, orderMessage) {
    Alert(
        context: context,
        title: "Failure",
        content: Text(orderMessage),
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

  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.orange,
              //add back arrow
            ),
            body: Column(
              children: [
                //Make CART UI here
                Container(
                  margin:
                  EdgeInsets.only(top: 35, bottom: 5, left: 10),
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Your Items',
                    style: TextStyle(
                        color: Colors.black,
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
                              style: TextStyle(color: Colors.black)),
                          Text('Quantity',
                              style: TextStyle(color: Colors.black)),
                          Text('Price',
                              style: TextStyle(color: Colors.black))
                        ])),
                Padding(
                    padding: EdgeInsets.only(left: 10, right: 20),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.cart.length,
                        itemBuilder: (context, index) {
                          String key = widget.cart.keys.elementAt(index);
                          return Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(widget.cart[key]?.menu_name ?? '',
                                  style:
                                  TextStyle(color: Colors.black)),
                              Text(
                                  (widget.cart[key]?.quantity).toString(),
                                  style:
                                  TextStyle(color: Colors.black)),
                              Text(
                                  (widget.cart[key]?.menu_fix_price ?? '')
                                      .toString(),
                                  style:
                                  TextStyle(color: Colors.black))
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
                                      widget.cart.length.toString(),
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
                                  child: Text(widget.totalcounter.toString(),
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
                                  padding:
                                  const EdgeInsets.all(10.0),
                                  child: Text('GST amount ',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20)),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(
                                      10, 10, 100, 10),
                                  child: Text(widget.gst.toString(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20)),
                                ),
                              ],
                            ),

                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all<Color>(
                                      Colors.red)),
                              onPressed: () => onPressOfOrderPlace(
                                  context),
                              child: Text(
                                'Place Order',
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ))),
              ],
            )));
  }
}


/*class FoodItem {
  String? menu_name;
  String? menu_fix_price;
  String? menu_image;
  String? menu_id;
  int quantity = 0;
  int? half_qty = 0;
  int? full_qty = 0;
}*/