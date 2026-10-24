import 'package:flutter/material.dart';
import 'package:vegetablesapp/cart_page.dart';
import 'package:vegetablesapp/detail_page.dart';
import 'package:vegetablesapp/edit_profile_page.dart';
import 'package:vegetablesapp/models/app_state.dart';
import 'package:vegetablesapp/models/product.dart';
import 'package:vegetablesapp/models/transaction.dart';
import 'package:vegetablesapp/product_page.dart';
import 'package:vegetablesapp/ui/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Daftar produk pilihan terbaik untuk kamu
  final List<Product> _bestPicks = Product.sampleProducts.take(6).toList();

  void _addToCart(Product product) {
    final cart = AppState().cart;
    final index = cart.indexWhere((item) => item.product.title == product.title);

    setState(() {
      if (index >= 0) {
        cart[index].quantity += 1;
      } else {
        cart.add(CartItem(product: product, quantity: 1, isSelected: true));
      }
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Expanded(child: Text('${product.title} ditambahkan ke keranjang!')),
          ],
        ),
        backgroundColor: primary,
        duration: const Duration(milliseconds: 1400),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showAddressModal() {
    final user = AppState().currentUser;
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
                const Row(
                  children: [
                    Icon(Icons.location_on, color: primary),
                    SizedBox(width: 8),
                    Text(
                      'Alamat Pengantaran Sayur',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primary),
                    ),
                  ],
                ),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: backsur.withOpacity(0.4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: accent.withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person_pin, color: primary, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        user?.name ?? 'Nama Pengguna',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const Spacer(),
                      Text(
                        user?.phone ?? '0812-3456-7890',
                        style: const TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user?.address ?? 'Semarang, Jawa Tengah',
                    style: const TextStyle(fontSize: 13, height: 1.4, color: Colors.black87),
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Icon(Icons.access_time_outlined, size: 14, color: primary),
                      SizedBox(width: 4),
                      Text(
                        'Jadwal kirim panen: 06.00 - 09.00 WIB',
                        style: TextStyle(fontSize: 11, color: primary, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.edit, color: Colors.white, size: 18),
                label: const Text(
                  'Ubah Alamat di Profil',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EditProfilePage()),
                  ).then((_) => setState(() {}));
                },
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
    final userName = user?.name.split(' ').first ?? 'Sahabat Sayur';
    final userAddress = user?.address ?? 'Semarang, Jawa Tengah';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. TOP HEADER: SAPAAN HALO (NAMA) & KERANJANG
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: backsur,
                      backgroundImage: (user != null && user.profilePicture.isNotEmpty)
                          ? AssetImage(user.profilePicture)
                          : null,
                      child: (user == null || user.profilePicture.isEmpty)
                          ? const Icon(Icons.person, color: primary, size: 24)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Halo, $userName! 👋',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: primary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Pilihan sayur terbaik hari ini 🌿',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CartPage()),
                        ).then((_) => setState(() {}));
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: backsur.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: accent.withOpacity(0.4)),
                        ),
                        child: Badge(
                          label: Text(
                            AppState().cart.length.toString(),
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                          isLabelVisible: AppState().cart.isNotEmpty,
                          backgroundColor: Colors.red.shade600,
                          child: const Icon(Icons.shopping_basket_outlined, color: primary, size: 22),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. DIKIRIM KE ALAMAT DARI VALIDASI USER
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 14),
                child: InkWell(
                  onTap: _showAddressModal,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: backsur.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: accent.withOpacity(0.35)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: primary, size: 18),
                        const SizedBox(width: 8),
                        const Text(
                          'Dikirim ke: ',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primary),
                        ),
                        Expanded(
                          child: Text(
                            userAddress,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.keyboard_arrow_down, color: primary, size: 18),
                      ],
                    ),
                  ),
                ),
              ),

              // 3. HERO PROMO BANNER (Segar, Bersih, Tidak Bising)
              Container(
                margin: const EdgeInsets.fromLTRB(20, 6, 20, 18),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [primary, secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.22),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Panen Dini Hari • 100% Segar',
                              style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Sayur Segar Pilihan\nPetani Lokal Hari Ini',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Bebas pestisida, siap dimasak untuk keluarga.',
                            style: TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    const Text('🥬', style: TextStyle(fontSize: 44)),
                  ],
                ),
              ),

              // 4. PILIHAN TERBAIK UNTUK KAMU (DENGAN SCROLL SMOOTH KE SAMPING)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pilihan Terbaik Untuk Kamu ✨',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: primary,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Sayur segar dengan ulasan tertinggi',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ProductPage()),
                        );
                      },
                      child: const Row(
                        children: [
                          Text(
                            'Katalog',
                            style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          Icon(Icons.arrow_forward_ios, color: primary, size: 12),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // HORIZONTAL SMOOTH SCROLL CONTAINER
              SizedBox(
                height: 275,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _bestPicks.length,
                  itemBuilder: (context, index) {
                    final product = _bestPicks[index];
                    return _buildBestPickCard(product);
                  },
                ),
              ),

              const SizedBox(height: 24),

              // 5. BANNER KEUNGGULAN SAYUR SEGAR (Tidak Ramai, Bersih, Organik)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: backsur.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: accent.withOpacity(0.35)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildFeatureItem('🌱', '100% Organik', 'Tanpa pestisida'),
                      Container(height: 30, width: 1, color: Colors.grey.shade300),
                      _buildFeatureItem('🚚', 'Panen Subuh', 'Kirim 06-09 WIB'),
                      Container(height: 30, width: 1, color: Colors.grey.shade300),
                      _buildFeatureItem('✨', 'Garansi Segar', 'Ganti baru 100%'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 6. TOMBOL BUKA KATALOG LENGKAP
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ProductPage()),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.storefront_outlined, color: primary, size: 20),
                        SizedBox(width: 10),
                        Text(
                          'Lihat Semua Sayur di Halaman Katalog',
                          style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward, color: primary, size: 16),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBestPickCard(Product product) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailPage(product: product)),
          ).then((_) => setState(() {}));
        },
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar Sayur Asli (Network + Fallback)
              Stack(
                children: [
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: backsur.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: product.imageUrl.isNotEmpty
                          ? Image.network(
                              product.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) => Image.asset(
                                product.imagePath,
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => const Icon(Icons.eco, color: primary, size: 40),
                              ),
                            )
                          : Image.asset(
                              product.imagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) => const Icon(Icons.eco, color: primary, size: 40),
                            ),
                    ),
                  ),
                  // Badge Rating Bintang
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.92),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 11),
                          const SizedBox(width: 2),
                          Text(
                            product.rating.toString(),
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Badge Keunggulan (Paling Segar / Organik)
                  if (product.badgeText.isNotEmpty)
                    Positioned(
                      bottom: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: primary.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          product.badgeText,
                          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),

              // Judul Sayur
              Text(
                product.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),

              // Berat
              Text(
                product.weight,
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),

              const Spacer(),

              // Harga & Tombol Tambah ke Keranjang
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (product.oldPrice.isNotEmpty)
                        Text(
                          product.oldPrice,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      Text(
                        product.price,
                        style: const TextStyle(
                          color: primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => _addToCart(product),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String emoji, String title, String subtitle) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: primary)),
        const SizedBox(height: 1),
        Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}
