import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebasetesting/services/auth_service.dart';

class manga extends StatelessWidget {
  final AuthService _authService = AuthService();
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  manga({required this.isDarkMode, required this.toggleTheme});

  final List<Map<String, String>> books = [
    {'title': 'Naruto', 'author': 'Masashi Kishimoto'},
    {'title': 'One Piece', 'author': 'Eiichiro Oda'},
    {'title': 'Attack on Titan', 'author': 'Hajime Isayama'},
    {'title': 'My Hero Academia', 'author': 'Kohei Horikoshi'},
    {'title': 'Demon Slayer', 'author': 'Koyoharu Gotouge'},
    {'title': 'Dragon Ball', 'author': 'Akira Toriyama'},
    {'title': 'Death Note', 'author': 'Tsugumi Ohba'},
    {'title': 'Fullmetal Alchemist', 'author': 'Hiromu Arakawa'},
    {'title': 'Bleach', 'author': 'Tite Kubo'},
    {'title': 'Fairy Tail', 'author': 'Hiro Mashima'},
  ];

  final CollectionReference cart = FirebaseFirestore.instance.collection('cart');

  Future<void> addToCart(Map<String, String> book) {
    return cart.add(book);
  }

  Future<void> removeFromCart(String id) {
    return cart.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daftar Buku Manga',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.blueAccent),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6, color: Colors.blueAccent),
            onPressed: toggleTheme,
          ),
        ],
      ),
      backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListTile(
              leading: Icon(Icons.book, color: Colors.blueAccent),
              title: Text(
                books[index]['title']!,
                style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                books[index]['author']!,
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Tambahkan ke Keranjang'),
                      content: Text('Apakah Anda ingin menambahkan buku ini ke keranjang?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            addToCart(books[index]);
                            Navigator.of(context).pop();
                          },
                          child: Text('Ya'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Tidak'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartScreen(removeFromCart: removeFromCart, isDarkMode: isDarkMode, toggleTheme: toggleTheme)),
          );
        },
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  final Future<void> Function(String id) removeFromCart;
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  CartScreen({required this.removeFromCart, required this.isDarkMode, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Keranjang',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.blueAccent),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6, color: Colors.blueAccent),
            onPressed: toggleTheme,
          ),
        ],
      ),
      backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('cart').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final cartItems = snapshot.data!.docs;

          return ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListTile(
                  leading: Icon(Icons.book, color: Colors.blueAccent),
                  title: Text(
                    item['title'],
                    style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    item['author'],
                    style: TextStyle(fontFamily: 'Poppins'),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () {
                      removeFromCart(item.id);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}