import 'package:flutter/material.dart';
import 'package:firebasetesting/services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  final AuthService _authService = AuthService();
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  LoginScreen({required this.toggleTheme, required this.isDarkMode});

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
            onPressed: toggleTheme,
          ),
        ],
      ),
      backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final user = await _authService.signInWithGoogle();
            if (user != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen(toggleTheme: toggleTheme, isDarkMode: isDarkMode)),
              );
            } else {
              // Tampilkan pesan error jika login gagal
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Login gagal. Silakan coba lagi.')),
              );
            }
          },
          child: Text(
            'Login with Google',
            style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins', color: Colors.blueAccent),
          ),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 26, vertical: 8),
          ),
        ),
      ),
    );
  }
}