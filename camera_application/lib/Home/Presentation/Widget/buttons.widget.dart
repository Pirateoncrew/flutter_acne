import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final dynamic switchView;
  const ButtonWidget({Key? key, required this.switchView}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          color: Colors.blueAccent,
          onPressed: () {
            switchView('camera');
          },
          icon: const Icon(
            Icons.camera_alt_rounded,
            color: Colors.blueAccent,
          ),
        ),
        IconButton(
          onPressed: () {
            switchView('gallery');
          },
          icon: const Icon(
            Icons.collections,
            color: Colors.blueAccent,
          ),
        )
      ],
    );
  }
}
