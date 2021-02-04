import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:tflite/tflite.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoaded;
  File _image;
  List _output;
  final _imagepicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _isLoaded = false;

    loadmodel().then((value) {
      setState(() {
        _isLoaded = true;
      });
    });
  }

  loadmodel() async {
    Tflite.close();
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false,
    );
  }

  Future getImagefromcam() async {
    final image = await _imagepicker.getImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _isLoaded = false;
        _image = File(image.path);
      });
      classifyImage(_image);
    } else {
      print("No Image Given ??");
    }
  }

  Future getImagefromgal() async {
    final image = await _imagepicker.getImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _isLoaded = false;
        _image = File(image.path);
      });
      classifyImage(_image);
    } else {
      print("No Image Given ??");
    }
  }

  Future classifyImage(File image) async {
    var recognitions = await Tflite.runModelOnImage(
        path: image.path,
        imageMean: 127.0,
        imageStd: 127.0,
        numResults: 3,
        threshold: 0.5,
        asynch: true);
    setState(() {
      _isLoaded = true;
      _output = recognitions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Fruit-Vegetale Classifier",
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          _isLoaded
              ? Center(
                  child: _image != null
                      ? Container(
                          height: 500,
                          width: MediaQuery.of(context).size.width - 20,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            color: Color(0xFFd3e0ea),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Image.file(_image),
                        )
                      : Center(
                          child: Container(
                            height: 500,
                            width: MediaQuery.of(context).size.width - 20,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 2),
                              color: Color(0xFFd3e0ea),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                                child: LottieBuilder.asset(
                                    "assets/lens-looking.json")),
                          ),
                        ))
              : Center(
                  child: Container(
                    height: 500,
                    width: MediaQuery.of(context).size.width - 20,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      color: Color(0xFFd3e0ea),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                        child: LottieBuilder.asset("assets/lens-looking.json")),
                  ),
                ),
          _isLoaded
              ? _image != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Container(
                        decoration: _image != null
                            ? BoxDecoration(
                                color: Color(0xFF51c2d5),
                                border: Border.all(
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(10))
                            : null,
                        child: Center(
                          child: Text(
                            "Its" +
                                "${_output[0]['label']}".replaceAll(
                                    RegExp(
                                      r'[0-9]',
                                    ),
                                    ''),
                            style: TextStyle(
                              fontSize: 25,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        height: 100,
                      ),
                    )
                  : SizedBox(
                      height: 80,
                    )
              : SizedBox(
                  height: 80,
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MaterialButton(
                height: 50,
                elevation: 10,
                splashColor: Colors.red[200],
                onPressed: getImagefromcam,
                child: Column(
                  children: [
                    Icon(Icons.camera_alt),
                    Text(
                      "Camera",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                color: Colors.brown[400],
              ),
              MaterialButton(
                height: 50,
                elevation: 10,
                splashColor: Colors.red[200],
                onPressed: getImagefromgal,
                child: Column(
                  children: [
                    Icon(
                      Icons.photo_library_outlined,
                    ),
                    Text(
                      "Galary",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
                color: Colors.brown[400],
              ),
            ],
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isLoaded = false;
            _image = null;
            loadmodel().then((value) {
              setState(() {
                _isLoaded = true;
              });
            });
          });
        },
        child: Icon(Icons.restore),
      ),
    );
  }
}
