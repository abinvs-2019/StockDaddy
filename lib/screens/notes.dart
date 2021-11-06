import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_nota_app/helper/contants.dart';
import 'package:firebase_nota_app/helper/login_helper.dart';
import 'package:firebase_nota_app/screens/search_page.dart';
import 'package:firebase_nota_app/services/database.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'new_note.dart';
import 'singup_page.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  TextEditingController messageController = TextEditingController();

  Stream? tweetStream;

  bool loading = false;
  ScrollController _controller = ScrollController();

  Widget tweetMessageList() {
    return StreamBuilder(
        stream: tweetStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  controller: _controller,
                  itemCount: (snapshot.data! as QuerySnapshot).docs.length,
                  itemBuilder: (context, index) {
                    return tweetTile(
                      isImage: (snapshot.data! as QuerySnapshot).docs[index]
                              ['imageURl'] !=
                          null,
                      imgUrl: (snapshot.data! as QuerySnapshot).docs[index]
                          ['imageURl'],
                      content: (snapshot.data! as QuerySnapshot).docs[index]
                          ['content'],
                      referenseId: (snapshot.data! as QuerySnapshot)
                          .docs[index]
                          .reference
                          .id,
                      time: (snapshot.data! as QuerySnapshot).docs[index]
                          ['time'],
                      message: (snapshot.data! as QuerySnapshot).docs[index]
                          ['title'],
                    );
                  })
              : Container(
                  child: Center(child: Text("No Chats yet?..Start by typing.")),
                );
        });
  }

  @override
  void initState() {
    HelperFunction.getuserNameInSharedPreferrence().then((val) async {
      Constants.myName = val;
      print("nameis ${Constants.myName}");
    });
    DatabaseMethods().getNotes(Constants.myName).then((value) {
      setState(() {
        tweetStream = value;

        print("chatmessagestream$tweetStream");
      });
    });

    super.initState();
  }

  signout() async {
    await authMethod.signOut();
    HelperFunction.saveuserLoggedInSharedPreferrence(false);
    Constants.userIsLoggedIn = false;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Note Keeper"),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchPage()));
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              signout();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: tweetMessageList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const NewTweet()));
        },
      ),
    );
  }
}

class tweetTile extends StatelessWidget {
  final List<String>? tags = [];
  final String? referenseId;
  var time;
  final String? message;
  final String? content;
  final String? imgUrl;
  final bool? isImage;
  tweetTile({
    this.referenseId,
    this.imgUrl,
    this.isImage,
    this.message,
    this.time,
    this.content,
  });
  var _controller;

  var videoUrl;
  @override
  Widget build(BuildContext context) {
    var popUpMentValue;
    time = DateTime.fromMicrosecondsSinceEpoch(time.microsecondsSinceEpoch);
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      message!,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                    Text(time.toString()),
                    Container(
                        alignment: Alignment.topRight,
                        child: PopupMenuButton(
                            itemBuilder: (_) => const <PopupMenuItem<String>>[
                                  PopupMenuItem<String>(
                                      child: Text('Edit'), value: 'Edit'),
                                  PopupMenuItem<String>(
                                      child: Text('Delete'), value: 'Delete'),
                                ],
                            onSelected: (value) {
                              if (value == "Edit") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NewTweet(
                                            isUpdateData: true,
                                            referenceId: referenseId)));
                              } else if (value == "Delete") {
                                DatabaseMethods()
                                    .deleteNote(referenseId, Constants.myName);
                              }
                            })),
                  ],
                ),
                Text(
                  content!,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
                isImage! ? Image.network(imgUrl!) : Container()
              ],
            ),
          ),
        ),
        const Divider()
      ],
    );
  }
}
