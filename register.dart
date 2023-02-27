import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:homestay_raya/models/config.dart';
import 'package:homestay_raya/models/user.dart';
import 'package:homestay_raya/views/login.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class RegisterPage extends StatefulWidget { const RegisterPage
({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final User user;
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();
  final TextEditingController _passEditingController = TextEditingController();
 // bool _isChecked = false;
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = true;
  String eula = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Form"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 8,
            margin: const EdgeInsets.all(8),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(children: [
                    TextFormField(
                        controller: _nameEditingController,
                        keyboardType: TextInputType.text,
                        validator: (val) => val!.isEmpty || (val.length < 3)
                            ? "name must be longer than 3"
                            : null,
                        decoration: const InputDecoration(
                            labelText: 'Name',
                            labelStyle: TextStyle(),
                            icon: Icon(Icons.person),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1.0),
                            ))),
                    TextFormField(
                        controller: _emailEditingController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) => val!.isEmpty ||
                                !val.contains("@") ||
                                !val.contains(".")
                            ? "Enter a valid email"
                            : null,
                        decoration: const InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(),
                            icon: Icon(Icons.email),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1.0),
                            ))),
                    TextFormField(
                        controller: _phoneEditingController,
                        keyboardType: TextInputType.phone,
                        validator: (val) => val!.isEmpty || (val.length < 10)
                            ? "enter a valid Phone Number"
                            : null,
                        decoration: const InputDecoration(
                            labelText: 'Phone',
                            labelStyle: TextStyle(),
                            icon: Icon(Icons.phone),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1.0),
                            ))),
                    TextFormField(
                      controller: _passEditingController,
                      keyboardType: TextInputType.visiblePassword,
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
                          minWidth: 115,
                          height: 50,
                          elevation: 10,
                          onPressed: _registerUser,
                          color: Theme.of(context).colorScheme.primary,
                          child: const Text("Register"),
                        ),
                      ],
                    ),
                    const SizedBox(
                        height: 7,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("Already have an account?",
                              style: TextStyle(
                                fontSize: 16.0,
                              )),
                          GestureDetector(
                            onTap: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (content) =>
                                          const LoginPage()))
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
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? validatePassword(String value) {
    String pattern = r'^(?=.*?[A‐Z])(?=.*?[a‐z])(?=.*?[0‐9]).{6,}$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Enter valid password';
      } else {
        return null;
      }
    }
  }

  void _registerUser() {
    String name = _nameEditingController.text;
    String email = _emailEditingController.text;
    String phone = _phoneEditingController.text;
    String pass = _passEditingController.text;

    if (name.isNotEmpty && email.isNotEmpty && phone.isNotEmpty && pass.isNotEmpty) {
      http.post(
          Uri.parse( "${Config.SERVER}/homestayraya/mobile/php/register_user.php"),
          body: {
            "name": name,
            "email": email,
            "phone": phone,
            "password": pass,
          }).then((response) {
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == "success") {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (content) =>  const LoginPage()));
          Fluttertoast.showToast(
              msg: "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
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
}