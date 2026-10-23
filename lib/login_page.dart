import 'package:flutter/material.dart';
import 'package:vegetablesapp/bottom_nav.dart';
import 'package:vegetablesapp/models/app_state.dart';
import 'package:vegetablesapp/register_page.dart';
import 'package:vegetablesapp/ui/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    final user = AppState().registeredUsers.where((u) => 
      u.email == _emailController.text && u.password == _passwordController.text
    ).firstOrNull;

    if (user != null) {
      AppState().currentUser = user;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainNavigation()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email atau Password salah!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             Text('Selamat Datang!', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: primary)),
             SizedBox(height: 8),
             Text('Silakan login untuk mulai berbelanja.', style: TextStyle(color: Colors.grey)),
             SizedBox(height: 40),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              ),
             SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              ),
             SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: primary, padding: EdgeInsets.symmetric(vertical: 16)),
                  onPressed: _login,
                  child: Text('Login', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage())),
                  child: Text('Belum punya akun? Daftar sekarang', style: TextStyle(color: primary)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}