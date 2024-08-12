import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageService extends ChangeNotifier {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String _imagePath = '';

  String get imageUrl => _imagePath;
  File? get imageFile => _imageFile;

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
    } else {
      print('No image selected.');
    }

    if (_imageFile == null) return;

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('uploads/${DateTime.now().millisecondsSinceEpoch}.jpg');

      final uploadTask = storageRef.putFile(_imageFile!);

      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      _imagePath = downloadUrl;
      notifyListeners();

      print('Uploaded image URL: $_imagePath');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }
}
