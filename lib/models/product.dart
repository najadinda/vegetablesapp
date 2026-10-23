class Product {
  final String title;
  final String price;
  final String weight;
  final String description;
  final String benefits;
  final String vitamins;
  final String calories;
  final String recipe;
  final String category;

  Product({
    required this.title,
    required this.price,
    required this.weight,
    this.category = 'Sayuran',
    this.description = 'Sayuran segar langsung dari petani lokal. Ditanam tanpa menggunakan pestisida kimia.',
    this.benefits = 'Meningkatkan daya tahan tubuh dan melancarkan pencernaan.',
    this.vitamins = 'Kaya akan Vitamin A, Vitamin C, dan Zat Besi.',
    this.calories = '25 kkal / 100g',
    this.recipe = 'Tumis bawang putih, masukkan sayur, tambahkan sedikit saus tiram dan garam. Masak hingga layu.',
  });

  String get imagePath {
    String formattedName = title.toLowerCase().replaceAll(' ', '_');
    return 'assets/images/$formattedName.png';
  }
}