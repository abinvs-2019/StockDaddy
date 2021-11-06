import 'package:firebase_nota_app/loal_authenticate/local_auth.dart';
import 'package:firebase_nota_app/screens/login_screen.dart';
import 'package:firebase_nota_app/screens/notes.dart';
import 'package:flutter/material.dart';

class LockedScreenPage extends StatefulWidget {
  const LockedScreenPage({Key? key}) : super(key: key);

  @override
  State<LockedScreenPage> createState() => _LockedScreenPageState();
}

class _LockedScreenPageState extends State<LockedScreenPage> {
  @override
  void initState() {
    biomtrics();
    super.initState();
  }

  biomtrics() async {
    final isAvailable = await LocalAuthApi.hasBiometrics();
    print("object");
    final biometrics = await LocalAuthApi.getBiometrics();
    print("object2");
    final isAuthenticated = await LocalAuthApi.authenticate();
    print("object3");
    naviagteIfAuthTrue(isAuthenticated);
    print(isAuthenticated);
  }

  naviagteIfAuthTrue(isAuthentiated) {
    if (isAuthentiated == true) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
