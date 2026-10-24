import 'package:vegetablesapp/models/product.dart';
import 'package:vegetablesapp/models/transaction.dart';

class UserModel {
  String name;
  String email;
  String password;
  String phone;
  String address;
  String profilePicture;
  String membershipTier;
  int points;
  String joinDate;
  bool morningHarvestNotif;
  bool ecoPackaging;

  UserModel({
    required this.name, 
    required this.email, 
    required this.password,
    this.phone = '0812-3456-7890',
    this.address = 'Jl. Nakula Raya No. 10, Semarang',
    this.profilePicture = '',
    this.membershipTier = 'Sahabat Sayur Emas 🌿',
    this.points = 350,
    this.joinDate = 'Januari 2024',
    this.morningHarvestNotif = true,
    this.ecoPackaging = true,
  });
}

class AppState {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  // Keranjang awal dengan 2 sayur segar
  List<CartItem> cart = [
    CartItem(
      product: Product.sampleProducts[0], // Bayam Hijau Organik
      quantity: 1,
      isSelected: true,
    ),
    CartItem(
      product: Product.sampleProducts[2], // Brokoli Segar Hijau
      quantity: 1,
      isSelected: true,
    ),
  ];

  // Riwayat 1 transaksi awal yang siap dicek struknya
  List<OrderHistory> history = [
    OrderHistory(
      orderId: 'ORD-20261024-001',
      date: '24 Okt 2026, 07:15 WIB',
      items: [
        CartItem(
          product: Product.sampleProducts[0], // Bayam Hijau Organik
          quantity: 2,
          isSelected: true,
        ),
        CartItem(
          product: Product.sampleProducts[1], // Wortel Brastagi Manis
          quantity: 1,
          isSelected: true,
        ),
        CartItem(
          product: Product.sampleProducts[3], // Tomat Cherry Manis
          quantity: 1,
          isSelected: true,
        ),
      ],
      paymentMethod: 'QRIS',
      totalAmount: 29000,
      deliveryFee: 0,
      discount: 0,
      recipientName: 'Ayudhya Naja',
      recipientPhone: '0812-3456-7890',
      deliveryAddress: 'Jl. Nakula Raya No. 10, Semarang',
      status: 'Selesai • Terkirim Segar 🌿',
      deliveryTime: '07.15 WIB (Panen Pagi)',
    ),
  ];
  
  // Auth State
  UserModel? currentUser;
  List<UserModel> registeredUsers = [
    UserModel(
      name: 'Ayudhya Naja',
      email: 'naja@email.com',
      password: '123',
      phone: '0812-3456-7890',
      address: 'Jl. Nakula Raya No. 10, Semarang',
      membershipTier: 'Sahabat Sayur Emas 🌿',
      points: 350,
      joinDate: 'Januari 2024',
    ),
    UserModel(
      name: 'Budi Petani',
      email: 'budi@sayur.id',
      password: '123',
      phone: '0857-9876-5432',
      address: 'Jl. Melati No. 8, Tembalang, Semarang',
      membershipTier: 'Pecinta Sayur Hijau 🥦',
      points: 180,
      joinDate: 'Maret 2025',
    ),
  ];
}