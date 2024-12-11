import 'package:firebasetesting/screens/RandomBookListScreen.dart';
import 'package:firebasetesting/screens/novelscreen.dart';
import 'package:flutter/material.dart';
import 'book_list_screen.dart';
// import 'novel_list_screen.dart';
// import 'random_book_list_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  HomeScreen({required this.toggleTheme, required this.isDarkMode});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions() {
    return [
      manga(isDarkMode: widget.isDarkMode, toggleTheme: widget.toggleTheme),
      NovelScreen(isDarkMode: widget.isDarkMode, toggleTheme: widget.toggleTheme),
      RandomBookListScreen(isDarkMode: widget.isDarkMode, toggleTheme: widget.toggleTheme),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Toko Buku Online',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.blueAccent),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6, color: Colors.blueAccent),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      backgroundColor: widget.isDarkMode ? Colors.grey[850] : Colors.white,
      body: _widgetOptions().elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Manga',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Novel',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Buku Lain',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}