import 'package:flutter/material.dart';
import 'package:vegetablesapp/checkout_page.dart';
import 'package:vegetablesapp/ui/colors.dart';

import 'models/app_state.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang', style: TextStyle(color: primary)),
      ),
      body: AppState().cart.isEmpty
          ? const Center(child: Text('Keranjang masih kosong'))
          : Column(
              children: [
                CheckboxListTile(
                  title: const Text(
                    'Pilih Semua',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  value: _isAllSelected,
                  activeColor: primary,
                  onChanged: _toggleSelectAll,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: AppState().cart.length,
                    itemBuilder: (context, index) {
                      final item = AppState().cart[index];
                      return ListTile(
                        leading: Checkbox(
                          value: item.isSelected,
                          activeColor: primary,
                          onChanged: (val) =>
                              setState(() => item.isSelected = val!),
                        ),
                        title: Text(item.product.title),
                        subtitle: Text(
                          '${item.product.price} x ${item.quantity}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              setState(() => AppState().cart.removeAt(index)),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: AppState().cart.isEmpty
          ? null
          : Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Produk Terpilih:',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      Text(
                        '${AppState().cart.where((i) => i.isSelected).fold(0, (sum, item) => sum + item.quantity)} Item',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        padding: EdgeInsets.all(16),
                      ),
                      onPressed: () {
                        final selectedItems = AppState().cart
                            .where((i) => i.isSelected)
                            .toList();
                        if (selectedItems.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Pilih minimal 1 produk'),
                            ),
                          );
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CheckoutPage(selectedItems: selectedItems),
                          ),
                        );
                      },
                      child: Text(
                        'Checkout Produk Terpilih',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
