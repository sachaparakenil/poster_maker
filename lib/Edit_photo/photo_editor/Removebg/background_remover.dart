import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:poster_maker/Edit_photo/photo_editor/Removebg/dashed_border.dart';

class RemoveBg extends StatefulWidget {
  const RemoveBg({super.key});

  @override
  State<RemoveBg> createState() => _RemoveBgState();
}

class _RemoveBgState extends State<RemoveBg> {
  var loaded = false;
  var imgPicked = false;

  Uint8List? image;
  String imagePath = '';

  pickImage() async {
    final img = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 100);

    if (img != null) {
      imagePath = img.path;
      imgPicked = true;
      loaded = true;

      setState(() {});
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Background Remover'),
        centerTitle: true,
      ),
      body: Center(
        child: imgPicked
            ? GestureDetector(
                onTap: pickImage,
                child: Image.file(
                  File(imagePath),
                ))
            : DashedBorder(
                padding: EdgeInsets.all(40),
                color: Colors.grey,
                radius: 12,
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      pickImage();
                    },
                    child: Text('remove background'),
                  ),
                ),
              ),
      ),
      bottomNavigationBar: SizedBox(
        height: 56,
        child: ElevatedButton(
          onPressed: loaded ? () {} : null,
          child: Text('remove background'),
        ),
      ),
    );
  }
}
