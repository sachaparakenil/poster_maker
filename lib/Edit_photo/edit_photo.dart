import 'package:flutter/material.dart';
import 'package:poster_maker/Edit_photo/photo_editor/Removebg/background_remover.dart';
import 'package:poster_maker/Edit_photo/photo_editor/resize_image.dart';

class EditPhoto extends StatelessWidget {
  const EditPhoto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Photos'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Button(
                    color: Colors.blue,
                    label: "Remove\nBackground",
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RemoveBg(),
                          ));
                    }),
                const SizedBox(width: 20),
                Button(
                    color: Colors.green,
                    label: "Resize\nImage",
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ResizePhoto(),
                          ));
                    }),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Button(
                    color: Colors.red,
                    label: "Filter\nImage",
                    onPressed: () {}),
                const SizedBox(width: 20),
                Button(
                    color: Colors.orange,
                    label: "Rotate\nImage",
                    onPressed: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  final Color color;
  final String label;
  final VoidCallback onPressed;

  const Button({
    super.key,
    required this.color,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
              child: TextButton(
                  onPressed: () {
                    onPressed();
                  },
                  child: Text(label, style: const TextStyle(color: Colors.black),))),
        ),
      ],
    );
  }
}
