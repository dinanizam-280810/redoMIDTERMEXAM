import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:homestay_raya/models/config.dart';
import 'package:homestay_raya/models/hsdetailspage.dart';
import 'package:homestay_raya/models/newhomestay.dart';
import 'package:homestay_raya/views/login.dart';
import 'package:homestay_raya/views/mainmenu.dart';
import 'package:homestay_raya/views/product.dart';
import 'package:homestay_raya/models/user.dart';
import 'package:homestay_raya/views/register.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class homeTab extends StatefulWidget {
  final User user;
  //final Position position;
  //final List<Placemark> placemarks;
  const homeTab({
    super.key,
    required this.user,
  });

  @override
  State<homeTab> createState() => _homeTabState();
}

class _homeTabState extends State<homeTab> {
  var lat, long, placemarks;

  @override
  void initState() {
    super.initState();
    _loadBuyerProducts();
    //_scrollController = ScrollController();
    //_scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    productlist = [];
    print("dispose");
    super.dispose();
  }

  List<Product> productlist = <Product>[];
  String titlecenter = "Loading data...";
  late double screenHeight, screenWidth, resWidth;
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  //late ScrollController _scrollController;
  //int scrollcount = 10;
  int rowcount = 2;
  //int numprd = 0;

  late Position _position;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 200) {
      resWidth = screenWidth;
      rowcount = 1;
    } else {
      resWidth = screenWidth * 0.25;
      rowcount = 2;
    }
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Seller"),
            actions: [
              IconButton(
                  onPressed: _loginForm,
                  icon: const Icon(Icons.login_outlined)),
              IconButton(
                  onPressed: _registrationForm,
                  icon: const Icon(Icons.app_registration_outlined)),
              PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem<int>(
                      onTap: () {},
                      value: 0,
                      child: const Text("New Homestay"),
                    ),
                    PopupMenuItem<int>(
                      onTap: () {},
                      value: 1,
                      child: const Text("My Booking"),
                    ),
                  ];
                },
                onSelected: (value) {
                  if (value == 0) {
                    _gotoNewHomestay();
                    print("My account menu is selected.");
                  } else if (value == 1) {
                    print("Settings menu is selected.");
                  } else if (value == 2) {
                    print("Logout menu is selected.");
                  }
                },
              )
            ],
          ),
          body: productlist.isEmpty
              ? Center(
                  child: Text(titlecenter,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text(
                        "Available Homestay (${productlist.length} found)",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    //Text(numprd.toString() + " found"),
                    const SizedBox(
                      height: 4,
                    ),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: rowcount,
                        // controller: _scrollController,
                        children: List.generate(productlist.length, (index) {
                          return Card(
                              elevation: 8,
                              child: InkWell(
                                onTap: () {
                                  _prodDetails(index);
                                },
                                onLongPress: () {
                                  _deleteDialog(index);
                                },
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Flexible(
                                      flex: 6,
                                      child: CachedNetworkImage(
                                        width: resWidth / 2,
                                        fit: BoxFit.cover,
                                        imageUrl:
                                            "${Config.SERVER}/homestayraya/mobile/assets/productimages/${productlist[index].hsid}.png",
                                        placeholder: (context, url) =>
                                            const LinearProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                    Flexible(
                                        flex: 4,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                  truncateString(
                                                      productlist[index]
                                                          .hsname
                                                          .toString(),
                                                      15),
                                                  style: const TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                  "RM ${double.parse(productlist[index].hsprice.toString()).toStringAsFixed(2)}"),
                                              // style: TextStyle(
                                              //  fontSize: resWidth * 0.03,
                                              // ),

                                              //Text(df.format(DateTime.parse(
                                              //  productlist[index]
                                              //    .hsdate
                                              //   .toString()))
                                              //  style: TextStyle(
                                              //   fontSize: resWidth * 0.03,
                                              // ),
                                              //  ),
                                            ],
                                          ),
                                        )),
                                  ],
                                ),
                              ));
                        }),
                      ),
                    ),
                  ],
                ),
          drawer: MainMenuWidget(
            user: widget.user,
          )),
    );
  }

  void _loadBuyerProducts() {
    if (widget.user.id == "0") {
      Fluttertoast.showToast(
          msg: "Please register an account with us",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    http
        .get(
      Uri.parse(
          "${Config.SERVER}/homestayraya/mobile/php/loadbuyer_products.php?userid=${widget.user.id}"),
    )
        .then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          var extractdata = jsondata['data'];
          if (extractdata['products'] != null) {
            productlist = <Product>[];
            extractdata['products'].forEach((v) {
              productlist.add(Product.fromJson(v));
            });
            titlecenter = "Found";
          } else {
            titlecenter = "No homestay available";
            productlist.clear();
          }
        } else {
          titlecenter = "No Homestay Available";
        }
      } else {
        titlecenter = "No homestay available";
        productlist.clear();
      }

      setState(() {});
      // productlist = extractdata["products"];
      // numprd = productlist.length;
      // if (scrollcount >= productlist.length) {
      // scrollcount = productlist.length;
    });
  }

  /* _prodDetails(int index) {
    Product product = Product(
      hsid: productlist[index].hsdate,
      userid: productlist[index].userid,
      hsname: productlist[index].hsname,
      hsdesc: productlist[index].hsdesc,
      hsprice: productlist[index].hsprice,
      hsstate: productlist[index].hsstate,
      hslocality: productlist[index].hslocality,
      hslat: productlist[index].hslat,
      hslong: productlist[index].hslong,
      hsdate: productlist[index].hsdate,
      //userEmail: productlist[index]['user_email'],
    );
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ProductDetailsPage(
                  product: product,
                  user: widget.user,
                )));
  }*/
  Future<void> _prodDetails(int index) async {
    Product product = Product.fromJson(productlist[index].toJson());

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (content) => ProductDetailsPage(
                  product: product,
                  user: widget.user,
                )));
  }

  String truncateString(String str, int size) {
    if (str.length > size) {
      str = str.substring(0, size);
      return "$str...";
    } else {
      return str;
    }
  }

  /*void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        if (productlist.length > scrollcount) {
          scrollcount = scrollcount + 10;
          if (scrollcount >= productlist.length) {
            scrollcount = productlist.length;
          }
        }
      });
    }
  }*/

  void _registrationForm() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => const RegisterPage()));
  }

  void _loginForm() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => const LoginPage()));
  }

  Future<void> _gotoNewHomestay() async {
    if (widget.user.id == "0") {
      Fluttertoast.showToast(
          msg: "Please register an account with us",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    if (await _checkandGetLocPermission()) {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) => newHomestayPage(
                    position: _position,
                    user: widget.user,
                    placemarks: placemarks
                  )));
      _loadBuyerProducts();
    } else {
      Fluttertoast.showToast(
          msg: "Please allow the app to access the location",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
    }
  }

  Future<bool> _checkandGetLocPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(
            msg: "Please allow the app to access the location",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        Geolocator.openLocationSettings();
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg: "Please allow the app to access the location",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      Geolocator.openLocationSettings();
      return false;
    }
    _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    return true;
  }

  _deleteDialog(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text(
              "Delete ${truncateString(productlist[index].hsname.toString(), 15)}",
              style: const TextStyle(),
            ),
            content: const Text("Are you sure?", style: TextStyle()),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Sure",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _deleteProduct(index);
                },
              ),
              TextButton(
                child: const Text(
                  "Cancel",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _deleteProduct(index) {
    try {
      http.post(
          Uri.parse(
              "${Config.SERVER}/homestayraya/mobile/php/delete_product.php"),
          body: {
            "hsid": productlist[index].hsid,
          }).then((response) {
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == "success") {
          Fluttertoast.showToast(
              msg: "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          Navigator.of(context).pop();
          _loadBuyerProducts();
          return;
        } else {
          Fluttertoast.showToast(
              msg: "Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          return;
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
