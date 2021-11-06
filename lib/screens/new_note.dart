import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_nota_app/helper/contants.dart';
import 'package:firebase_nota_app/services/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewTweet extends StatefulWidget {
  final bool? isUpdateData;
  final String? referenceId;
  const NewTweet({Key? key, this.isUpdateData, this.referenceId})
      : super(key: key);

  @override
  _NewTweetState createState() => _NewTweetState();
}

class _NewTweetState extends State<NewTweet> {
  late String _path;
  late Map<String, String> _paths;
  late String _extension;
  late FileType _pickType;
  late File? file;
  late int? lenght;
  late String? folderLocation;
  late bool isLoading = false;
  late bool isUploading = false;
  late bool isUploaded = false;
  String? imageURL;
  final formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  final TextEditingController _tagsController1 = TextEditingController();
  final TextEditingController _tagsController2 = TextEditingController();
  DateTime? selectedDate = DateTime.now();
  tagMethod(straing1, straing2, straing3) {
    List<String>? tags = [straing1, straing2, straing3];
    return tags;
  }

  List<String>? tags = [];
  methodConvert() {
    tags = tagMethod(
        _tagsController.text, _tagsController2.text, _tagsController1.text);
  }

  sendTweet() {
    if (widget.isUpdateData != true) {
      if (_titleController.text.isNotEmpty) {
        Map<String, dynamic> messageMap = {
          "tags": tags,
          "title": _titleController.text,
          "content": _contentController.text,
          "time": selectedDate,
          "imageURl": imageURL,
        };
        DatabaseMethods().addNotes(messageMap, Constants.myName);
        Navigator.of(context).pop();
        _titleController.text = "";
        _contentController.text = "";
        _tagsController.text = "";
      }
    } else {
      // /this should be noted editing time and all are in balance
      DatabaseMethods().updateNotes(_contentController.text,
          widget.referenceId.toString(), Constants.myName);
      Navigator.of(context).pop();
      _contentController.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    upload(fileName, filePath) async {
      _extension = fileName.toString().split('.').last;
      Reference storageRef =
          FirebaseStorage.instance.ref().child("images/$fileName");
      setState(() {
        isUploading = true;
      });
      final UploadTask uploadTask = storageRef.putFile(
        File(filePath),
      );
      print("yyyyyyyyyyyyy");
      await uploadTask.whenComplete(() {});
      print("yyyyyyyyyyyyy");

      imageURL = await storageRef.getDownloadURL();

      setState(() {
        isLoading = false;
        isUploaded = true;
        isUploading = false;
      });

      _extension = "";
    }

    uploadToFirebase() {
      print("nnnnnnnnnnn");
      if (_path != null) {
        String fileName = _path.split('/').last;
        String filePath = _path;
        upload(fileName, filePath);
      }
    }

    void openImageFile() async {
      try {
        _path = "";
        FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom, allowedExtensions: ['jpg', 'png', 'jpeg']);
        if (result != null) {
          file = File(result.files.single.path!);
          print(file);
          _path = file!.path;
          print(_path);
        }
        // _path = await FilePicker.platform
        //     .getFilePath(type: _pickType, fileExtention: _extension);

        uploadToFirebase();
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
      if (!mounted) return;
    }

    bool isselected = false;

    _selectDate(BuildContext context) async {
      final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: selectedDate!,
        firstDate: DateTime(2010),
        lastDate: DateTime(2025),
      );
      if (selected != null && selected != selectedDate)
        setState(() {
          isselected = true;
          selectedDate = selected;
        });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        actions: [
          GestureDetector(
            onTap: () {
              methodConvert();
              sendTweet();
            },
            child: Container(
              width: 100,
              height: 20,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(25)),
              child: const Center(
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.blue, fontSize: 30),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                  maxLength: 20,
                  minLines: 1,
                  keyboardType: TextInputType.name,
                  maxLines: 10,
                  controller: _titleController,
                  style: const TextStyle(
                    fontFamily: "Poppins",
                  ),
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: 'Title'))),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
                maxLength: 20,
                minLines: 1,
                keyboardType: TextInputType.name,
                maxLines: 10,
                controller: _contentController,
                style: const TextStyle(
                  fontFamily: "Poppins",
                ),
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Content')),
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                      maxLength: 20,
                      minLines: 1,
                      keyboardType: TextInputType.name,
                      maxLines: 10,
                      controller: _tagsController,
                      style: const TextStyle(
                        fontFamily: "Poppins",
                      ),
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: 'Tags')),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                      maxLength: 20,
                      minLines: 1,
                      keyboardType: TextInputType.name,
                      maxLines: 10,
                      controller: _tagsController1,
                      style: const TextStyle(
                        fontFamily: "Poppins",
                      ),
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: 'Tags')),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                      maxLength: 20,
                      minLines: 1,
                      keyboardType: TextInputType.name,
                      maxLines: 10,
                      controller: _tagsController2,
                      style: const TextStyle(
                        fontFamily: "Poppins",
                      ),
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: 'Tags')),
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              _selectDate(context);
            },
            child:
                isselected ? Text("Add date") : Text(selectedDate.toString()),
          ),
          isUploaded
              ? Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.topLeft,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(imageURL!),
                    radius: 50,
                  ),
                )
              : Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.topLeft,
                  child: isUploading
                      ? CircularProgressIndicator()
                      : GestureDetector(
                          onTap: openImageFile,
                          child: const CircleAvatar(
                            radius: 50,
                            child: Icon(Icons.add_a_photo),
                          ),
                        ),
                )
        ],
      ),
    );
  }
}
