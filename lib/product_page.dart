import 'package:flutter/material.dart';
import 'package:vegetablesapp/ui/colors.dart';
import 'package:vegetablesapp/models/product.dart';
import 'detail_page.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String _searchQuery = '';
  String _selectedCategory = 'Semua';
  final List<String> _categories = ['Semua', 'Sayur', 'Umbi', 'Buah', 'Bumbu'];

  // Pastikan kategori diatur sesuai jenisnya
  final List<Product> _allProducts = [
    Product(title: 'Bayam Hijau Organik', price: 'Rp 4.500', weight: '250g', category: 'Sayur'),
    Product(title: 'Tomat Cherry', price: 'Rp 12.000', weight: '200g', category: 'Buah'),
    Product(title: 'Brokoli Segar', price: 'Rp 15.000', weight: '300g', category: 'Sayur'),
    Product(title: 'Kangkung Cabut', price: 'Rp 3.000', weight: '1 Ikat', category: 'Sayur'),
    Product(title: 'Wortel Brastagi', price: 'Rp 8.000', weight: '500g', category: 'Umbi'),
    Product(title: 'Bawang Merah Brebes', price: 'Rp 18.000', weight: '250g', category: 'Bumbu'),
    Product(title: 'Kentang Dieng', price: 'Rp 14.000', weight: '1 kg', category: 'Umbi'),
    Product(title: 'Cabai Rawit Merah', price: 'Rp 9.500', weight: '100g', category: 'Bumbu'),
  ];

  @override
  Widget build(BuildContext context) {
    // Logika Filter
    final filteredProducts = _allProducts.where((product) {
      final matchCategory = _selectedCategory == 'Semua' || product.category == _selectedCategory;
      final matchSearch = product.title.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchCategory && matchSearch;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0, centerTitle: true,
        title: const Text('Katalog Sayur', style: TextStyle(color: primary, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // Kolom Pencarian
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Cari sayuran...',
                prefixIcon: const Icon(Icons.search, color: primary),
                filled: true,
                fillColor: backsur,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
          ),
          // Chip Filter Kategori
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category, style: TextStyle(color: isSelected ? Colors.white : primary, fontWeight: FontWeight.bold)),
                    selected: isSelected,
                    selectedColor: primary,
                    backgroundColor: Colors.white,
                    side: BorderSide(color: primary.withOpacity(0.5)),
                    onSelected: (bool selected) => setState(() => _selectedCategory = category),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          // Hasil Filter
          Expanded(
            child: filteredProducts.isEmpty
              ? const Center(child: Text('Produk tidak ditemukan 😔', style: TextStyle(color: Colors.grey)))
              : GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.75, crossAxisSpacing: 16, mainAxisSpacing: 16),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) => _buildProductCard(context, filteredProducts[index]),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailPage(product: product)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 90,
                    width: double.infinity,
                    decoration: BoxDecoration(color: backsur, borderRadius: BorderRadius.circular(12)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        product.imagePath, 
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => const Icon(Icons.image_not_supported, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    product.title, 
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), 
                    maxLines: 2, 
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(product.weight, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const Spacer(),
                  Text(
                    product.price, 
                    style: const TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}