import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class DisplayPictureScreen extends StatefulWidget {
  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);
  final String imagePath;

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  late String image;
  var loading = true;
  _saveScreen() async {
    // final result = await Image
  }
  @protected
  @mustCallSuper
  void initState() {
    super.initState();
    uploadFile(File(this.widget.imagePath));
  }

  uploadFile(File imageFile) async {
    var uri = Uri.parse("http://192.168.0.115:8000/uploadSelfieFile");

    var request = http.MultipartRequest(
      'POST',
      uri,
    );
    Map<String, String> headers = {"Content-type": "multipart/form-data"};
    request.files.add(
      http.MultipartFile(
        'file',
        imageFile.readAsBytes().asStream(),
        imageFile.lengthSync(),
        filename: "filename",
        contentType: MediaType('image', 'jpeg'),
      ),
    );
    request.headers.addAll(headers);
    print("request: " + request.toString());
    var response = await request.send();

    var responses = await http.Response.fromStream(response);
    Map<String, dynamic> temp = json.decode(responses.body);
    print(temp['data']);
    var path = temp['data'];
    setState(() {
      image = "http://192.168.0.115:8000/$path";
      loading = false;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      body: !loading ? Image.network(image) : Text('Loading'),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveScreen,
        child: const Icon(Icons.save_alt_outlined),
      ),
    );
  }
}
