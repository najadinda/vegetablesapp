import 'package:flutter/material.dart';
import 'package:vegetablesapp/models/app_state.dart';
import 'package:vegetablesapp/ui/colors.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final user = AppState().currentUser;

  @override
  void initState() {
    super.initState();
    // Tarik data saat ini untuk mengisi form
    if (user != null) {
      _nameController.text = user!.name;
      _emailController.text = user!.email;
      _passwordController.text = user!.password;
    }
  }

  void _saveProfile() {
    if (user != null) {
      setState(() {
        user!.name = _nameController.text;
        user!.email = _emailController.text;
        user!.password = _passwordController.text;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Edit Profil', style: TextStyle(color: primary, fontWeight: FontWeight.bold)),
        leading: const BackButton(color: primary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Menyusun elemen merata kiri
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: secondary,
                    backgroundImage: (user?.profilePicture != null && user!.profilePicture.isNotEmpty)
                        ? AssetImage(user!.profilePicture) 
                        : null,
                    child: (user?.profilePicture == null || user!.profilePicture.isEmpty)
                        ? const Icon(Icons.person, size: 50, color: primary) 
                        : null,
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: primary, shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text('Edit Informasi Akun', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primary)),
            const SizedBox(height: 16),
            
            // Kolom Form Aktif (Bisa Diketik)
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nama Lengkap', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true, // Sembunyikan ketikan password
              decoration: InputDecoration(labelText: 'Password Baru', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
            ),
            
            const SizedBox(height: 32),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary, 
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _saveProfile,
                child: const Text('Simpan Perubahan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}