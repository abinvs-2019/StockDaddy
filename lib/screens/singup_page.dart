import 'dart:io';
import 'dart:math';
import 'package:firebase_nota_app/helper/login_helper.dart';
import 'package:firebase_nota_app/screens/login_screen.dart';
import 'package:firebase_nota_app/services/auth.dart';
import 'package:firebase_nota_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUpPage extends StatefulWidget {
  // final Function viewScreen;
  // SignUpPage(this.viewScreen);
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

bool isLoading = false;
Auth authMethod = new Auth();
HelperFunction helperfunction = HelperFunction();
TextEditingController _userNamecontroller = TextEditingController();
TextEditingController _emailcontroller = TextEditingController();
TextEditingController _passcontroller = TextEditingController();

bool isUploaded = false;
bool isUploading = false;
bool isExist = true;

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();

  signUpvalidateForm() {
    if (formKey.currentState!.validate()) {
      Map<String, String> userInfo = {
        "name": _userNamecontroller.text.toLowerCase(),
        "email": _emailcontroller.text,
      };

      authMethod
          .signUpWithEmailAndPaaword(
              _emailcontroller.text, _passcontroller.text)
          .then((val) {
        if (val == null) {
          print(e.toString());
        }
        print("controller$_emailcontroller");
        print("$val");

        DatabaseMethods().uploadUserInfo(userInfo);
        HelperFunction.saveuserLoggedInSharedPreferrence(true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String? pass;
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 25,
                            ),
                            const Text(
                              "Twitter ",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35),
                            ),
                            const Text("Register Account"),
                          ],
                        ),
                        height: MediaQuery.of(context).size.width / 5,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.1,
                        child: Center(
                          child: Column(
                            children: [
                              Form(
                                key: formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              3,
                                          child: Column(
                                            children: [
                                              TextFormField(
                                                controller: _userNamecontroller,
                                                decoration: InputDecoration(
                                                  labelText: "Enter a username",
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25.0),
                                                    borderSide: BorderSide(),
                                                  ),
                                                  // fillColor: Colors.green
                                                ),
                                                validator: (val) {
                                                  return val!.length != null ||
                                                          val.length < 4
                                                      ? null
                                                      : "Please enter a username";
                                                },
                                                keyboardType:
                                                    TextInputType.name,
                                                style: TextStyle(
                                                  fontFamily: "Poppins",
                                                ),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    80,
                                              ),
                                              TextFormField(
                                                controller: _emailcontroller,
                                                decoration: InputDecoration(
                                                  labelText: "Enter Email",
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25.0),
                                                    borderSide: BorderSide(),
                                                  ),
                                                  // fillColor: Colors.green
                                                ),
                                                validator: (val) {
                                                  return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                              .hasMatch(val!) &&
                                                          val.length != null
                                                      ? null
                                                      : "Please enter a valid mail";
                                                },
                                                keyboardType:
                                                    TextInputType.emailAddress,
                                                style: new TextStyle(
                                                  fontFamily: "Poppins",
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      alignment: Alignment.center,
                                      width:
                                          MediaQuery.of(context).size.height /
                                              3,
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            controller: _passcontroller,
                                            validator: (val) {
                                              pass = val!;
                                              return val.isEmpty ||
                                                      val.length < 6
                                                  ? "Enter a Strong Password"
                                                  : null;
                                            },
                                            decoration: InputDecoration(
                                              labelText: "Enter Password ",
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                                borderSide: BorderSide(),
                                              ),
                                            ),
                                            keyboardType:
                                                TextInputType.visiblePassword,
                                            style: const TextStyle(
                                              fontFamily: "Poppins",
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                80,
                                          ),
                                          TextFormField(
                                            validator: (val) {
                                              return val!.isEmpty ||
                                                      val.length < 6 ||
                                                      pass != val
                                                  ? "Password does not match!!"
                                                  : null;
                                            },
                                            decoration: InputDecoration(
                                              labelText: "Re-Enter Password ",
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                                borderSide: BorderSide(),
                                              ),
                                            ),
                                            keyboardType:
                                                TextInputType.visiblePassword,
                                            style: const TextStyle(
                                              fontFamily: "Poppins",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.width /
                                              17,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        signUpvalidateForm();
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 20),
                                        child: Text(
                                          "Register",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.teal,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginPage()));
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 20),
                                        child: Text(
                                          "Already Have an Account",
                                          style: TextStyle(color: Colors.teal),
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 50,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
