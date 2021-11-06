import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_nota_app/helper/contants.dart';

class DatabaseMethods {
  getUserbyUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .get();
  }

  getUserbyEmail(String userEmail) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: userEmail)
        .get();
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap).catchError((e) {
      print(e.toString());
    });
  }

  searchNotesbyTags(name, search) async {
    return await FirebaseFirestore.instance
        .collection("notes")
        .doc("notes")
        .collection("$name")
        .where("tags", arrayContains: search)
        .get()
        .catchError((e) {
      print("error from get search $e");
    });
  }

  Future deleteNote(idd, name) async {
    var id;
    await FirebaseFirestore.instance
        .collection("notes")
        .doc("notes")
        .collection(name)
        .doc("$idd")
        .delete();
  }

  Future addNotes(messageMap, String? name) async {
    var id;
    await FirebaseFirestore.instance
        .collection("notes")
        .doc("notes")
        .collection("$name")
        .add(messageMap)
        .then((value) => {id = value.id});
    if (id != null) {
      return id;
    } else {
      print("no id got");
    }
  }

  getNotes(name) async {
    return await FirebaseFirestore.instance
        .collection("notes")
        .doc("notes")
        .collection("$name")
        .orderBy("time", descending: true)
        .snapshots();
  }

  Future updateNotes(messageMap, idd, String? name) async {
    var id;
    await FirebaseFirestore.instance
        .collection("notes")
        .doc("notes")
        .collection("$name")
        .doc("$idd")
        .update({
      "message": "$messageMap",
    }).then((value) => {});
    if (id != null) {
      return id;
    } else {
      print("no id got");
    }
  }
}
