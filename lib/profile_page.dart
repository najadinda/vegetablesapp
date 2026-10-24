import 'package:flutter/material.dart';
import 'package:vegetablesapp/cart_page.dart';
import 'package:vegetablesapp/edit_profile_page.dart';
import 'package:vegetablesapp/history_page.dart';
import 'package:vegetablesapp/login_page.dart';
import 'package:vegetablesapp/models/app_state.dart';
import 'package:vegetablesapp/ui/colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void _handleLogout() {
    final user = AppState().currentUser;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.logout, color: Colors.redAccent),
            SizedBox(width: 10),
            Text('Keluar Akun?', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          'Keranjang belanja (${AppState().cart.length} item) dan ${user?.points ?? 0} SayurPoin Anda tetap tersimpan aman.',
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
        actionsPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Batal',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              AppState().currentUser = null;
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Anda telah keluar dari akun.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text(
              'Ya, Keluar',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showVoucherModal() {
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
                  'Voucher Sayur Anda',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildVoucherTile(
              'PANENPAGI',
              'Gratis Ongkir Panen Pagi',
              'Berlaku s/d 31 Des 2026',
              Icons.local_shipping,
            ),
            _buildVoucherTile(
              'SAYURSEGAR15',
              'Diskon 15% Sayur Organik',
              'Min. belanja Rp 50.000',
              Icons.eco,
            ),
            _buildVoucherTile(
              'NEWSAHABAT',
              'Cashback Rp 10.000 Sayur Daun',
              'Khusus member terdaftar',
              Icons.stars,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoucherTile(
    String code,
    String title,
    String subtitle,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backsur.withOpacity(0.4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              code,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPointsModal(UserModel user) {
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
            const Row(
              children: [
                Icon(Icons.stars_rounded, color: Colors.amber, size: 28),
                SizedBox(width: 8),
                Text(
                  'SayurPoin Reward',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Saldo Anda saat ini: ${user.points} Poin',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'Kumpulkan poin dari setiap belanja sayur segar untuk ditukar produk organik gratis!',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                backgroundColor: backsur,
                child: Icon(Icons.eco, color: primary),
              ),
              title: const Text('100 Poin = 1 Ikat Bayam Organik'),
              subtitle: const Text('Bisa diklaim langsung di keranjang'),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Voucher bayam berhasil diklaim ke akun Anda!',
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: const Text(
                  'Klaim',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AppState().currentUser;

    if (user == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: backsur,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_off_outlined,
                      color: primary,
                      size: 64,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Belum Masuk Akun',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Silakan masuk atau daftar akun untuk melihat profil belanja sayur, voucher, dan alamat pengantaran.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Masuk Sekarang',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Profil Sayur Saya',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note, color: Colors.white, size: 28),
            tooltip: 'Edit Profil',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfilePage(),
                ),
              ).then((_) => setState(() {}));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. HEADER PROFIL SAYUR MODERN
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
              decoration: const BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.8),
                            width: 3,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 46,
                          backgroundColor: backsur,
                          backgroundImage: (user.profilePicture.isNotEmpty)
                              ? AssetImage(user.profilePicture)
                              : null,
                          child: (user.profilePicture.isEmpty)
                              ? const Icon(
                                  Icons.person,
                                  size: 46,
                                  color: primary,
                                )
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.eco,
                            color: primary,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.verified,
                        color: Colors.amberAccent,
                        size: 18,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  // Badge Membership Sayur
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.local_florist,
                          color: Colors.amberAccent,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          user.membershipTier,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          '•',
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Sejak ${user.joinDate}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 2. FLOATING ACTIVITY SUMMARY CARD (Khas E-Commerce Sayur)
            Transform.translate(
              offset: const Offset(0, -22),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildQuickStat(
                        icon: Icons.receipt_long,
                        color: Colors.blue.shade600,
                        label: 'Pesanan',
                        value: '${AppState().history.length}',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HistoryPage(),
                            ),
                          );
                        },
                      ),
                      _buildDivider(),
                      _buildQuickStat(
                        icon: Icons.stars_rounded,
                        color: Colors.amber.shade700,
                        label: 'SayurPoin',
                        value: '${user.points}',
                        onTap: () => _showPointsModal(user),
                      ),
                      _buildDivider(),
                      _buildQuickStat(
                        icon: Icons.confirmation_number_outlined,
                        color: Colors.green.shade600,
                        label: 'Voucher',
                        value: '3 Promo',
                        onTap: _showVoucherModal,
                      ),
                      _buildDivider(),
                      _buildQuickStat(
                        icon: Icons.shopping_basket_outlined,
                        color: primary,
                        label: 'Keranjang',
                        value: '${AppState().cart.length}',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CartPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 3. SAYUR CLUB LOYALTY CARD
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [backsur.withOpacity(0.8), Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: accent.withOpacity(0.4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.energy_savings_leaf,
                                  color: primary,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Level Sahabat Sayur',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: primary,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'Gold Member',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: (user.points / 500).clamp(0.1, 1.0),
                            backgroundColor: Colors.white,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              primary,
                            ),
                            minHeight: 8,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${user.points} / 500 Poin',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: primary,
                              ),
                            ),
                            const Text(
                              'Gratis Ongkir Panen Pagi Aktif ✨',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 4. SECTION: LOGISTIK & ALAMAT SAYUR
                  _buildSectionHeader('Pengiriman & Alamat Sayur Segar'),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFFF1F6F0),
                            child: Icon(Icons.location_on, color: primary),
                          ),
                          title: const Text(
                            'Alamat Rumah / Pengantaran',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Text(
                            user.address,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EditProfilePage(),
                              ),
                            ).then((_) => setState(() {}));
                          },
                        ),
                        const Divider(height: 1, indent: 64),
                        ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFFF1F6F0),
                            child: Icon(Icons.phone_android, color: primary),
                          ),
                          title: const Text(
                            'Nomor Telepon Kurir',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Text(
                            user.phone,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EditProfilePage(),
                              ),
                            ).then((_) => setState(() {}));
                          },
                        ),
                        const Divider(height: 1, indent: 64),
                        const ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Color(0xFFF1F6F0),
                            child: Icon(
                              Icons.access_time_filled,
                              color: primary,
                            ),
                          ),
                          title: Text(
                            'Jadwal Panen & Kirim',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Text(
                            'Panen Subuh: Pengantaran 06.00 - 09.00 WIB',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 5. SECTION: PREFERENSI SAYUR & PANEN
                  _buildSectionHeader('Preferensi Belanja & Sayur Hijau'),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        SwitchListTile(
                          secondary: const CircleAvatar(
                            backgroundColor: Color(0xFFF1F6F0),
                            child: Icon(
                              Icons.notifications_active_outlined,
                              color: primary,
                            ),
                          ),
                          title: const Text(
                            'Notifikasi Panen Pagi (06:00)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: const Text(
                            'Info sayur segar yang baru dipetik hari ini',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          activeColor: primary,
                          value: user.morningHarvestNotif,
                          onChanged: (val) {
                            setState(() => user.morningHarvestNotif = val);
                          },
                        ),
                        const Divider(height: 1, indent: 64),
                        SwitchListTile(
                          secondary: const CircleAvatar(
                            backgroundColor: Color(0xFFF1F6F0),
                            child: Icon(
                              Icons.recycling_outlined,
                              color: primary,
                            ),
                          ),
                          title: const Text(
                            'Kemasan Zero-Waste (Dedaunan)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: const Text(
                            'Gunakan besek bambu & daun pisang ramah lingkungan',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          activeColor: primary,
                          value: user.ecoPackaging,
                          onChanged: (val) {
                            setState(() => user.ecoPackaging = val);
                          },
                        ),
                        const Divider(height: 1, indent: 64),
                        ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFFF1F6F0),
                            child: Icon(
                              Icons.all_inbox_outlined,
                              color: primary,
                            ),
                          ),
                          title: const Text(
                            'Langganan Kotak Sayur Mingguan',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: const Text(
                            'Paket sayur organik 3x seminggu langsung dari petani',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          trailing: const Chip(
                            label: Text(
                              'Aktif',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: secondary,
                            padding: EdgeInsets.zero,
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Paket Sayur Mingguan Anda aktif untuk jadwal kirim Selasa & Jumat!',
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 7. TOMBOL LOGOUT ELEGAN
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red.shade700,
                        side: BorderSide(color: Colors.red.shade200),
                        backgroundColor: Colors.red.shade50.withOpacity(0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Icons.logout, size: 20),
                      label: const Text(
                        'Keluar Akun (Logout)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      onPressed: _handleLogout,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: primary,
        ),
      ),
    );
  }

  Widget _buildQuickStat({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 32, width: 1, color: Colors.grey.shade200);
  }
}