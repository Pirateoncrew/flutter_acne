import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ImageUpload extends StatefulWidget {
  const ImageUpload(
      {Key? key,
      required this.switchView,
      required this.uploadFile,
      required this.imageFiles})
      : super(key: key);

  final dynamic switchView;
  final dynamic uploadFile;
  final dynamic imageFiles;

  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  late String image;
  var isLoaded = false;

  _getFromGallery() async {
    dynamic pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      var demo = File(pickedFile.path);
      print(demo);
      setState(() {
        uploadFile(File(pickedFile.path));
        // imageFile = File(pickedFile.path);
      });
    }
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
    // Directory tempDir = await getTemporaryDirectory();
    // String tempPath = tempDir.path;

    // var _transferedImage =
    //     File(tempPath); // must assign a File to _transferedImage
    // IOSink sink = _transferedImage.openWrite();

    // await sink.addStream(
    //     response.stream); // this requires await as addStream is async
    // await sink.close();
    // print(_transferedImage);
    var path = temp['data'];
    setState(() {
      image = "http://192.168.0.115:8000/$path";
      isLoaded = true;
    });
  }

  Widget _previewImages() {
    return Center(
      child: Image.network(image),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              setState(() {
                isLoaded = false;
                image = '';
                this.widget.switchView('buttons');
              });
            },
            icon: const Icon(Icons.keyboard_arrow_left)),
        title: Text('Image Upload'),
      ),
      body: Center(
        child: !isLoaded
            ? TextButton(onPressed: _getFromGallery, child: Text("Upload"))
            : _previewImages(),
      ),
    );
  }
}
