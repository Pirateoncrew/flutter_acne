import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:camera_application/Home/Presentation/View/camera/takePicture.view.dart';
import 'package:camera_application/Home/Presentation/View/imageUpload.view.dart';
import 'package:camera_application/Home/Presentation/Widget/buttons.widget.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';

class HomepageView extends StatefulWidget {
  final CameraDescription camera;

  const HomepageView({Key? key, required this.camera}) : super(key: key);

  @override
  _HomepageViewState createState() => _HomepageViewState();
}

class _HomepageViewState extends State<HomepageView> {
  String currentView = 'buttons';

  var imageFileRes;

  switchView(type) {
    print(type);
    setState(() {
      currentView = type;
    });
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
    var temp = jsonDecode(responses.body);
    setState(() {
      imageFileRes = temp['data']['value'];
    });
    print(imageFileRes);
  }

  doUpload() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: currentView == 'buttons'
            ? ButtonWidget(switchView: switchView)
            : currentView == 'camera'
                ? TakePictureScreen(
                    camera: this.widget.camera, switchView: switchView)
                : ImageUpload(
                    switchView: switchView,
                    uploadFile: uploadFile,
                    imageFiles: imageFileRes),
      ),
    );
  }
}
