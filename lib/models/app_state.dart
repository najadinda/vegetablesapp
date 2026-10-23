import 'package:vegetablesapp/models/transaction.dart';

class UserModel {
  String name;
  String email;
  String password;
  String profilePicture; // Tambahan untuk foto profil

  UserModel({
    required this.name, 
    required this.email, 
    required this.password,
    this.profilePicture = '', // Kosong sebagai bawaan
  });
}

class AppState {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  List<CartItem> cart = [];
  List<OrderHistory> history = [];
  
  // Auth State
  UserModel? currentUser;
  List<UserModel> registeredUsers = [
    UserModel(name: 'Ayudhya Naja', email: 'naja@email.com', password: '123')
  ];
}