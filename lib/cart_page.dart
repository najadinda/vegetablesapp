import 'package:flutter/material.dart';
import 'package:vegetablesapp/checkout_page.dart';
import 'package:vegetablesapp/models/app_state.dart';
import 'package:vegetablesapp/models/transaction.dart';
import 'package:vegetablesapp/ui/colors.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool get _isAllSelected =>
      AppState().cart.isNotEmpty &&
      AppState().cart.every((item) => item.isSelected);

  void _toggleSelectAll(bool? value) {
    setState(() {
      for (var item in AppState().cart) {
        item.isSelected = value ?? false;
      }
    });
  }

  int _parsePrice(String priceStr) {
    final clean = priceStr.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(clean) ?? 0;
  }

  int _calculateSelectedTotal() {
    int total = 0;
    for (var item in AppState().cart) {
      if (item.isSelected) {
        total += _parsePrice(item.product.price) * item.quantity;
      }
    }
    return total;
  }

  String _formatCurrency(int amount) {
    return 'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  void _increaseQuantity(CartItem item) {
    setState(() {
      item.quantity += 1;
    });
  }

  void _decreaseQuantity(CartItem item, int index) {
    if (item.quantity > 1) {
      setState(() {
        item.quantity -= 1;
      });
    } else {
      _confirmDeleteItem(index, item.product.title);
    }
  }

  void _confirmDeleteItem(int index, String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Sayur?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Text('Keluarkan "$title" dari keranjang belanja Anda?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                AppState().cart.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$title dihapus dari keranjang'),
                  duration: const Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _confirmClearCart() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Kosongkan Keranjang?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: const Text('Semua sayuran di keranjang akan dihapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                AppState().cart.clear();
              });
            },
            child: const Text('Kosongkan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = AppState().cart;
    final selectedItems = cart.where((i) => i.isSelected).toList();
    final selectedCount = selectedItems.fold(0, (sum, i) => sum + i.quantity);
    final userAddress = AppState().currentUser?.address ?? 'Semarang, Jawa Tengah';

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
          'Keranjang Belanja Sayur',
          style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          if (cart.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined, color: Colors.grey),
              tooltip: 'Kosongkan Keranjang',
              onPressed: _confirmClearCart,
            ),
        ],
      ),
      body: cart.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: backsur.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      child: const Text('🧺', style: TextStyle(fontSize: 64)),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Keranjang Masih Kosong',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primary),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Yuk isi keranjangmu dengan aneka sayuran organik segar yang baru dipetik hari ini!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                        ),
                        icon: const Icon(Icons.storefront, color: Colors.white, size: 18),
                        label: const Text(
                          'Mulai Belanja Sayur',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                // Info Alamat Pengiriman Singkat
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  color: backsur.withOpacity(0.35),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: primary, size: 16),
                      const SizedBox(width: 6),
                      const Text(
                        'Kirim ke: ',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primary),
                      ),
                      Expanded(
                        child: Text(
                          userAddress,
                          style: const TextStyle(fontSize: 12, color: Colors.black87),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                // Bar Pilih Semua
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  child: Row(
                    children: [
                      Checkbox(
                        value: _isAllSelected,
                        activeColor: primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        onChanged: _toggleSelectAll,
                      ),
                      Text(
                        'Pilih Semua (${selectedItems.length}/${cart.length} Jenis Sayur)',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: primary),
                      ),
                      const Spacer(),
                      if (selectedItems.isNotEmpty)
                        Text(
                          '$selectedCount Item Dipilih',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // Daftar Item Keranjang
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    physics: const BouncingScrollPhysics(),
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final item = cart[index];
                      return _buildCartItemCard(item, index);
                    },
                  ),
                ),
              ],
            ),

      // Sticky Bottom Checkout Bar
      bottomNavigationBar: cart.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 14,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    // Total Harga
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Pembayaran:',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formatCurrency(_calculateSelectedTotal()),
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              color: primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Tombol Checkout
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          elevation: 0,
                        ),
                        onPressed: selectedItems.isEmpty
                            ? () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Pilih minimal 1 sayur untuk checkout'),
                                    duration: Duration(seconds: 1),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CheckoutPage(selectedItems: selectedItems),
                                  ),
                                ).then((_) => setState(() {}));
                              },
                        child: Text(
                          selectedItems.isEmpty
                              ? 'Checkout (0)'
                              : 'Checkout ($selectedCount)',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildCartItemCard(CartItem item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.isSelected ? primary.withOpacity(0.5) : Colors.grey.shade200,
          width: item.isSelected ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Checkbox per item
          Checkbox(
            value: item.isSelected,
            activeColor: primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            onChanged: (val) {
              setState(() => item.isSelected = val ?? false);
            },
          ),

          // Foto Sayur
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: backsur.withOpacity(0.4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: item.product.imageUrl.isNotEmpty
                  ? Image.network(
                      item.product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => const Icon(Icons.eco, color: primary, size: 28),
                    )
                  : Image.asset(
                      item.product.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => const Icon(Icons.eco, color: primary, size: 28),
                    ),
            ),
          ),
          const SizedBox(width: 12),

          // Info Sayur & Qty Control
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.product.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 16, color: Colors.grey),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => _confirmDeleteItem(index, item.product.title),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  item.product.weight,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
                const SizedBox(height: 8),

                // Harga & Pengatur Jumlah (- / +)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.product.price,
                      style: const TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    // Counter Quantity
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () => _decreaseQuantity(item, index),
                            borderRadius: BorderRadius.circular(10),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: Icon(Icons.remove, size: 16, color: primary),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              '${item.quantity}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                          InkWell(
                            onTap: () => _increaseQuantity(item),
                            borderRadius: BorderRadius.circular(10),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: Icon(Icons.add, size: 16, color: primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
