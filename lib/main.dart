import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_nota_app/helper/login_helper.dart';
import 'package:firebase_nota_app/screens/locked_screen.dart';
import 'package:firebase_nota_app/screens/login_screen.dart';
import 'package:firebase_nota_app/screens/new_note.dart';
import 'package:firebase_nota_app/screens/notes.dart';
import 'package:flutter/material.dart';

import 'helper/contants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunction.getuserLoggedInSharedPreferrence().then(
      (value) {
        setState(() {
          value == null
              ? Constants.userIsLoggedIn = false
              : Constants.userIsLoggedIn = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Constants.userIsLoggedIn! ? NotesScreen() : LockedScreenPage());
  }
}
