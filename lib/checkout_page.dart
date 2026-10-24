import 'package:flutter/material.dart';
import 'package:vegetablesapp/bottom_nav.dart';
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
  String _paymentMethod = 'QRIS';
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  int _parsePrice(String priceStr) {
    final clean = priceStr.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(clean) ?? 0;
  }

  int _calculateSubtotal() {
    int total = 0;
    for (var item in widget.selectedItems) {
      total += _parsePrice(item.product.price) * item.quantity;
    }
    return total;
  }

  String _formatCurrency(int amount) {
    return 'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  void _processCheckout() {
    final user = AppState().currentUser;
    final now = DateTime.now();
    final timeStr = '${now.hour.toString().padLeft(2, '0')}.${now.minute.toString().padLeft(2, '0')} WIB';
    final dateStr = '${now.day} Okt ${now.year}, $timeStr';
    final randomSuffix = now.millisecondsSinceEpoch.toString().substring(8);
    final orderId = 'ORD-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-$randomSuffix';

    final total = _calculateSubtotal();

    // 1. Buat pesanan baru ke histori (masukkan ke urutan pertama)
    final newOrder = OrderHistory(
      orderId: orderId,
      date: dateStr,
      items: List.from(widget.selectedItems),
      paymentMethod: _paymentMethod,
      totalAmount: total,
      deliveryFee: 0,
      discount: 0,
      recipientName: user?.name ?? 'Ayudhya Naja',
      recipientPhone: user?.phone ?? '0812-3456-7890',
      deliveryAddress: user?.address ?? 'Jl. Nakula Raya No. 10, Semarang',
      status: 'Pesanan Dikonfirmasi • Siap Panen 🌿',
      deliveryTime: '06.30 - 09.00 WIB (Panen Pagi)',
    );

    AppState().history.insert(0, newOrder);

    // 2. Hapus item yang sudah dicheckout dari keranjang
    AppState().cart.removeWhere((item) => widget.selectedItems.contains(item));

    // 3. Tampilkan dialog sukses pesanan
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: backsur,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle, color: primary, size: 52),
            ),
            const SizedBox(height: 16),
            const Text(
              'Pesanan Sayur Berhasil!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'No. Pesanan: $orderId\nSayuran segar Anda akan dipanen pagi ini dan diantar ke alamat Anda.',
              style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.receipt_long, color: Colors.white, size: 18),
                label: const Text('Lihat Riwayat & Struk', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainNavigation(initialIndex: 2),
                    ),
                    (route) => false,
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainNavigation(initialIndex: 0),
                  ),
                  (route) => false,
                );
              },
              child: const Text('Kembali ke Beranda', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AppState().currentUser;
    final subtotal = _calculateSubtotal();

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
          'Konfirmasi Checkout Sayur',
          style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. ALAMAT PENGANTARAN SAYUR
            _buildSectionHeader('Alamat Pengantaran Sayur Segar'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 3)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: backsur.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.location_on, color: primary, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.name ?? 'Nama Pelanggan',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Text(
                              user?.phone ?? '0812-3456-7890',
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user?.address ?? 'Jl. Nakula Raya No. 10, Semarang',
                    style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.3),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: backsur.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.local_shipping, size: 14, color: primary),
                        SizedBox(width: 6),
                        Text(
                          'Jadwal Kirim: Panen Pagi (06.00 - 09.00 WIB)',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: primary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. RINCIAN SAYUR YANG DIPESAN
            _buildSectionHeader('Sayur yang Dipesan (${widget.selectedItems.length} Jenis)'),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(12),
                itemCount: widget.selectedItems.length,
                separatorBuilder: (ctx, idx) => const Divider(height: 16),
                itemBuilder: (context, index) {
                  final item = widget.selectedItems[index];
                  final itemTotal = _parsePrice(item.product.price) * item.quantity;
                  return Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: backsur.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: item.product.imageUrl.startsWith('http')
                              ? Image.network(
                                  item.product.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (ctx, err, stack) => Image.asset(
                                    item.product.imagePath,
                                    fit: BoxFit.cover,
                                    errorBuilder: (c, e, s) => const Icon(Icons.eco, color: primary, size: 24),
                                  ),
                                )
                              : Image.asset(
                                  item.product.imagePath,
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, e, s) => const Icon(Icons.eco, color: primary, size: 24),
                                ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.product.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${item.product.weight} • ${item.quantity} x ${item.product.price}',
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        _formatCurrency(itemTotal),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: primary),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // 3. METODE PEMBAYARAN
            _buildSectionHeader('Pilihan Metode Pembayaran'),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildPaymentTile(
                    'QRIS',
                    'Scan Instan (BCA, GoPay, OVO, ShopeePay)',
                    Icons.qr_code_scanner,
                    'Instan Bebas Admin',
                  ),
                  const Divider(height: 1),
                  _buildPaymentTile(
                    'Tunai (COD)',
                    'Bayar langsung saat sayur segar sampai di rumah',
                    Icons.payments_outlined,
                    'Tanpa Repot',
                  ),
                  const Divider(height: 1),
                  _buildPaymentTile(
                    'Transfer Bank',
                    'BCA / Mandiri Virtual Account',
                    Icons.account_balance_outlined,
                    'Otomatis',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 4. RINGKASAN PEMBAYARAN
            _buildSectionHeader('Ringkasan Pembayaran'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildSummaryRow('Subtotal Sayur', _formatCurrency(subtotal)),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Ongkos Kirim Panen Pagi', 'Gratis (Rp 0)', isHighlight: true),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Kemasan Besek & Daun Organik', 'Gratis', isHighlight: true),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Bayar',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text(
                        _formatCurrency(subtotal),
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 14, offset: const Offset(0, -4)),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Pembayaran', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 2),
                    Text(
                      _formatCurrency(subtotal),
                      style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: primary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    elevation: 0,
                  ),
                  onPressed: _processCheckout,
                  child: const Text(
                    'Pesan Sekarang',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: primary),
      ),
    );
  }

  Widget _buildPaymentTile(String title, String subtitle, IconData icon, String badge) {
    final isSelected = _paymentMethod == title;
    return InkWell(
      onTap: () => setState(() => _paymentMethod = title),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? primary : Colors.grey, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isSelected ? primary : Colors.black87)),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: backsur.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(badge, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: primary)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
            ),
            Radio<String>(
              value: title,
              groupValue: _paymentMethod,
              activeColor: primary,
              onChanged: (val) => setState(() => _paymentMethod = val!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.black54)),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
            color: isHighlight ? primary : Colors.black87,
          ),
        ),
      ],
    );
  }
}