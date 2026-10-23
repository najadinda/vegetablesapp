import 'package:vegetablesapp/models/product.dart';

class CartItem {
  final Product product;
  int quantity;
  bool isSelected;

  CartItem({
    required this.product,
    required this.quantity,
    this.isSelected = false,
  });
}

class OrderHistory {
  final String orderId;
  final String date;
  final List<CartItem> items;
  final String paymentMethod;
  final int totalAmount;

  OrderHistory({
    required this.orderId,
    required this.date,
    required this.items,
    required this.paymentMethod,
    required this.totalAmount,
  });
}