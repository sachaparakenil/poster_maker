import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class ResizePhoto extends StatefulWidget {
  const ResizePhoto({super.key});

  @override
  State<ResizePhoto> createState() => _ResizePhotoState();
}

class _ResizePhotoState extends State<ResizePhoto> {
  File? selectedImage;
  BoxFit selectedFit = BoxFit.fill;
  String? imagePath;
  final GlobalKey _containerKey = GlobalKey();

  void updateFit(BoxFit fit) {
    setState(() {
      selectedFit = fit;
    });
  }

  Future<void> saveImageToGallery() async {
    if (selectedImage == null) {
      return;
    }

    try {
      final appDir = await getExternalStorageDirectory();
      const fileName = 'my_image.jpg';
      final savedImage = File('${appDir!.path}/$fileName');

      // Capture the widget as an image
      final boundary = _containerKey.currentContext!.findRenderObject()
          as RenderRepaintBoundary;
      final image = await boundary.toImage(
          pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final buffer = byteData!.buffer.asUint8List();

      final uint8List = Uint8List.fromList(buffer);
      final result = await ImageGallerySaver.saveImage(uint8List);

      setState(() {
        imagePath = savedImage.path;
      });

      if (result == null || result.isEmpty) {
        showImageSavedDialog('Failed to save the image.');
      } else {
        showImageSavedDialog('The image has been saved to the gallery.');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving image: $e');
      }
      showImageSavedDialog('Error saving the image: $e');
    }
  }

  void showImageSavedDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Image Saved'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      selectedImage = File(returnedImage.path);
    });
  }

  Future pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImage == null) return;
    setState(() {
      selectedImage = File(returnedImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Resize Image"),
      ),
      body: ListView(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  ElevatedButton(
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image),
                        SizedBox(width: 5),
                        Text('Gallery'),
                      ],
                    ),
                    onPressed: () {
                      pickImageFromGallery();
                    },
                  ),
                  const Divider(),
                  ElevatedButton(
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt_outlined),
                        SizedBox(width: 5),
                        Text('Camera'),
                      ],
                    ),
                    onPressed: () {
                      pickImageFromCamera();
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (selectedImage == null) ...{
                    const Center(
                      child: Text(
                        'Select image',
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  } else ...{
                    Center(
                      child: RepaintBoundary(
                        key: _containerKey,
                        child: Container(
                          color: Colors.indigo,
                          height: 550,
                          width: 300,
                          child: Image.file(
                            selectedImage!,
                            fit: selectedFit,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: ElevatedButton(
                              onPressed: () {
                                updateFit(BoxFit.fitWidth);
                              },
                              child: const Text('FitWidth'),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: ElevatedButton(
                              onPressed: () {
                                updateFit(BoxFit.fitHeight);
                              },
                              child: const Text('FitHeight'),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: ElevatedButton(
                              onPressed: () {
                                updateFit(BoxFit.scaleDown);
                              },
                              child: const Text('scaleDown'),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: ElevatedButton(
                              onPressed: () {
                                updateFit(BoxFit.contain);
                              },
                              child: const Text('Fit'),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: ElevatedButton(
                              onPressed: () {
                                updateFit(BoxFit.cover);
                              },
                              child: const Text('Cover'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed:
                          saveImageToGallery,
                      child: const Text('Save Image'),
                    ),
                  }
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}