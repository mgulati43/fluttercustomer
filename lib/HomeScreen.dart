import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'sideBar.dart';
import 'RestaurantDetail.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //restaurant list
  List<RestaurantJsonParser> restaurantList = [];
  //filtered restaurant list initialized
  List<RestaurantJsonParser> searchableRestaurantList = [];

  TextEditingController editingController = TextEditingController();
  var _loading;
  //list of images for banners
  var bannerImage = [
    "assets/slider_i1.png",
    "assets/slider_i2.jpg",
    "assets/slider_i3.jpg",
    "assets/slider_i5.png",
    "assets/slider_i6.jpg",
    "assets/slider_i7.jpg",
    "assets/slider_i8.jpg",
  ];

  @override
  void initState() {
    super.initState();
    _loading = true;
    //call api to populate restaurant list
    callListApi();
  }

//display image of restaurant from server and display dummy image if no image from server
  Widget _displayImage(String path) {
    if (path == null || path.isEmpty) {
      return Image.asset('assets/dummyRestaurant.png',
          width: 100, height: 100, fit: BoxFit.cover);
    } else {
      return Image.network(path, width: 100, height: 100, fit: BoxFit.cover);
    }
  }

  void _navigateDetailPage(
      BuildContext context, RestaurantJsonParser restaurant) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => RestDetail(rest: restaurant)));
  }
  

//calling post request fetching restaurant list
  void callListApi() async {
    var response;
    String decodedResponse = '';
    //API call here
    var urlSent = Uri.encodeFull(
        'http://dev.goolean.com/Restaurant/index.php/customer/Api/getNearbySpots');
    var map = new Map<String, dynamic>();
    //input parameter
    map['city'] = '';
    var url = Uri.parse(urlSent);
    try {
      response = await http.post(url,
          body: map,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          encoding: Encoding.getByName("utf-8"));
      decodedResponse = utf8.decode(response.bodyBytes);

      var jsonObjects = jsonDecode(decodedResponse)['spots'] as List;
      print('mayank' + jsonObjects.toString());
      Map<String, dynamic> mapOtpResponse = jsonDecode(decodedResponse);
      //fetch message Response status ie invalid otp or valid otp
      // String messageResponse = mapOtpResponse['spots']['admin_id'];

      setState(() {
        //fetched restaurant list
        restaurantList = jsonObjects
            .map((jsonObject) => RestaurantJsonParser.fromJson(jsonObject))
            .toList();
        searchableRestaurantList = restaurantList;
      });
    } catch (e) {
      //Write exception statement here

    }
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(20.0),

      //Textfield with icon of search in starting
      child: TextField(

        //called when we enter or delete text in textfield
        onChanged: (value) {
          value = value.toLowerCase();
          setState(() {
            //restaurant list filtered and stored in another list
            //keyword where loops on restaurant list and each restaurant is returned which  is type of restaurant json parser
            searchableRestaurantList = restaurantList.where((restaurant) {
              //fetchs restaurant name and convert it to lower case and store in a variable
              var restaurantTitle = restaurant.name.toLowerCase();
              //checks whether name of restaurant in main list matches the value entered by user
              return restaurantTitle.contains(value);
            }).toList();
          });
        },
        //controller of textfield to get text
        controller: editingController,
        //labeltext,hinttext and border
        decoration: InputDecoration(
            labelText: "Search by restaurant name",
            hintText: "Search by restaurant name",
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)))),
      ),
    );
  }

  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    PageController controller =
        PageController(viewportFraction: 0.8, initialPage: 1);
    List<Widget> banners = [];

    for (int x = 0; x < bannerImage.length; x++) {
      var bannerView = Padding(
        padding: EdgeInsets.all(10.0),
        child: Container(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(0.0)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black38,
                          offset: Offset(2.0, 2.0),
                          blurRadius: 5.0,
                          spreadRadius: 1.0)
                    ]),
              ),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(0.0)),
                child: Image.asset(
                  bannerImage[x],
                  fit: BoxFit.cover,
                ),
              )
            ],
          ),
        ),
      );
      banners.add(bannerView);
    }

    return Scaffold(
      drawer: SideBar(),
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text("Smart Dine"),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(children: [
        _searchBar(),
        Container(
          width: screenWidth,
          height: screenWidth * 9 / 16,
          child: PageView(
            controller: controller,
            scrollDirection: Axis.horizontal,
            children: banners,
          ),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: searchableRestaurantList.length,
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
                                topLeft: Radius.circular(0.0),
                                bottomLeft: Radius.circular(0.0)),
                            child: _displayImage(
                              searchableRestaurantList[index].image,
                            )),
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
                                        searchableRestaurantList[index].name,
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      // Text(
                                      //   searchableRestaurantList[index].name,
                                      //   style: TextStyle(
                                      //       fontSize: 20.0,
                                      //       color: Colors.black,),
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2.0),
                                child: Text(
                                  searchableRestaurantList[index].address,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.black54,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                              Text(
                                  searchableRestaurantList[index].openingTime +
                                      ' - ' +
                                      searchableRestaurantList[index]
                                          .closingTime,
                                  style: TextStyle(
                                      fontSize: 10.0, color: Colors.black54)),
                              Row(
                                // mainAxisAlignment:
                                //     MainAxisAlignment.spaceBetween,
                                children: [],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: 180,
                                      child: Text(
                                          'Cuisines ' +
                                              searchableRestaurantList[index]
                                                  .cuisines,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 10.0,
                                              color: Colors.black54)),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 0.0),
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.red)),
                                      onPressed: () => _navigateDetailPage(
                                          context,
                                          searchableRestaurantList[index]),
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
                        )),

                      ],

                    ),

                  ),



                );

              }),
        ),

      ]

      ),


    );
  }
}

Future<String> _nameSaver(String admin_id) async {
  //SharedPreferences prefs = await SharedPreferences.getInstance();
  //prefs.setString('admin_id', admin_id);
  return 'saved';
}

class RestaurantJsonParser {
  //String time;
  String admin_id;
  String verified;

  String city;
  String spotId;
  String trending;
  String name;
  String image;
  String rating;
  String lat;
  String lng;
  String location;
  String cuisines;
  String priceLevel;
  String cost;
  String openStatus;
  String openingTime;
  String closingTime;
  String phone;
  String address;

  RestaurantJsonParser(
      //this.time,
      this.admin_id,
      this.verified,
      this.city,
      this.spotId,
      this.trending,
      this.name,
      this.rating,
      this.image,
      this.lat,
      this.lng,
      this.location,
      this.cuisines,
      this.priceLevel,
      this.cost,
      this.openStatus,
      this.openingTime,
      this.closingTime,
      this.phone,
      this.address);
  //this.message,
  //this.status);

  factory RestaurantJsonParser.fromJson(dynamic json) {
    return RestaurantJsonParser(
      json['admin_id'] as String,
      json['verified'] as String,
      //json['time'] as String,

      json['city'] as String,
      json['spotId'] as String,
      json['trending'] as String,
      json['name'] as String,
      json['rating'] as String,
      json['image'] as String,
      json['lat'] as String,
      json['lng'] as String,
      json['location'] as String,
      json['cuisines'] as String,
      json['priceLevel'] as String,
      json['cost'] as String,
      json['openStatus'] as String,
      json['openingTime'] as String,
      json['closingTime'] as String,
      json['phone'] as String,
      json['address'] as String,

      // json['message'] as String,
      // json['status'] as String);
    );
  }
}
