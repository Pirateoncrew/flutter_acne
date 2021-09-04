import 'package:camera/camera.dart';
import 'package:camera_application/Home/Presentation/View/homepage.view.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.last;
  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final CameraDescription camera;
  const MyApp({Key? key, required this.camera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomepageView(
        camera: camera,
      ),
    );
  }
}
