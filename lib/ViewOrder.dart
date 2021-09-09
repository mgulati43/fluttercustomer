import 'package:flutter/material.dart';
import 'sideBar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'AddMore.dart';

class ViewOrder extends StatefulWidget {
  @override
  _ViewOrderState createState() => _ViewOrderState();
//mayank
}

class _ViewOrderState extends State<ViewOrder> {
  List<Order> orderItems = [];
  ScrollController _controller = new ScrollController();
  @override
  void initState() {
    getOrderList();
    super.initState();
  }

  Future<void> getOrderList() async {
    var response;
    String decodedResponse = '';

    // //API call here
    var urlSent = Uri.encodeFull(
        'http://dev.goolean.com/Restaurant/index.php/customer/Api/get_order_detail_for_customer');
    var map = new Map<String, dynamic>();
    map['customer_mobile_no'] = '9899988817';
    var url = Uri.parse(urlSent);
    try {
      response = await http.post(url,
          body: map,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          encoding: Encoding.getByName("utf-8"));
      decodedResponse = utf8.decode(response.bodyBytes);

      var jsonObjects = jsonDecode(decodedResponse)['data'] as List;
      orderItems =
          jsonObjects.map((orderItem) => Order.fromJson(orderItem)).toList();
      List<String> menuItems = [];
      List<String> quantityItems = [];
      List<String> priceItems = [];

      orderItems.forEach((order) {
        List<OrderItem> orderItem = [];
        //Remove the last comma from each and create a list of strings for each order item
        order.menu_item_name = order.menu_item_name!
            .substring(0, order.menu_item_name!.length - 1);
        menuItems = order.menu_item_name!.split(',');
        for (int i = 0; i < menuItems.length; i++) {
          OrderItem subOrderItem = new OrderItem();
          subOrderItem.menuName = menuItems[i];
          orderItem.insert(i, subOrderItem);
        }

        order.quantity =
            order.quantity!.substring(0, order.quantity!.length - 1);
        quantityItems = order.quantity!.split(',');
        for (int i = 0; i < quantityItems.length; i++) {
          orderItem[i].quantity = quantityItems[i];
        }

        order.menu_price =
            order.menu_price!.substring(0, order.menu_price!.length - 1);
        priceItems = order.menu_price!.split(',');
        for (int i = 0; i < priceItems.length; i++) {
          orderItem[i].price = priceItems[i];
        }
        print('Orders length: ' + orderItem.length.toString());
        setState(() {
          order.orderItem = orderItem;
        });
      });
    } catch (e) {}
  }

  void _navigateAddMorePage(
      BuildContext context, Order orderData) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => AddMore(orderData: orderData)));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            drawer: SideBar(),
            appBar: AppBar(
              backgroundColor: Colors.deepOrange,
              title: Text("Smart Dine"),
              iconTheme: IconThemeData(color: Colors.orange),
            ),
            body: Column(children: <Widget>[
              Expanded(
                  child: Padding(
                      padding: EdgeInsets.all(5),
                      child: ListView.builder(
                          controller: _controller,
                          physics: const AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: orderItems.length,
                          itemBuilder: (context, index) {
                            return Container(
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.red, // red as border color
                                  ),
                                ),
                                child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          orderItems[index].restaurentName ??
                                              '',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                'ORDER-ID: ' +
                                                    orderItems[index]
                                                        .new_order_id!,
                                                style: TextStyle(
                                                    color: Colors.black)),
                                            Text(
                                                'TABLE NO: ' +
                                                    orderItems[index].table_no!,
                                                style: TextStyle(
                                                    color: Colors.black))
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Table(
                                          children: [
                                            TableRow(children: [
                                              Text('MENU',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: Colors.black)),
                                              Text('QUANTITY',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: Colors.black)),
                                              Text('PRICE',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: Colors.black)),
                                            ]),
                                          ],
                                        ),
                                        SizedBox(height: 5),
                                        Divider(
                                          color: Colors.orange,
                                          thickness: 2,
                                          height: 1,
                                        ),
                                        SizedBox(height: 5),
                                        ListView.builder(
                                            controller: _controller,
                                            physics:
                                            const AlwaysScrollableScrollPhysics(),
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            itemCount: orderItems[index]
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
                                                            orderItems[index]
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
                                                            orderItems[index]
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
                                                            orderItems[index]
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
                                        Divider(
                                          color: Colors.orange,
                                          thickness: 2,
                                          height: 1,
                                        ),
                                        SizedBox(height: 10,),
                                        Row(
                                          children: [
                                            Text('ORDER STATUS: '),
                                            Text(
                                              orderItems[index].order_status!,
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          height: 30,
                                          decoration: BoxDecoration(
                                              color: Colors.deepOrange,
                                              borderRadius:
                                              BorderRadius.circular(20)),
                                          child: FlatButton(
                                            onPressed: () =>
                                                _navigateAddMorePage(context, orderItems[index]),
                                            child: Text(
                                              'ADD MORE ITEMS',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        )
                                      ],
                                    )));
                          }))),
            ])));
  }
}

class Order {
  String? new_order_id;
  String? table_no;
  String? menu_item_name;
  String? quantity;
  String? menu_price;
  List<OrderItem>? orderItem = [];
  String? restaurentName;
  String? order_status;
  String? admin_id;
  String? order_id;
  String? waiter_mobile_no;

  Order(
      {this.new_order_id,
        this.table_no,
        this.menu_item_name,
        this.quantity,
        this.menu_price,
        this.orderItem,
        this.restaurentName,
        this.order_status,
        this.admin_id,
        this.order_id,
        this.waiter_mobile_no
        });

  factory Order.fromJson(dynamic json) {
    return Order(
        new_order_id: json['new_order_id'],
        table_no: json['table_no'],
        menu_item_name: json['menu_item_name'],
        quantity: json['quantity'],
        menu_price: json['menu_price'],
        restaurentName: json['RestaurentName'],
        order_status: json['order_status'],
        admin_id: json['admin_id'],
        order_id: json['order_id'],
        waiter_mobile_no: json['waiter_mobile_no']
    );
  }
}

class OrderItem {
  String menuName = '';
  String quantity = '';
  String price = '';
}
