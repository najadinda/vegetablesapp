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
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _passwordController;

  bool _obscurePassword = true;
  final user = AppState().currentUser;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _addressController = TextEditingController(text: user?.address ?? '');
    _passwordController = TextEditingController(text: user?.password ?? '');
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
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text('Profil & alamat pengantaran berhasil diperbarui! 🌿'),
              ),
            ],
          ),
          backgroundColor: primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      Navigator.pop(context);
    }
  }

  void _showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Foto Profil Pengguna',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primary),
                ),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Pilih opsi untuk memperbarui foto avatar belanja Anda:',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: backsur.withOpacity(0.5), shape: BoxShape.circle),
                child: const Icon(Icons.photo_library_outlined, color: primary),
              ),
              title: const Text('Pilih dari Galeri', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              subtitle: const Text('Gunakan foto dari penyimpanan ponsel', style: TextStyle(fontSize: 12, color: Colors.grey)),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Foto profil berhasil dipilih dari galeri!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: backsur.withOpacity(0.5), shape: BoxShape.circle),
                child: const Icon(Icons.camera_alt_outlined, color: primary),
              ),
              title: const Text('Ambil Foto Baru', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              subtitle: const Text('Gunakan kamera langsung', style: TextStyle(fontSize: 12, color: Colors.grey)),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Kamera siap untuk foto avatar!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final membership = user?.membershipTier ?? 'Sahabat Sayur Emas 🌿';
    final joinDate = user?.joinDate ?? 'Januari 2024';

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: primary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Profil Akun',
          style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text(
              'Simpan',
              style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. HEADER AVATAR & STATUS MEMBERSHIP (Rapi, Bersih, Thematic)
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: accent.withOpacity(0.5), width: 3),
                          ),
                          child: CircleAvatar(
                            radius: 46,
                            backgroundColor: backsur,
                            backgroundImage: (user?.profilePicture != null && user!.profilePicture.isNotEmpty)
                                ? AssetImage(user!.profilePicture)
                                : null,
                            child: (user?.profilePicture == null || user!.profilePicture.isEmpty)
                                ? const Icon(Icons.person, size: 48, color: primary)
                                : null,
                          ),
                        ),
                        Positioned(
                          bottom: 2,
                          right: 2,
                          child: InkWell(
                            onTap: _showAvatarPicker,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: primary,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Badge Membership Sayur
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                      decoration: BoxDecoration(
                        color: backsur.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: accent.withOpacity(0.4)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.eco, color: primary, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            membership,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: primary),
                          ),
                          const SizedBox(width: 4),
                          const Text('•', style: TextStyle(color: Colors.grey)),
                          const SizedBox(width: 4),
                          Text(
                            'Sejak $joinDate',
                            style: const TextStyle(fontSize: 11, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Ketuk ikon kamera untuk mengubah foto avatar',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 2. KARTU SEKSI 1: DATA PRIBADI & AKUN
              _buildSectionTitle('Informasi Pribadi & Kontak', Icons.person_outline),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Nama Lengkap
                    _buildInputField(
                      controller: _nameController,
                      label: 'Nama Lengkap',
                      hint: 'Masukkan nama lengkap Anda',
                      icon: Icons.badge_outlined,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'Nama tidak boleh kosong';
                        if (val.trim().length < 3) return 'Nama minimal 3 karakter';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // Email Terdaftar
                    _buildInputField(
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

                    // Nomor WhatsApp / HP
                    _buildInputField(
                      controller: _phoneController,
                      label: 'Nomor WhatsApp / HP',
                      hint: '081234567890',
                      icon: Icons.phone_android_outlined,
                      keyboardType: TextInputType.phone,
                      helperText: 'Kurir panen akan menghubungi nomor ini saat pengantaran sayur',
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'Nomor HP tidak boleh kosong';
                        if (val.trim().length < 9) return 'Nomor HP minimal 9 digit';
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 3. KARTU SEKSI 2: LOGISTIK PENGANTARAN SAYUR SEGAR (Spesifik Vegetables App)
              _buildSectionTitle('Alamat Pengantaran Sayur', Icons.local_shipping_outlined),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputField(
                      controller: _addressController,
                      label: 'Alamat Lengkap Rumah / Kantor',
                      hint: 'Nama jalan, nomor rumah, RT/RW, kelurahan, kecamatan',
                      icon: Icons.location_on_outlined,
                      maxLines: 3,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) return 'Alamat pengantaran sayur harus diisi';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    // Banner Jadwal Panen Pagi
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: backsur.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: accent.withOpacity(0.4)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.access_time_filled, color: primary, size: 18),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Pengantaran sayur segar dilakukan pukul 06.00 - 09.00 WIB langsung setelah panen subuh.',
                              style: TextStyle(fontSize: 11, color: primary, fontWeight: FontWeight.w600, height: 1.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 4. KARTU SEKSI 3: KEAMANAN & KATA SANDI
              _buildSectionTitle('Keamanan Akun', Icons.lock_outline),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: _buildInputField(
                  controller: _passwordController,
                  label: 'Kata Sandi Akun',
                  hint: 'Masukkan kata sandi baru',
                  icon: Icons.key_outlined,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Kata sandi tidak boleh kosong';
                    if (val.length < 3) return 'Kata sandi minimal 3 karakter';
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 28),

              // 5. TOMBOL SIMPAN UTAMA
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  icon: const Icon(Icons.check, color: Colors.white, size: 20),
                  label: const Text(
                    'Simpan Perubahan Profil',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  onPressed: _saveProfile,
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: primary),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: primary),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? helperText,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.grey.shade700, fontSize: 13),
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            prefixIcon: Icon(icon, color: primary, size: 20),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.red.shade300),
            ),
          ),
          validator: validator,
        ),
        if (helperText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 6),
            child: Text(
              helperText,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
          ),
      ],
    );
  }
}