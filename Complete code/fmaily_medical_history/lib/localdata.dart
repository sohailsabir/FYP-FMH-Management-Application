import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveData(String text, String imageUrl) async {
    await _firestore.collection('data').add({
      'text': text,
      'image_url': imageUrl,
    });
  }
}

class Testing extends StatefulWidget {
  @override
  _TestingState createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  bool _isConnected = true;
  List<Map<String, dynamic>> _pendingData = [];
  File? _image;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _isConnected = result != ConnectivityResult.none;
      });
      if (_isConnected) {
        // Upload pending data when the internet connection is restored
        _uploadLocalData();
      }
    });

    // Upload local data when the app starts
    _uploadLocalData();
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  Future<String> _uploadImage(File image) async {
    final firebase_storage.Reference ref =
    firebase_storage.FirebaseStorage.instance.ref().child('images/${DateTime.now()}.jpg');
    final firebase_storage.UploadTask uploadTask = ref.putFile(image);
    final firebase_storage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<void> _saveDataLocally(String text, String imagePath) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> localData = prefs.getStringList('localData') ?? [];

    localData.add('$text,$imagePath');
    await prefs.setStringList('localData', localData);
  }

  Future<void> _uploadLocalData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> localData = prefs.getStringList('localData') ?? [];

    for (final data in localData) {
      final List<String> values = data.split(',');
      final String text = values[0];
      final String imagePath = values[1];

      final File imageFile = File(imagePath);
      final imageUrl = await _uploadImage(imageFile);
      FirebaseService().saveData(text, imageUrl);
    }

    // Clear local data after successful upload
    await prefs.remove('localData');
  }

  Future<void> _getImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _saveData() async {
    if (_isConnected) {
      if (_image != null) {
        final imageUrl = await _uploadImage(_image!);
        final text = 'Your text'; // Replace 'Your text' with the actual text input value
        FirebaseService().saveData(text, imageUrl);
      }
    } else {
      final text = 'Your text'; // Replace 'Your text' with the actual text input value
      final imagePath = _image?.path ?? '';
      _pendingData.add({
        'text': text,
        'imagePath': imagePath,
      });

      // Save data locally
      await _saveDataLocally(text, imagePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image != null
                ? Image.file(
              _image!,
              height: 200,
            )
                : const SizedBox(),
            ElevatedButton(
              onPressed: _getImage,
              child: const Text('Pick Image'),
            ),
            ElevatedButton(
              onPressed: _saveData,
              child: const Text('Save Data'),
            ),
          ],
        ),
      ),
    );
  }
}

