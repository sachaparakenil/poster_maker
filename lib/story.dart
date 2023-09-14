import 'package:flutter/material.dart';
import 'overlayedWidget.dart';

class Story extends StatefulWidget {
  const Story({super.key});

  @override
  State<Story> createState() => _StoryState();
}

class _StoryState extends State<Story> {
  List<Widget> addedWidgets = [];
  bool _showDeleteButton = false;
  bool _isDeleteButtonActive = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Story',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (addedWidgets.length < _dummyWidgets.length) {
            setState(() {
              addedWidgets.add(OverlayedWidget(
                key: Key(addedWidgets.length.toString()),
                  onDragStart: () {
                    setState(() {
                      _showDeleteButton = true;
                    });
                  },
                  onDragEnd: (offset, key) {
                    if (_showDeleteButton) {
                      setState(() {
                        _showDeleteButton = false;
                      });
                    }
                    if (offset.dy >
                        (MediaQuery.of(context).size.height - 100)) {
                      addedWidgets.removeWhere((widget) => widget.key == key);
                    }
                  },
                  onDragUpdate: (offset, key) {
                    if (offset.dy >
                        (MediaQuery.of(context).size.height - 100)) {
                      if (!_isDeleteButtonActive) {
                        setState(() {
                          _isDeleteButtonActive = true;
                        });
                      }
                    } else {
                      if (_isDeleteButtonActive) {
                        setState(() {
                          _isDeleteButtonActive = false;
                        });
                      }
                    }
                  },
                  child: _dummyWidgets.elementAt(addedWidgets.length)));
            });
          }
        },
        child: const Icon(Icons.add),
      ),
      body: Stack(alignment: Alignment.center, children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.asset(
            'assets/ganesh.jpg',
            fit: BoxFit.contain,
          ),
        ),
        for (int i = 0; i < addedWidgets.length; i++) addedWidgets[i],
        if (_showDeleteButton)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(60.0),
              child: Icon(
                Icons.delete,
                size: _isDeleteButtonActive ? 38 : 28,
                color: _isDeleteButtonActive ? Colors.grey : Colors.black,
              ),
            ),
          ),
      ]),
    );
  }
}

final List<Widget> _dummyWidgets = [
  const Text(
    'RB Infotech',
    style: TextStyle(fontSize: 40),
  ),
  ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      child: const Text(
        'Happy Ganesh Chaturthy',
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
      ),
    ),
  ),
  const Icon(
    Icons.music_note,
    color: Colors.red,
    size: 100,
  ),
  Image.asset(
    'assets/speaker.png',
    width: 250,
    height: 250,
  ),
];
