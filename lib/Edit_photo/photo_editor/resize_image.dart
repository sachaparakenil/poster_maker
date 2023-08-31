import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ResizePhoto extends StatefulWidget {
  const ResizePhoto({super.key});

  @override
  State<ResizePhoto> createState() => _ResizePhotoState();
}

class _ResizePhotoState extends State<ResizePhoto> {
  File? selectedImage;

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
      body: SingleChildScrollView(
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
              if (selectedImage != null) ...[
                Text("Original Size"),
                Image.file(selectedImage!),
                const SizedBox(height: 20),
                Text("Resize Size"),
                Image.file(selectedImage!, width: 200, height: 200),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
