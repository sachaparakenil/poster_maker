import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Tab4Screen extends StatefulWidget {
  const Tab4Screen({super.key});

  @override
  State<Tab4Screen> createState() => _Tab4ScreenState();
}

class _Tab4ScreenState extends State<Tab4Screen> {
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.symmetric(horizontal: 70, vertical: 8),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image),
                SizedBox(
                  width: 5,
                ),
                Text(' Gallery'),
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
                  SizedBox(
                    width: 5,
                  ),
                  Text('Camera'),
                ],
              ),
              onPressed: () {
                pickImageFromCamera();
              }),
          const SizedBox(
            height: 20,
          ),
          selectedImage != null
              ? Image.file(selectedImage!)
              : const Text('Select Image')
        ],
      ),
    );
  }
}
