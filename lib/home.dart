// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

///import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  pickimage_camera() async {
    var image = await imagepicker.getImage(source: ImageSource.camera);
    if (image == null) {
      return null;
    } else {
      _image = File(image.path);
    }
    detectimage(_image);
  }

  pickimage_gallery() async {
    var image = await imagepicker.getImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    } else {
      _image = File(image.path);
    }
    detectimage(_image);
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text('Maskify')),
      body: Container(
        height: h,
        width: w,
        color: Color.fromARGB(255, 181, 200, 207),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 150,
              width: 200,
              // color: Colors.teal,
              child: Image.asset('assets/mask.jpg'),
              // ignore: prefer_const_constructors
              padding: EdgeInsets.all(10),
            ),
            Container(
              // ignore: prefer_const_constructors
              child: Text(
                'Welcome to Maskify!',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            Container(
              width: 250,
              height: 70,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(15),
              child: ElevatedButton(
                child: Text('Camera'),
                style: ElevatedButton.styleFrom(
                    primary: Colors.teal,
                    textStyle: TextStyle(fontSize: 20),
                    elevation: 5,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)))),
                onPressed: () {
                  pickimage_camera();
                },
              ),
            ),
            Container(
              width: 250,
              height: 70,
              // margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(15),
              child: ElevatedButton(
                child: Text('Gallery'),
                style: ElevatedButton.styleFrom(
                    primary: Colors.teal,
                    textStyle: TextStyle(fontSize: 20),
                    elevation: 5,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)))),
                onPressed: () {
                  pickimage_gallery();
                },
              ),
            ),
            loading != true
                ? Container(
                    child: Column(
                      children: [
                        Container(
                          height: 220,
                          // width: double.infinity,
                          padding: EdgeInsets.all(15),
                          child: Image.file(_image),
                        ),
                        _output != null
                            ? Text(
                                (_output[0]['label']).toString().substring(2),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold))
                            : Text(''),
                        _output != null
                            ? Text(
                                'Confidence: ' +
                                    (_output[0]['confidence'] * 100).toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold))
                            : Text('')
                      ],
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  bool loading = true;
  late File _image;
  late List _output;
  final imagepicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadmodel().then((value) {
      setState(() {});
    });
  }

  detectimage(File image) async {
    var prediction = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,
        threshold: 0.6,
        imageMean: 127.5,
        imageStd: 127.5);

    setState(() {
      _output = prediction!;
      loading = false;
    });
  }

  loadmodel() async {
    await Tflite.loadModel(
        model: 'assets/model_unquant.tflite', labels: 'assets/labels.txt');
  }

  @override
  void dispose() {
    super.dispose();
  }
}
