import 'package:flutter/material.dart';
import 'package:poster_maker/Create_Poster/poster_tab/color.dart';
import 'package:poster_maker/Create_Poster/poster_tab/image.dart';
import 'package:poster_maker/Create_Poster/poster_tab/template.dart';
import 'package:poster_maker/Create_Poster/poster_tab/background.dart';
import 'package:poster_maker/Create_Poster/poster_tab/texture.dart';

class SelectPoster extends StatelessWidget {
  const SelectPoster({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(
              kToolbarHeight + 48), // Adjust the height as needed
          child: AppBar(
            title: const Text('Select Poster Background'),
            bottom: const TabBar(
              isScrollable: true, // Make the tab bar scrollable
              tabs: [
                Tab(text: 'Template'),
                Tab(text: 'Background'),
                Tab(text: 'Texture'),
                Tab(text: 'Image'),
                Tab(text: 'Color'),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Tab1Screen(),
            Tab2Screen(),
            Tab3Screen(),
            const Tab4Screen(),
            Tab5Screen(),
          ],
        ),
      ),
    );
  }
}
