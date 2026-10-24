import 'package:flutter/material.dart';
import 'package:vegetablesapp/bottom_nav.dart';
import 'package:vegetablesapp/models/app_state.dart';
import 'package:vegetablesapp/models/transaction.dart';
import 'package:vegetablesapp/ui/colors.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _formatCurrency(int amount) {
    return 'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  int _parsePrice(String priceStr) {
    final clean = priceStr.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(clean) ?? 0;
  }

  void _showReceiptModal(OrderHistory order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              // Handle drag bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Struk Digital Belanja',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primary),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey, size: 22),
                      onPressed: () => Navigator.pop(ctx),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  children: [
                    // KERTAS STRUK DIGITAL
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Struk
                          Center(
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: backsur.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.eco, color: primary, size: 28),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'VEGETABLES APP',
                                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1.2, color: primary),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'STRUK RESMI PEMBELIAN SAYUR SEGAR',
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black54),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Kebun Mitra Petani Organik Jawa Tengah',
                                  style: TextStyle(fontSize: 11, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 14),
                          _buildDashedLine(),
                          const SizedBox(height: 12),

                          // Informasi No. Transaksi & Tanggal
                          _buildReceiptRow('No. Pesanan', order.orderId),
                          const SizedBox(height: 4),
                          _buildReceiptRow('Waktu Transaksi', order.date),
                          const SizedBox(height: 4),
                          _buildReceiptRow('Metode Bayar', order.paymentMethod),
                          const SizedBox(height: 4),
                          _buildReceiptRow('Status', order.status, isStatus: true),

                          const SizedBox(height: 12),
                          _buildDashedLine(),
                          const SizedBox(height: 12),

                          // Informasi Pengiriman
                          const Text(
                            'Alamat Pengantaran:',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: primary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${order.recipientName} (${order.recipientPhone})',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            order.deliveryAddress,
                            style: const TextStyle(fontSize: 12, color: Colors.black87),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Jadwal: ${order.deliveryTime}',
                            style: const TextStyle(fontSize: 11, color: primary, fontWeight: FontWeight.w500),
                          ),

                          const SizedBox(height: 12),
                          _buildDashedLine(),
                          const SizedBox(height: 12),

                          // Tabel Item Sayuran
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Nama Sayur', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              Text('Subtotal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            ],
                          ),
                          const SizedBox(height: 8),

                          ...order.items.map((item) {
                            final itemTotal = _parsePrice(item.product.price) * item.quantity;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.product.title,
                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          '${item.product.weight} • ${item.quantity} x ${item.product.price}',
                                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    _formatCurrency(itemTotal),
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            );
                          }),

                          const SizedBox(height: 8),
                          _buildDashedLine(),
                          const SizedBox(height: 12),

                          // Kalkulasi Total
                          _buildReceiptRow('Subtotal Sayuran', _formatCurrency(order.totalAmount)),
                          const SizedBox(height: 4),
                          _buildReceiptRow('Ongkos Kirim', 'Gratis (Rp 0)', isGreen: true),
                          const SizedBox(height: 4),
                          _buildReceiptRow('Kemasan Zero-Waste Daun', 'Gratis', isGreen: true),
                          const SizedBox(height: 10),

                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: backsur.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'TOTAL DIBAYAR',
                                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: primary),
                                ),
                                Text(
                                  _formatCurrency(order.totalAmount),
                                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: primary),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),
                          _buildDashedLine(),
                          const SizedBox(height: 12),

                          // Catatan Kaki Struk
                          const Center(
                            child: Column(
                              children: [
                                Text(
                                  '*** TERIMA KASIH ***',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Sayur dipetik segar langsung dari petani lokal.',
                                  style: TextStyle(fontSize: 10, color: Colors.grey),
                                ),
                                Text(
                                  'Simpan struk ini sebagai bukti transaksi resmi.',
                                  style: TextStyle(fontSize: 10, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Tombol Aksi Struk
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: primary),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            icon: const Icon(Icons.share_outlined, color: primary, size: 18),
                            label: const Text('Bagikan Struk', style: TextStyle(color: primary, fontWeight: FontWeight.bold)),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Struk belanja berhasil dibagikan!'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            icon: const Icon(Icons.download_rounded, color: Colors.white, size: 18),
                            label: const Text('Simpan Struk', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Struk berhasil disimpan ke perangkat Anda! 📥'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              Navigator.pop(ctx);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashedLine() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : (MediaQuery.of(context).size.width - 88);
        const dashWidth = 5.0;
        const dashHeight = 1.0;
        final rawCount = (boxWidth / (2 * dashWidth)).floor();
        final dashCount = rawCount > 0 ? rawCount : 10;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return const SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.grey),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildReceiptRow(String label, String value, {bool isStatus = false, bool isGreen = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isStatus || isGreen ? FontWeight.bold : FontWeight.w500,
              color: isGreen ? primary : (isStatus ? primary : Colors.black87),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final history = AppState().history;
    final canPop = Navigator.canPop(context);

    return PopScope(
      canPop: !canPop,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigation(initialIndex: 0)),
          (route) => false,
        );
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: const Text(
            'Riwayat Pesanan Sayur',
            style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          leading: canPop
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: primary, size: 20),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const MainNavigation(initialIndex: 0)),
                      (route) => false,
                    );
                  },
                )
              : null,
        ),
        body: history.isEmpty
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
                        child: const Text('📜', style: TextStyle(fontSize: 60)),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Belum Ada Riwayat Pesanan',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primary),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Pesanan sayur segar Anda akan otomatis tercatat dan struk belanja dapat dicek di sini.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                physics: const BouncingScrollPhysics(),
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final order = history[index];
                  return _buildOrderCard(order);
                },
              ),
      ),
    );
  }

  Widget _buildOrderCard(OrderHistory order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showReceiptModal(order),
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Order ID & Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: backsur.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.receipt_long, color: primary, size: 16),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        order.orderId,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: backsur.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        order.status,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: primary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // Tanggal Transaksi
              Text(
                order.date,
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),

              const Divider(height: 18),

              // Preview Thumbnail Sayuran
              Row(
                children: [
                  // Thumbnails Row
                  ...order.items.take(3).map((item) {
                    return Container(
                      width: 44,
                      height: 44,
                      margin: const EdgeInsets.only(right: 8),
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
                                  errorBuilder: (c, e, s) => const Icon(Icons.eco, color: primary, size: 20),
                                ),
                              )
                            : Image.asset(
                                item.product.imagePath,
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => const Icon(Icons.eco, color: primary, size: 20),
                              ),
                      ),
                    );
                  }),
                  if (order.items.length > 3)
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Center(
                        child: Text(
                          '+${order.items.length - 3}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: primary),
                        ),
                      ),
                    ),
                  const SizedBox(width: 10),

                  // Teks Ringkasan Item
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.items.map((i) => i.product.title).join(', '),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${order.items.fold(0, (sum, i) => sum + i.quantity)} Ikat / Item sayuran',
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const Divider(height: 18),

              // Baris Total Harga & Tombol Lihat Struk
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Metode: ${order.paymentMethod}',
                          style: const TextStyle(color: Colors.grey, fontSize: 11),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatCurrency(order.totalAmount),
                          style: const TextStyle(color: primary, fontWeight: FontWeight.w800, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    ),
                    icon: const Icon(Icons.receipt_long, size: 16),
                    label: const Text(
                      'Lihat Struk',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    onPressed: () => _showReceiptModal(order),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}