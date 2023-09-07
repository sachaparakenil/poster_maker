import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'filter.dart';
import 'dart:ui' as ui;

import 'filter_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey _globalKey = GlobalKey();
  final List<List<double>> filters = [
    SEPIA_MATRIX,
    GREYSCALE_MATRIX,
    VINTAGE_MATRIX,
    SWEET_MATRIX,
    SEPIA_INVERT_MATRIX,
    BLUR_MATRIX,
    CUSTOM_MATRIX,
    RED_FILTER_MATRIX,
    GREEN_FILTER_MATRIX,
    BLUE_FILTER_MATRIX,
    YELLOW_FILTER_MATRIX,
    PURPLE_FILTER_MATRIX,
    ORANGE_FILTER_MATRIX,
    CYAN_FILTER_MATRIX,
    BROWN_FILTER_MATRIX,
    PINK_FILTER_MATRIX,
    TEAL_FILTER_MATRIX,
    INVERT_MATRIX,
  ];

  void convertWidgetToImage() async {
    RenderRepaintBoundary? repaintBoundary =
    _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

    if (repaintBoundary != null) {
      ui.Image boxImage = await repaintBoundary.toImage(pixelRatio: 1);
      ByteData? byteData = await boxImage.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        ByteData nonNullableByteData = byteData;

        Uint8List uint8list = nonNullableByteData.buffer.asUint8List();

        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SecondScreen(
            imageData: uint8list,
          ),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final Image image = Image.asset(
      "assets/poster/20.jpg",
      width: size.width,
      fit: BoxFit.cover,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Image Filters",
        ),
        actions: [IconButton(icon: const Icon(Icons.check), onPressed: convertWidgetToImage)],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: RepaintBoundary(
          key: _globalKey,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: size.width,
              maxHeight: size.width,
            ),
            child: PageView.builder(
                itemCount: filters.length,
                itemBuilder: (context, index) {
                  return ColorFiltered(
                    colorFilter: ColorFilter.matrix(filters[index]),
                    child: image,
                  );
                }),
          ),
        ),
      ),
    );
  }
}