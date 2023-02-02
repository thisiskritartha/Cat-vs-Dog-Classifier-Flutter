import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ImagePicker imagePicker;
  File? img;
  String result = '';
  late List output;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    loadModel();
  }

  @override
  void dispose() {
    super.dispose();
  }

  detectImage() async {
    var recognitions = await Tflite.runModelOnImage(
        path: img!.path, // required
        imageMean: 127.5, // defaults to 117.0
        imageStd: 127.5, // defaults to 1.0
        numResults: 2, // defaults to 5
        threshold: 0.2, // defaults to 0.1
        asynch: true // defaults to true
        );
    setState(() {
      output = recognitions!;
    });
  }

  loadModel() async {
    result = (await Tflite.loadModel(
      model: "assets/ml/model_unquant.tflite",
      labels: "assets/ml/labels.txt",
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false,
    ))!;
  }

  imgFromGallery() async {
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);
    img = File(image!.path);
    setState(() {
      img;
      detectImage();
    });
  }

  imgFromCamera() async {
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.camera);
    img = File(image!.path);
    setState(() {
      img;
      detectImage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'Cat vs Dog Classifier',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: img == null
                      ? SizedBox(
                          width: 400,
                          child: Column(
                            children: [
                              Image.asset('images/cat_dog_icon.png'),
                            ],
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              Image.file(img!),
                              const SizedBox(height: 15),
                              Text(
                                'Result: ${output[0]['label']}.\tConfidence level: ${output[0]['confidence']}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              )
                            ],
                          ),
                        ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          imgFromGallery();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width - 150,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 25,
                                color: Colors.black,
                                offset: Offset(10, 10),
                              )
                            ],
                          ),
                          child: const Text(
                            'Open Gallery',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          imgFromCamera();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width - 150,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 25,
                                color: Colors.black,
                                offset: Offset(10, 10),
                              )
                            ],
                          ),
                          child: const Text(
                            'Open Camera',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
