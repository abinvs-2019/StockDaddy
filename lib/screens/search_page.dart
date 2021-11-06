import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_nota_app/helper/contants.dart';
import 'package:firebase_nota_app/services/database.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchcontreller = TextEditingController();

  QuerySnapshot? searchSnapshot;

  nitiateSearch() {
    print("method called");
    print(Constants.myName);
    DatabaseMethods()
        .searchNotesbyTags(Constants.myName, _searchcontreller.text)
        .then((val) {
      setState(() {
        searchSnapshot = val;
        print(searchSnapshot!);
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot!.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearcTile(
                imageUrl: searchSnapshot!.docs[index]["imageURl"],
                content: searchSnapshot!.docs[index]["content"],
                title: searchSnapshot!.docs[index]["title"],
              );
            })
        : Container(
            child: Center(
            child: Text("No Such Users"),
          ));
  }

  Widget SearcTile({
    String? title,
    imageUrl,
    String? content,
  }) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title!,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  content!,
                  style: TextStyle(fontSize: 18),
                ),
                imageUrl != null
                    ? Image.network(
                        imageUrl,
                        height: 100,
                      )
                    : Container()
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onSubmitted: nitiateSearch(),
                      onChanged: ((value) {
                        nitiateSearch();
                      }),
                      controller: _searchcontreller,
                      decoration: InputDecoration(
                          hintText: "search", border: InputBorder.none),
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        nitiateSearch();
                      },
                      child: Container(child: Icon(Icons.search)))
                ],
              ),
            ),
            searchList(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.search),
          onPressed: () {
            nitiateSearch();
          },
        ),
      ),
    );
  }
}
