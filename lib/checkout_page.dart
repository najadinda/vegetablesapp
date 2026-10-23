import 'package:flutter/material.dart';
import 'package:vegetablesapp/models/app_state.dart';
import 'package:vegetablesapp/models/transaction.dart';
import 'package:vegetablesapp/ui/colors.dart';

class CheckoutPage extends StatefulWidget {
  final List<CartItem> selectedItems;
  const CheckoutPage({super.key, required this.selectedItems});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _paymentMethod = 'QRIS'; // Default payment

  int _calculateTotal() {
    int total = 0;
    for (var item in widget.selectedItems) {
      // Membersihkan teks 'Rp ' dan titik agar menjadi angka murni
      String cleanPrice = item.product.price.replaceAll(RegExp(r'[^0-9]'), '');
      total += (int.tryParse(cleanPrice) ?? 0) * item.quantity;
    }
    return total;
  }

  String _formatCurrency(int amount) {
    // Format kembali ke bentuk Rp xxx.xxx
    return 'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  void _processCheckout() {
    // 1. Buat pesanan baru ke histori
    final newOrder = OrderHistory(
      orderId: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      date: '23 Okt 2026', // Format dinamis bisa menggunakan package intl
      items: List.from(widget.selectedItems),
      paymentMethod: _paymentMethod,
      totalAmount: _calculateTotal(), // Kalkulasi total harga diimplementasikan di sini
    );
    AppState().history.add(newOrder);

    // 2. Hapus item yang sudah dicheckout dari keranjang
    AppState().cart.removeWhere((item) => item.isSelected);

    // 3. Tampilkan sukses & kembali ke beranda
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pesanan Berhasil Dibuat!')));
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout', style: TextStyle(color: primary))),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Alamat Pengiriman', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const Card(
            child: ListTile(
              leading: Icon(Icons.location_on, color: primary),
              title: Text('Ayudhya Naja Adinda'),
              subtitle: Text('Jl. Nakula Raya No 10, Semarang, Jawa Tengah'),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Produk', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          // Perbarui bagian List Produk ini
          ...widget.selectedItems.map((item) => ListTile(
            title: Text(item.product.title),
            subtitle: Text(item.product.price, style: const TextStyle(color: primary, fontWeight: FontWeight.bold)),
            trailing: Text('x${item.quantity}', style: const TextStyle(fontSize: 16)),
          )),
          const SizedBox(height: 20),
          const Text('Metode Pembayaran', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          _buildPaymentRadio('QRIS'),
          _buildPaymentRadio('Tunai (COD)'),
          _buildPaymentRadio('Transfer Bank'),
        ],
      ),
      // Perbarui bottomNavigationBar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Pembayaran:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(
                  _formatCurrency(_calculateTotal()),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: primary),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: primary, padding: const EdgeInsets.all(16)),
                onPressed: _processCheckout,
                child: const Text('Buat Pesanan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentRadio(String title) {
    return RadioListTile<String>(
      title: Text(title),
      value: title,
      groupValue: _paymentMethod,
      activeColor: primary,
      onChanged: (val) => setState(() => _paymentMethod = val!),
    );
  }

  
}