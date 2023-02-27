import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:homestay_raya/models/config.dart';
import 'package:homestay_raya/views/product.dart';
import 'package:homestay_raya/models/user.dart';
import 'package:http/http.dart' as http;

class ProductDetailsPage extends StatefulWidget {
  final Product product;
  final User user;
  const ProductDetailsPage(
      {super.key, required this.product, required this.user});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  var pathAsset = "assets/images/icon1.jpg";
  final TextEditingController _hsnameEditingController =
      TextEditingController();
  final TextEditingController _hsdescEditingController =
      TextEditingController();
  final TextEditingController _hspriceEditingController =
      TextEditingController();

  final TextEditingController _hsstateEditingController =
      TextEditingController();
  final TextEditingController _hslocalEditingController =
      TextEditingController();
  var lat, long;
  late double screenHeight, screenWidth, resWidth;
  int rowcount = 2;

  @override
  void initState() {
    super.initState();
    _hsnameEditingController.text = widget.product.hsname.toString();
    _hsdescEditingController.text = widget.product.hsdesc.toString();
    _hspriceEditingController.text = widget.product.hsprice.toString();
    _hsstateEditingController.text = widget.product.hsstate.toString();
    _hslocalEditingController.text = widget.product.hslocality.toString();
  }

  @override
  Widget build(BuildContext context) {
     screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }
    return Scaffold(
        appBar: AppBar(title: const Text("Details")),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 8,
                child: Container(
                  height: screenHeight / 3,
                  width: resWidth,
                  child: CachedNetworkImage(
                    width: screenWidth,
                    fit: BoxFit.cover,
                    imageUrl:
                        "${Config.SERVER}homestayraya/mobile/assets/productimages/${widget.product.hsid}.png",
                    placeholder: (context, url) =>
                        const LinearProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              const Text(
                "Homestay Details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                          textInputAction: TextInputAction.next,
                          validator: (val) => val!.isEmpty || (val.length < 3)
                              ? "Homestay name must be longer than 3"
                              : null,
                          controller: _hsnameEditingController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              labelText: 'Homestay Name',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.person),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      TextFormField(
                          textInputAction: TextInputAction.next,
                          validator: (val) => val!.isEmpty || (val.length < 10)
                              ? "Homestay description must be longer than 10"
                              : null,
                          maxLines: 4,
                          controller: _hsdescEditingController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              labelText: 'Homestay Description',
                              alignLabelWithHint: true,
                              labelStyle: TextStyle(),
                              icon: Icon(
                                Icons.description_rounded,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 2.0),
                              ))),
                      Row(
                        children: [
                          Flexible(
                            flex: 5,
                            child: TextFormField(
                                textInputAction: TextInputAction.next,
                                validator: (val) => val!.isEmpty
                                    ? "Homestay price must contain value"
                                    : null,
                                controller: _hspriceEditingController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    labelText: 'Homestay Price',
                                    labelStyle: TextStyle(),
                                    icon: Icon(Icons.money),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    ))),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                            flex: 5,
                            child: TextFormField(
                                textInputAction: TextInputAction.next,
                                validator: (val) =>
                                    val!.isEmpty || (val.length < 3)
                                        ? "Current State"
                                        : null,
                                enabled: false,
                                controller: _hsstateEditingController,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                    labelText: 'Current States',
                                    labelStyle: TextStyle(),
                                    icon: Icon(Icons.flag),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    ))),
                          ),
                          Flexible(
                            flex: 5,
                            child: TextFormField(
                                textInputAction: TextInputAction.next,
                                enabled: false,
                                validator: (val) =>
                                    val!.isEmpty || (val.length < 3)
                                        ? "Current Locality"
                                        : null,
                                controller: _hslocalEditingController,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                    labelText: 'Current Locality',
                                    labelStyle: TextStyle(),
                                    icon: Icon(Icons.map),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    ))),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          child: const Text('Update Homestay'),
                          onPressed: () {
                            _updateProductdialog();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  _updateProductdialog() {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please complete the form first",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Update details homestay?",
              style: TextStyle(),
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
                  _updatehomestay();
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

  void _updatehomestay() {
    String hsname = _hsnameEditingController.text;
    String hsdesc = _hsdescEditingController.text;
    String hsprice = _hspriceEditingController.text;
    http.post(
        Uri.parse("${Config.SERVER}/homestayraya/mobile/php/updateproduct.php"),
        body: {
          "userid": widget.user.id,
          "hsid": widget.product.hsid,
          "hsname": hsname,
          "hsdesc": hsdesc,
          "hsprice": hsprice,
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
  }
}
