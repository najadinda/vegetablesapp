import 'package:flutter/material.dart';
import 'package:vegetablesapp/edit_profile_page.dart';
import 'package:vegetablesapp/login_page.dart';
import 'package:vegetablesapp/models/app_state.dart';
import 'package:vegetablesapp/ui/colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void _logout(BuildContext context) {
    AppState().currentUser = null;
    Navigator.of(context, rootNavigator: true).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AppState().currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Profil Saya',
          style: TextStyle(
            color: primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        // Agar form bisa di-scroll jika layar kecil
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: secondary,
                backgroundImage:
                    (user?.profilePicture != null &&
                        user!.profilePicture.isNotEmpty)
                    ? AssetImage(user.profilePicture)
                    : null,
                child:
                    (user?.profilePicture == null ||
                        user!.profilePicture.isEmpty)
                    ? const Icon(
                        Icons.person,
                        size: 50,
                        color: primary,
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Informasi Akun',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primary,
              ),
            ),
            const SizedBox(height: 16),

            // Kolom Form Read-Only
            _buildReadOnlyField('Nama Lengkap', user?.name ?? 'Tidak ada data'),
            const SizedBox(height: 16),
            _buildReadOnlyField('Email', user?.email ?? 'Tidak ada data'),
            const SizedBox(height: 16),
            _buildReadOnlyField(
              'Password',
              '********',
            ), // Password disembunyikan pakai bintang

            const SizedBox(height: 32),

            // Tombol Edit Profil
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.edit, size: 18),
                label: const Text(
                  'Edit Profil',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProfilePage(),
                    ),
                  ).then((_) => setState(() {})); // Refresh setelah edit
                },
              ),
            ),

            const SizedBox(height: 12),

            // Tombol Logout
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.logout, size: 18),
                label: const Text(
                  'Keluar (Logout)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () => _logout(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget custom untuk membuat form TextField yang tidak bisa diedit
  Widget _buildReadOnlyField(String label, String value) {
    return TextField(
      controller: TextEditingController(text: value),
      readOnly: true, // Mengunci agar tidak bisa diketik
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor:
            Colors.grey.shade50, // Latar sedikit abu-abu menandakan terkunci
      ),
    );
  }
}
