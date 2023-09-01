import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_editor_plus/utils.dart';

class ImageEditorExample extends StatefulWidget {
  const ImageEditorExample({
    super.key, required this.data
  });
final String data;
  @override
  createState() => _ImageEditorExampleState();
}

class _ImageEditorExampleState extends State<ImageEditorExample> {
  Uint8List? imageData;
  String get imagePath => widget.data;

  @override
  void initState() {
    super.initState();
    loadAsset(imagePath);
  }

  void loadAsset(String name) async {
    var data = await rootBundle.load(name);
    setState(() => imageData = data.buffer.asUint8List());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ImageEditor Example"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imageData != null) Image.memory(imageData!),
          const SizedBox(height: 16),
          ElevatedButton(
            child: const Text("Single image editor"),
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
          ElevatedButton(
            child: const Text("Multiple image editor"),
            onPressed: () async {
              var editedImage = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageEditor(
                    images: [
                      imageData,
                      imageData,
                    ],
                    features: const ImageEditorFeatures(
                      pickFromGallery: true,
                      captureFromCamera: true,
                      crop: true,
                      blur: true,
                      brush: true,
                      emoji: true,
                      filters: true,
                      flip: true,
                      rotate: true,
                      text: true,
                    ),
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