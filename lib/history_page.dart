import 'package:flutter/material.dart';
import 'package:vegetablesapp/models/app_state.dart';
import 'package:vegetablesapp/ui/colors.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    final history = AppState().history;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pesanan', style: TextStyle(color: primary)),
        centerTitle: true,
      ),
      body: history.isEmpty
          ? const Center(child: Text('Belum ada pesanan.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final order = history[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(order.orderId, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(order.date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                        const Divider(),
                        ...order.items.map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text('${item.product.title} (x${item.quantity})'),
                        )),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Metode: ${order.paymentMethod}', style: const TextStyle(color: Colors.grey)),
                            const Text('Selesai', style: TextStyle(color: primary, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}