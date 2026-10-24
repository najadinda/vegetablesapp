import 'package:flutter/material.dart';
import 'package:vegetablesapp/models/app_state.dart';
import 'package:vegetablesapp/ui/colors.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final user = AppState().currentUser;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      _nameController.text = user!.name;
      _emailController.text = user!.email;
      _phoneController.text = user!.phone;
      _addressController.text = user!.address;
      _passwordController.text = user!.password;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (user != null) {
      setState(() {
        user!.name = _nameController.text.trim();
        user!.email = _emailController.text.trim();
        user!.phone = _phoneController.text.trim();
        user!.address = _addressController.text.trim();
        user!.password = _passwordController.text;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 10),
              Text('Profil berhasil diperbarui!'),
            ],
          ),
          backgroundColor: primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: backsur,
                      backgroundImage: (user?.profilePicture != null && user!.profilePicture.isNotEmpty)
                          ? AssetImage(user!.profilePicture) 
                          : null,
                      child: (user?.profilePicture == null || user!.profilePicture.isEmpty)
                          ? const Icon(Icons.person, size: 50, color: primary) 
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
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
              const Text('Edit Informasi Akun & Pengiriman', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primary)),
              const SizedBox(height: 16),
              
              // Nama Lengkap
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  prefixIcon: const Icon(Icons.person_outline, color: primary),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined, color: primary),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Email tidak boleh kosong';
                  if (!val.contains('@')) return 'Format email tidak valid';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Nomor HP
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Nomor WhatsApp / HP',
                  prefixIcon: const Icon(Icons.phone_outlined, color: primary),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Nomor HP tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),

              // Alamat Pengiriman
              TextFormField(
                controller: _addressController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Alamat Pengantaran Sayur',
                  prefixIcon: const Icon(Icons.location_on_outlined, color: primary),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Alamat pengantaran tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),

              // Password
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline, color: primary),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (val) => (val == null || val.isEmpty) ? 'Password tidak boleh kosong' : null,
              ),
              const SizedBox(height: 32),
              
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary, 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _saveProfile,
                  child: const Text('Simpan Perubahan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}