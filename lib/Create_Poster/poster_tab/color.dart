import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_editor_plus/image_editor_plus.dart';

class Tab5Screen extends StatefulWidget {
  const Tab5Screen({super.key});

  @override
  State<Tab5Screen> createState() => _Tab5ScreenState();
}

class _Tab5ScreenState extends State<Tab5Screen> {
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
          title: const Text('Pick a color'),
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
                ColorizedImage(
                  color: selectedColor, // Change the color to your desired one
                  imagePath: 'assets/poster/2.jpg', // Provide the image path
                );

                Navigator.pop(context);
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
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
            padding: const EdgeInsets.all(20),
            itemBuilder: (BuildContext context, int index) {
              final Color color = basicColors[index];
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedColor = color;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ImageEditorColor(
                          colorizedImage: ColorizedImage(
                            color: Colors.red,
                            imagePath: 'assets/poster/1.jpg',
                          ),
                        ),
                      ),
                    );
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
          child: const Text('Pick a color'),
        ),
      ],
    );
  }
}

class ColorizedImage extends StatelessWidget {
  final Color color;
  final String imagePath;

  const ColorizedImage({super.key, required this.color, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        color,
        BlendMode.srcIn,
      ),
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        height: 300,
        width: 300,
      ),
    );
  }
}

class ImageEditorColor extends StatefulWidget {
  final ColorizedImage colorizedImage;

  const ImageEditorColor({Key? key, required this.colorizedImage}) : super(key: key);

  @override
  createState() => _ImageEditorColorState();
}

class _ImageEditorColorState extends State<ImageEditorColor> {
  Uint8List? imageData;
  ColorizedImage? colorizedImage;

  @override
  void initState() {
    super.initState();
    colorizedImage = widget.colorizedImage;
    loadImage(colorizedImage!);
  }

  void loadImage(ColorizedImage colorizedImage) async {
    final GlobalKey boundaryKey = GlobalKey();

    final imageWidget = RepaintBoundary(
      key: boundaryKey,
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          colorizedImage.color,
          BlendMode.srcIn,
        ),
        child: Image.asset(
          colorizedImage.imagePath,
          fit: BoxFit.cover,
          height: 300,
          width: 300,
        ),
      ),
    );

    final boundary =
        boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final imageByteData = await boundary.toImage(pixelRatio: 1.0);
    final imageBytes =
        await imageByteData.toByteData(format: ImageByteFormat.png);

    if (imageBytes != null) {
      setState(() {
        imageData = imageBytes.buffer.asUint8List();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Poster Maker"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.download),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imageData != null) Image.memory(imageData!),
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
