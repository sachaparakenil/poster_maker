import 'package:flutter/material.dart';
import 'package:poster_maker/Create_Poster/select_poster.dart';
import 'Edit_photo/edit_photo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Poster Maker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SquareButton(
                  color: Colors.blue,
                  icon: Icons.home,
                  label: 'Create Poster',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SelectPoster(),
                        ));
                  },
                ),
                const SizedBox(width: 20),
                SquareButton(
                  color: Colors.green,
                  icon: Icons.edit_location_outlined,
                  label: 'Edit Photo',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditPhoto(),
                        ));
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SquareButton(
                  color: Colors.red,
                  icon: Icons.ios_share,
                  label: 'Share Poster',
                  onPressed: () {},
                ),
                const SizedBox(width: 20),
                SquareButton(
                  color: Colors.orange,
                  icon: Icons.mode_edit_outline_outlined,
                  label: 'Edit Poster',
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SquareButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const SquareButton({super.key,
    required this.color,
    required this.icon,
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
          child: IconButton(
            icon: Icon(
              icon,
              color: Colors.white,
              size: 40,
            ),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
