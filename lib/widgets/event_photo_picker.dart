import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EventPhotoPicker extends StatefulWidget {
  @override
  _EventPhotoPicker createState() => _EventPhotoPicker();
}

class _EventPhotoPicker extends State<EventPhotoPicker> {
  /// Variables
  File? pickedPhoto;
  bool isPicked = false;

  /// Widget
  @override
  Widget build(BuildContext context) {
    return Container(
        child: pickedPhoto == null
            ? Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/no-image-available.png',
                      fit: BoxFit.cover,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _getFromGallery();
                          },
                          child: const Text("ABRIR GALERÍA"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _getFromCamera();
                          },
                          child: const Text("ABRIR CÁMARA"),
                        )
                      ],
                    )
                  ],
                ),
              )
            : Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.file(
                      pickedPhoto!,
                      fit: BoxFit.cover,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _getFromGallery();
                          },
                          child: const Text("ABRIR GALERÍA"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _getFromCamera();
                          },
                          child: const Text("ABRIR CÁMARA"),
                        )
                      ],
                    ),
                  ],
                ),
              ));
  }

  /// Get from gallery
  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        pickedPhoto = File(pickedFile.path);
      });
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        pickedPhoto = File(pickedFile.path);
      });
    }
  }
}
