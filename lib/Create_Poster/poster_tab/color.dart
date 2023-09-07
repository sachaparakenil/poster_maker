import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class Tab4Screen extends StatefulWidget {
  @override
  State<Tab4Screen> createState() => _Tab4ScreenState();
}

class _Tab4ScreenState extends State<Tab4Screen> {
  final List<Color> basicColors = [
    Colors.red.shade900,
    Colors.red.shade700,
    Colors.red.shade500,
    Colors.red.shade300,
    Colors.red.shade100,
    Colors.green.shade900,
    Colors.green.shade700,
    Colors.green.shade500,
    Colors.green.shade300,
    Colors.green.shade100,
    Colors.blue.shade900,
    Colors.blue.shade700,
    Colors.blue.shade500,
    Colors.blue.shade300,
    Colors.blue.shade100,
    Colors.yellow.shade900,
    Colors.yellow.shade700,
    Colors.yellow.shade500,
    Colors.yellow.shade300,
    Colors.yellow.shade100,
    Colors.orange.shade900,
    Colors.orange.shade700,
    Colors.orange.shade500,
    Colors.orange.shade300,
    Colors.orange.shade100,
    Colors.purple.shade900,
    Colors.purple.shade700,
    Colors.purple.shade500,
    Colors.purple.shade300,
    Colors.purple.shade100,
    Colors.pink.shade900,
    Colors.pink.shade700,
    Colors.pink.shade500,
    Colors.pink.shade300,
    Colors.pink.shade100,
    Colors.teal.shade900,
    Colors.teal.shade700,
    Colors.teal.shade500,
    Colors.teal.shade300,
    Colors.teal.shade100,
    Colors.indigo.shade900,
    Colors.indigo.shade700,
    Colors.indigo.shade500,
    Colors.indigo.shade300,
    Colors.indigo.shade100,
    Colors.brown.shade900,
    Colors.brown.shade700,
    Colors.brown.shade500,
    Colors.brown.shade300,
    Colors.brown.shade100,
    Colors.cyan.shade900,
    Colors.cyan.shade700,
    Colors.cyan.shade500,
    Colors.cyan.shade300,
    Colors.cyan.shade100,
    Colors.grey.shade900,
    Colors.grey.shade700,
    Colors.grey.shade500,
    Colors.grey.shade300,
    Colors.grey.shade100,
    Colors.lime.shade900,
    Colors.lime.shade700,
    Colors.lime.shade500,
    Colors.lime.shade300,
    Colors.lime.shade100,
  ];
  Color selectedColor = Colors.white;
  void _openColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (Color color) {
                setState(() {
                  selectedColor = color;
                });
              },
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (kDebugMode) {
                  print(selectedColor);
                }
                Navigator.of(context).pop();
                ColorizedImage(
                  color: selectedColor,
                  imagePath: 'assets/poster/2.jpg',
                );
                loadImage();
              },
              child: Text('Done'),
            ),
          ],
        );
      },
    );
  }

  Future<void> loadImage() async {
    Uint8List? colorizedImageData = await ColorizedImage(
      color: selectedColor,
      imagePath: 'assets/poster/1.jpg',
    ).generateColorizedImage();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageEditorColor(
          colorizedImage: colorizedImageData,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
            ),
            itemCount: basicColors.length,
            padding: EdgeInsets.all(20),
            itemBuilder: (BuildContext context, int index) {
              final Color color = basicColors[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedColor = color;
                    if (kDebugMode) {
                      print(selectedColor);
                    }
                    loadImage();
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                ),
              );
            },
          ),
        ),
        ElevatedButton(
          onPressed: _openColorPicker,
          child: Text('Pick a color'),
        ),
      ],
    );
  }
}

class ColorizedImage extends StatelessWidget {
  final Color color;
  final String imagePath;

  ColorizedImage({required this.color, required this.imagePath});

  Future<Uint8List> generateColorizedImage() async {
    final completer = Completer<Uint8List>();

    final recorder = ui.PictureRecorder();
    final canvas =
        Canvas(recorder, Rect.fromPoints(Offset(0, 0), Offset(300, 300)));

    // Apply color filter to the image
    final paint = Paint()
      ..colorFilter = ColorFilter.mode(color, BlendMode.srcIn);
    final image = await loadImage(imagePath);
    canvas.drawImage(image, Offset.zero, paint);

    final picture = recorder.endRecording();
    final img = await picture.toImage(600, 900);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    completer.complete(Uint8List.sublistView(byteData!.buffer.asUint8List()));

    return completer.future;
  }

  Future<ui.Image> loadImage(String path) async {
    final data = await rootBundle.load(path);
    final codec = await ui.instantiateImageCodec(
        Uint8List.sublistView(data.buffer.asUint8List()));
    final frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: generateColorizedImage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final Uint8List imageBytes = snapshot.data!;
          return Image.memory(imageBytes);
        } else {
          return Text('No Data');
        }
      },
    );
  }
}

class ImageEditorColor extends StatefulWidget {
  ImageEditorColor({Key? key, this.colorizedImage});
  final Uint8List? colorizedImage;

  @override
  createState() => _ImageEditorColorState();
}

class _ImageEditorColorState extends State<ImageEditorColor> {
  Uint8List? imageData;
  final GlobalKey _containerKey = GlobalKey();
  String? imagePath;

  @override
  void initState() {
    super.initState();
    if (widget.colorizedImage != null) {
      setState(() {
        imageData = widget.colorizedImage;
      });
    }
  }

  Future<void> saveImageToGallery() async {
    if (imageData == null) {
      return;
    }

    try {
      final boundary = _containerKey.currentContext!.findRenderObject()
          as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final buffer = byteData!.buffer.asUint8List();

      final result =
          await ImageGallerySaver.saveImage(Uint8List.fromList(buffer));

      if (result != null && result.isNotEmpty) {
        // Image saved successfully
        showImageSavedDialog('The image has been saved to the gallery.');
      } else {
        // Error saving image
        showImageSavedDialog('Failed to save the image.');
      }
    } catch (e) {
      // Handle any errors that occur during the saving process
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
        title: const Text("Poster Maker"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              saveImageToGallery();
            },
            icon: const Icon(Icons.download),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imageData != null)
            RepaintBoundary(
                key: _containerKey, child: Image.memory(imageData!)),
          const SizedBox(height: 16),
          ElevatedButton(
            child: const Text("Poster editor"),
            onPressed: () async {
              var editedImage = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageEditor(
                    image: imageData,
                  ),
                ),
              );

              // replace with edited image
              if (editedImage != null) {
                imageData = editedImage;
                setState(() {});
              }
            },
          ),
        ],
      ),
    );
  }
}
