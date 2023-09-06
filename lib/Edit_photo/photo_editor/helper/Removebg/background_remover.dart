import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'api.dart';
import 'dashed_border.dart';

class RemoveBg extends StatefulWidget {
  const RemoveBg({super.key});

  @override
  State<RemoveBg> createState() => _RemoveBgState();
}

class _RemoveBgState extends State<RemoveBg> {
  var loaded = false;
  var removeBg = false;
  var isLoading = false;
  var value = 0.5;
  ScreenshotController screenshotController = ScreenshotController();
  final GlobalKey _containerKey = GlobalKey();

  Uint8List? image;
  String imagePath = '';

  pickImage() async {
    final img = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 100);

    if (img != null) {
      imagePath = img.path;
      loaded = true;

      setState(() {});
    } else {}
  }

  Future<void> saveImageToGallery() async {
    if (Image.memory(image!) == null) {
      return;
    }

    try {
      final appDir = await getExternalStorageDirectory();
      const fileName = 'my_image.jpg';
      final savedImage = File('${appDir!.path}/$fileName');

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                saveImageToGallery();
              },
              icon: const Icon(Icons.download))
        ],
        elevation: 0,
        title: const Text('Background Remover'),
        centerTitle: true,
      ),
      body: Center(
        child: removeBg
            ? RepaintBoundary(key: _containerKey, child: Image.memory(image!))
            : loaded
                ? GestureDetector(
                    onTap: pickImage,
                    child: Image.file(
                      File(imagePath),
                    ))
                : DashedBorder(
                    padding: const EdgeInsets.all(40),
                    color: Colors.grey,
                    radius: 12,
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {
                          pickImage();
                        },
                        child: const Text('remove background'),
                      ),
                    ),
                  ),
      ),
      bottomNavigationBar: SizedBox(
        height: 56,
        child: ElevatedButton(
          onPressed: loaded
              ? () async {
                  setState(() {
                    isLoading = true;
                  });
                  image = await Api.removeBg(imagePath);
                  if (image != null) {
                    removeBg = true;
                    isLoading = false;
                    setState(() {});
                  }
                }
              : null,
          child: isLoading
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                )
              : const Text('remove background'),
        ),
      ),
    );
  }
}
