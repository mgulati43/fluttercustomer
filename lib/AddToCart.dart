import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'RestaurantDetail.dart';

class AddToCart extends StatefulWidget {
  _AddToCartState createState() => _AddToCartState();
  final Map<String, FoodItem> cart;
  final totalcounter;
  final admin_id;

// receive data from the FirstScreen as a parameter
  AddToCart({required this.cart, required this.totalcounter, required this.admin_id});
}

class _AddToCartState extends State<AddToCart> {
  Map<String, String> cartPageInfo = new Map<String, String>();
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
    cartPageInfo['table_no'] = '34'; //replace with real value
    cartPageInfo['total_price'] = widget.totalcounter.toString();
    cartPageInfo['gst_amount'] = '20';
    cartPageInfo['total_item'] = widget.cart.length.toString();
    cartPageInfo['net_pay_amount'] = widget.totalcounter.toString();

    cartPageInfo['order_status'] = 'Pending';

    for (var k in widget.cart.keys) {
      menu_item_name += widget.cart[k]!.menu_name.toString() + ',';
      menu_id += widget.cart[k]!.menu_id.toString() + ',';
      gst_amount += '20,'; // Replace this with dynamic gst value
      gst_amount_price += '30,'; //Replace this with dynamic gst value
      quantity += widget.cart[k]!.quantity.toString()+ ',';
      menu_price += widget.cart[k]!.menu_fix_price.toString() + ',';
      half_and_full_status += 'F,';
    }

    cartPageInfo['menu_item_name'] = menu_item_name;
    cartPageInfo['menu_id'] = menu_id;

    cartPageInfo['quantity'] = quantity;
    cartPageInfo['menu_price'] = menu_price;
    cartPageInfo['half_and_full_status'] = half_and_full_status;
    print(cartPageInfo);

    super.initState();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
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
                                  child: Text('',
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

                            //comments /add_order_detail_for_restaurant POST
                            // params.put("menu_id",sMenuID);
                            //                 params.put("admin_id", sAdminID);HRGR00005
                            //                 params.put("cus_id", sCustomerID); this comes otp login api CUS_00007
                            //                 params.put("customer_mobile_no", sCustomerMobileNumber);
                            //                 params.put("table_no", sTableNumber);
                            //                 params.put("menu_item_name", sMenuItemName);//menu name is comma separated array of items like roti,sabzi
                            //                 params.put("quantity", sQuantity);//quantity is comma separated array of quantity, make sure quantity is in the same order like menu items
                            //                 params.put("menu_price", sMenuPriceAPI);//comma separated price order important
                            //                 params.put("total_item", sTotalItem);//
                            //                 params.put("total_price", sTotalPrice);
                            //                 params.put("gst_amount", sGst);//comma separated gst value
                            //                 params.put("order_status", sOrderStatus); order status is pending
                            //                 params.put("net_pay_amount",sNetPayAmount);
                            //                 params.put("gst_amount_price",sGSTprice);// comma separated gst price
                            //                 params.put("half_and_full_status",sItemHalfFullStatus);
                            ElevatedButton(
                              child: Text('PLACE ORDER'),
                              onPressed: () => {},
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
