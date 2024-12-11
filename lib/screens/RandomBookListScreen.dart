import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RandomBookListScreen extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  RandomBookListScreen({super.key, required this.isDarkMode, required this.toggleTheme});

  final List<Map<String, String>> randomBooks = [
    {'title': 'Sapiens', 'author': 'Yuval Noah Harari'},
    {'title': 'Educated', 'author': 'Tara Westover'},
    {'title': 'Becoming', 'author': 'Michelle Obama'},
    {'title': 'The Power of Habit', 'author': 'Charles Duhigg'},
    {'title': 'Thinking, Fast and Slow', 'author': 'Daniel Kahneman'},
    {'title': 'The Subtle Art of Not Giving a F*ck', 'author': 'Mark Manson'},
    {'title': 'Atomic Habits', 'author': 'James Clear'},
    {'title': 'The Alchemist', 'author': 'Paulo Coelho'},
    {'title': 'The Four Agreements', 'author': 'Don Miguel Ruiz'},
    {'title': 'The 7 Habits of Highly Effective People', 'author': 'Stephen R. Covey'},
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
        title: const Text(
          'Daftar Buku Random',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.blueAccent),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6, color: Colors.blueAccent),
            onPressed: toggleTheme,
          ),
        ],
      ),
      backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
      body: ListView.builder(
        itemCount: randomBooks.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListTile(
              leading: const Icon(Icons.book, color: Colors.blueAccent),
              title: Text(
                randomBooks[index]['title']!,
                style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                randomBooks[index]['author']!,
                style: const TextStyle(fontFamily: 'Poppins'),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Tambahkan ke Keranjang'),
                      content: const Text('Apakah Anda ingin menambahkan buku ini ke keranjang?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            addToCart(randomBooks[index]);
                            Navigator.of(context).pop();
                          },
                          child: const Text('Ya'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Tidak'),
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
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  final Future<void> Function(String id) removeFromCart;
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const CartScreen({super.key, required this.removeFromCart, required this.isDarkMode, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Keranjang',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.blueAccent),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6, color: Colors.blueAccent),
            onPressed: toggleTheme,
          ),
        ],
      ),
      backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('cart').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final cartItems = snapshot.data!.docs;

          return ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListTile(
                  leading: const Icon(Icons.book, color: Colors.blueAccent),
                  title: Text(
                    item['title'],
                    style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    item['author'],
                    style: const TextStyle(fontFamily: 'Poppins'),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
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