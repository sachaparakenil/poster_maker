import 'package:flutter/material.dart';

import '../editor.dart';

class Tab2Screen extends StatelessWidget {
  final List<String> imagePaths = [
    'assets/poster/12.jpg',
    'assets/poster/13.jpg',
    'assets/poster/14.jpg',
    'assets/poster/15.jpg',
    'assets/poster/16.jpg',
    'assets/poster/17.jpg',
    'assets/poster/18.jpg',
    'assets/poster/19.jpg',
    'assets/poster/1.jpg',
    'assets/poster/2.jpg',
    'assets/poster/3.jpg',
    'assets/poster/4.jpg',
    'assets/poster/5.jpg',
    'assets/poster/6.jpg',
    'assets/poster/7.jpg',
    'assets/poster/8.jpg',
    'assets/poster/9.jpg',
    'assets/poster/10.jpg',
    'assets/poster/11.jpg',
    'assets/poster/20.jpg',
    'assets/poster/21.jpg',
  ];

  Tab2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: imagePaths.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageEditorExample(
                      data: imagePaths[index],
                    ),
                  ));
            },
            child: Image.asset(imagePaths[index]),
          ),
        );
      },
    );
  }
}
