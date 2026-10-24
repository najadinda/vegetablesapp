import 'package:flutter/material.dart';
import 'package:vegetablesapp/bottom_nav.dart';
import 'package:vegetablesapp/models/app_state.dart';
import 'package:vegetablesapp/ui/colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController(text: 'Semarang, Jawa Tengah');
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeTerms = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda perlu menyetujui syarat & ketentuan belanja sayur segar.'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final emailInput = _emailController.text.trim();

    // Cek apakah email sudah pernah terdaftar
    final emailExists = AppState().registeredUsers.any(
      (u) => u.email.toLowerCase() == emailInput.toLowerCase(),
    );

    if (emailExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 10),
              Expanded(child: Text('Email ini sudah terdaftar. Silakan login atau gunakan email lain.')),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      // Buat instance UserModel baru
      final newUser = UserModel(
        name: _nameController.text.trim(),
        email: emailInput,
        password: _passwordController.text,
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        membershipTier: 'Sahabat Sayur Baru 🌱',
        points: 100, // Bonus registrasi awal
        joinDate: 'Oktober 2026',
        morningHarvestNotif: true,
        ecoPackaging: true,
      );

      // Simpan ke database lokal / AppState
      AppState().registeredUsers.add(newUser);
      AppState().currentUser = newUser;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.celebration, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text('Pendaftaran berhasil! Selamat datang, ${newUser.name}! (+100 Poin Sayur 🎉)'),
              ),
            ],
          ),
          backgroundColor: primary,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );

      // Langsung arahkan ke MainNavigation
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigation()),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daftar Akun Baru',
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Bergabung dengan komunitas Sayur Segar',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Form Putih
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Informasi Diri',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primary),
                        ),
                        const SizedBox(height: 18),

                        // Nama Lengkap
                        _buildTextFormField(
                          controller: _nameController,
                          label: 'Nama Lengkap',
                          hint: 'Contoh: Ayudhya Naja',
                          icon: Icons.person_outline,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return 'Nama tidak boleh kosong';
                            if (val.trim().length < 3) return 'Nama minimal 3 karakter';
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        // Email
                        _buildTextFormField(
                          controller: _emailController,
                          label: 'Alamat Email',
                          hint: 'nama@gmail.com',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return 'Email tidak boleh kosong';
                            if (!val.contains('@') || !val.contains('.')) return 'Format email tidak valid';
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        // Nomor Telepon / WA
                        _buildTextFormField(
                          controller: _phoneController,
                          label: 'Nomor WhatsApp / HP',
                          hint: 'Contoh: 081234567890',
                          icon: Icons.phone_android_outlined,
                          keyboardType: TextInputType.phone,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return 'Nomor HP diperlukan untuk kurir sayur';
                            if (val.trim().length < 9) return 'Nomor HP minimal 9 digit';
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        // Alamat Pengiriman Sayur
                        _buildTextFormField(
                          controller: _addressController,
                          label: 'Alamat Pengiriman Sayur',
                          hint: 'Nama jalan, nomor rumah, kota',
                          icon: Icons.location_on_outlined,
                          maxLines: 2,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return 'Alamat pengiriman harus diisi';
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        // Kata Sandi
                        _buildTextFormField(
                          controller: _passwordController,
                          label: 'Kata Sandi',
                          hint: 'Minimal 3 karakter',
                          icon: Icons.lock_outline,
                          obscureText: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: Colors.grey,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) return 'Kata sandi tidak boleh kosong';
                            if (val.length < 3) return 'Kata sandi minimal 3 karakter';
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        // Konfirmasi Kata Sandi
                        _buildTextFormField(
                          controller: _confirmPasswordController,
                          label: 'Konfirmasi Kata Sandi',
                          hint: 'Ketik ulang kata sandi',
                          icon: Icons.lock_reset,
                          obscureText: _obscureConfirmPassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: Colors.grey,
                            ),
                            onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) return 'Konfirmasi kata sandi tidak boleh kosong';
                            if (val != _passwordController.text) return 'Kata sandi tidak cocok';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Checkbox Syarat & Ketentuan
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: _agreeTerms,
                              activeColor: primary,
                              onChanged: (val) => setState(() => _agreeTerms = val ?? false),
                            ),
                            const Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(top: 12),
                                child: Text(
                                  'Saya menyetujui Ketentuan Layanan Belanja Sayur Segar & Kebijakan Privasi.',
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Tombol Daftar
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primary,
                              elevation: 2,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            onPressed: _isLoading ? null : _handleRegister,
                            child: _isLoading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  )
                                : const Text(
                                    'Daftar & Mulai Belanja',
                                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Kembali ke Login
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Sudah punya akun? ', style: TextStyle(color: Colors.grey)),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: const Text(
                                  'Masuk di sini',
                                  style: TextStyle(color: primary, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
        prefixIcon: Icon(icon, color: primary),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
      ),
      validator: validator,
    );
  }
}