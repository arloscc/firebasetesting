import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NovelScreen extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  NovelScreen({required this.isDarkMode, required this.toggleTheme});

  final List<Map<String, String>> novels = [
    {'title': 'To Kill a Mockingbird', 'author': 'Harper Lee'},
    {'title': '1984', 'author': 'George Orwell'},
    {'title': 'The Great Gatsby', 'author': 'F. Scott Fitzgerald'},
    {'title': 'The Catcher in the Rye', 'author': 'J.D. Salinger'},
    {'title': 'Moby-Dick', 'author': 'Herman Melville'},
    {'title': 'Pride and Prejudice', 'author': 'Jane Austen'},
    {'title': 'War and Peace', 'author': 'Leo Tolstoy'},
    {'title': 'The Odyssey', 'author': 'Homer'},
    {'title': 'Crime and Punishment', 'author': 'Fyodor Dostoevsky'},
    {'title': 'The Brothers Karamazov', 'author': 'Fyodor Dostoevsky'},
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
          'Daftar Novel',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
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
        itemCount: novels.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListTile(
              leading: Icon(Icons.book, color: Colors.blueAccent),
              title: Text(
                novels[index]['title']!,
                style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                novels[index]['author']!,
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
                            addToCart(novels[index]);
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
        backgroundColor: Colors.white,
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