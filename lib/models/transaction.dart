import 'package:vegetablesapp/models/product.dart';

class CartItem {
  final Product product;
  int quantity;
  bool isSelected;

  CartItem({
    required this.product,
    required this.quantity,
    this.isSelected = true,
  });
}

class OrderHistory {
  final String orderId;
  final String date;
  final List<CartItem> items;
  final String paymentMethod;
  final int totalAmount;
  final int deliveryFee;
  final int discount;
  final String recipientName;
  final String recipientPhone;
  final String deliveryAddress;
  final String status;
  final String deliveryTime;

  OrderHistory({
    required this.orderId,
    required this.date,
    required this.items,
    required this.paymentMethod,
    required this.totalAmount,
    this.deliveryFee = 0,
    this.discount = 0,
    this.recipientName = 'Ayudhya Naja',
    this.recipientPhone = '0812-3456-7890',
    this.deliveryAddress = 'Jl. Nakula Raya No. 10, Semarang',
    this.status = 'Selesai • Terkirim Segar 🌿',
    this.deliveryTime = '07.15 WIB (Panen Pagi)',
  });
}