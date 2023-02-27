import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:homestay_raya/models/config.dart';
import 'package:homestay_raya/models/user.dart';
import 'package:homestay_raya/views/firstTab.dart';
import 'package:homestay_raya/views/mainscreen.dart';
import 'package:homestay_raya/views/register.dart';

import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
  bool _passwordVisible = true;
  final _formKey = GlobalKey<FormState>();
  //late Position position;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
        ),
        body: Center(
          child: SingleChildScrollView(
              child: Card(
            elevation: 11,
            margin: const EdgeInsets.all(10),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: _emailEditingController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) => val!.isEmpty ||
                                  !val.contains("@") ||
                                  !val.contains(".")
                              ? "Enter a Valid Email"
                              : null,
                          decoration: const InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(),
                              icon: Icon(Icons.email),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1.0),
                              ))),
                      TextFormField(
                        controller: _passEditingController,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        validator: (val) => validatePassword(val.toString()),
                        obscureText: _passwordVisible,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(),
                          icon: const Icon(Icons.lock),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(width: 1.0),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            minWidth: 112,
                            height: 40,
                            elevation: 7,
                            onPressed: _loginUser,
                            color: Theme.of(context).colorScheme.primary,
                            child: const Text('Log In'),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("Don't have an account?",
                              style: TextStyle(
                                fontSize: 16.0,
                              )),
                          GestureDetector(
                            onTap: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (content) =>
                                          const RegisterPage()))
                            },
                            child: const Text(
                              "Click here",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("Forgot password",
                              style: TextStyle(
                                fontSize: 16.0,
                              )),
                          GestureDetector(
                            onTap: null,
                            child: const Text(
                              "Click here",
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      )
                      /*GestureDetector(
                  onTap: _goRegister,
                  child: const Text(
                    "Don't have an account. Register now",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),*/
                    ],
                  ),
                ),
              ),
            ),
          )),
        ));
  }

  String? validatePassword(String value) {
    String pattern = r'^(?=.*?[A‐Z])(?=.*?[a‐z])(?=.*?[0‐9]).{6,}$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Wrong password';
      } else {
        return null;
      }
    }
  }

  /*checkAndLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    late User user;
    if (email.length > 1 && password.length > 1) {
      http.post(Uri.parse("${Config.SERVER}php/login_user.php"),
          body: {"email": email, "password": password}).then((response) {
        if (response.statusCode == 200 && response.body != "failed") {
          final jsonResponse = json.decode(response.body);
          User user = User.fromJson(jsonResponse['data']);
          Timer(
            const Duration(seconds: 3),
            () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (content) => mainScreen(user: user))),
          );
        } else {
          user = User(
            id: "na",
            name: "na",
            email: "na",
            phone: "na",
            address: "na",
            regdate: "na",
          );
          Timer(
            const Duration(seconds: 3),
            () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (content) => mainScreen(user: user))),
          );
        }
      }).timeout(const Duration(seconds: 5));
    } else {
      user = User(
        id: "na",
        name: "na",
        email: "na",
        phone: "na",
        address: "na",
        regdate: "na",
      );
      Timer(
          const Duration(seconds: 3),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (content) => mainScreen(user: user))));
    }
  }*/

  void _loginUser() {
    String email = _emailEditingController.text;
    String pass = _passEditingController.text;

    if (email.isNotEmpty && pass.isNotEmpty) {
      http.post(
          Uri.parse("${Config.SERVER}/homestayraya/mobile/php/login_user.php"),
          body: {
            "email": email,
            "password": pass,
          }).then((response) {
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == "success") {
          var jsonResponse = json.decode(response.body);
          User user = User.fromJson(jsonResponse['data']);
          // User user = User(
          // id: "", name: "", email: "", phone: "", address: "", regdate: "");
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => homeTab(user: user)));
          Fluttertoast.showToast(
              msg: "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          return;
        } else {
          Fluttertoast.showToast(
              msg: "Login Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14);
          return;
        }
      });
    }
  }
}
