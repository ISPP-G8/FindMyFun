import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<String> uploadImage(BuildContext context,
    {required String route, required String imageId}) async {
  final imagePicker = ImagePicker();
  String photoUrl = '';
  final XFile? pickedImage =
      await imagePicker.pickImage(source: ImageSource.gallery);
  if (pickedImage == null) return photoUrl;
  Reference referenceRoot = FirebaseStorage.instance.ref();
  Reference referenceDir = referenceRoot.child('$route/$imageId');
  try {
    await referenceDir.putFile(File(pickedImage.path));
    photoUrl = await referenceDir.getDownloadURL();
  } catch (e) {
    debugPrint('Error al subir la imagen: $e');
  }

  return photoUrl;
}
