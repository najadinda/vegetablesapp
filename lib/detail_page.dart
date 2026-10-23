import 'package:flutter/material.dart';
import 'package:vegetablesapp/models/transaction.dart';
import 'models/app_state.dart';
import 'ui/colors.dart';
import 'models/product.dart';

class DetailPage extends StatefulWidget {
  final Product product;
  
  const DetailPage({super.key, required this.product});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _quantity = 1;

  void _addToCart() {
    // Mengecek apakah produk sudah ada di keranjang
    int existingIndex = AppState().cart.indexWhere((item) => item.product.title == widget.product.title);
    
    if (existingIndex >= 0) {
      AppState().cart[existingIndex].quantity += _quantity;
    } else {
      AppState().cart.add(CartItem(product: widget.product, quantity: _quantity));
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.title} ditambahkan ke keranjang!'),
        backgroundColor: primary,
        duration: const Duration(seconds: 2),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 300,
              decoration: const BoxDecoration(color: backsur),
              child: Image.asset(widget.product.imagePath, fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => const Icon(Icons.image, color: Colors.grey, size: 80),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.product.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: primary)),
                  const SizedBox(height: 8),
                  Text('${widget.product.price} • ${widget.product.weight}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  
                  // Info Gizi
                  _buildSectionTitle('Informasi Gizi'),
                  _buildInfoRow(Icons.local_fire_department, 'Kalori', widget.product.calories),
                  _buildInfoRow(Icons.medical_services_outlined, 'Vitamin', widget.product.vitamins),
                  _buildInfoRow(Icons.health_and_safety_outlined, 'Manfaat', widget.product.benefits),
                  
                  const SizedBox(height: 24),
                  _buildSectionTitle('Ide Resep'),
                  Text(widget.product.recipe, style: const TextStyle(color: Colors.grey, height: 1.5)),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10)]),
          child: Row(
            children: [
              // Pengatur Kuantitas (Sederhana)
              IconButton(icon: const Icon(Icons.remove_circle_outline), color: primary, onPressed: () => setState(() { if(_quantity>1) _quantity--; })),
              Text('$_quantity', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.add_circle_outline), color: primary, onPressed: () => setState(() => _quantity++)),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: primary, padding: const EdgeInsets.symmetric(vertical: 16)),
                  onPressed: _addToCart,
                  child: const Text('Tambah ke Keranjang', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primary)),
  );

  Widget _buildInfoRow(IconData icon, String title, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: secondary),
        const SizedBox(width: 8),
        Expanded(child: Text('$title: $value', style: const TextStyle(color: Colors.black87))),
      ],
    ),
  );
}