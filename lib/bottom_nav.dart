import 'package:flutter/material.dart';
import 'package:vegetablesapp/history_page.dart';
import 'package:vegetablesapp/product_page.dart';
import 'package:vegetablesapp/profile_page.dart';
import 'package:vegetablesapp/ui/colors.dart';
import 'package:vegetablesapp/home_page.dart';

class MainNavigation extends StatefulWidget {
  final int initialIndex;
  const MainNavigation({super.key, this.initialIndex = 0});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _currentIndex;

  final List<Widget> _pages = [
    const HomePage(),
    const ProductPage(),
    const HistoryPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    // Mendapatkan lebar layar untuk kalkulasi jarak geser animasi
    final screenWidth = MediaQuery.of(context).size.width;
    // Karena ada 4 menu, kita bagi layar menjadi 4 area yang sama besar
    final itemWidth = screenWidth / 4; 

    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_currentIndex != 0) {
          setState(() => _currentIndex = 0);
        }
      },
      child: Scaffold(
        body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Stack(
          children: [
            // 1. INDIKATOR BACKGROUND YANG BISA MELUNCUR (SLIDING)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic, // Gaya animasi memantul halus
              // Kalkulasi matematika agar indikator hijau pas di tengah ikon yang diklik
              left: (_currentIndex * itemWidth) + (itemWidth / 2) - 30, // 30 adalah setengah dari lebar kotak (60)
              top: 15,
              child: Container(
                width: 60,
                height: 50,
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            
            // 2. KUMPULAN IKON NAVIGASI DI ATAS INDIKATOR
            Row(
              children: [
                _buildNavItem(Icons.home_filled, 0, itemWidth),
                _buildNavItem(Icons.storefront_outlined, 1, itemWidth),
                _buildNavItem(Icons.history, 2, itemWidth),
                _buildNavItem(Icons.person_outline, 3, itemWidth),
              ],
            ),
          ],
        ),
      ),
    ));
  }

  // Fungsi pembuat tombol ikon
  Widget _buildNavItem(IconData icon, int index, double itemWidth) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: itemWidth,
        height: 80,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            // Efek tambahan: Ikon sedikit terangkat ke atas saat dipilih
            transform: Matrix4.translationValues(0, isSelected ? -3 : 0, 0),
            child: Icon(
              icon,
              color: isSelected ? primary : Colors.grey.shade400,
              size: isSelected ? 30 : 26,
            ),
          ),
        ),
      ),
    );
  }
}