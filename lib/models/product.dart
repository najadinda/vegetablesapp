class Product {
  final String title;
  final String price;
  final String oldPrice;
  final String weight;
  final String description;
  final String benefits;
  final String vitamins;
  final String calories;
  final String recipe;
  final String category;
  final String imageUrl;
  final double rating;
  final String badgeText;

  Product({
    required this.title,
    required this.price,
    required this.oldPrice,
    required this.weight,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.badgeText,
    required this.description,
    required this.benefits,
    required this.vitamins,
    required this.calories,
    required this.recipe,
  });

  String get imagePath {
    if (imageUrl.isNotEmpty && imageUrl.startsWith('assets/')) {
      return imageUrl;
    }
    String formattedName = title.toLowerCase().replaceAll(' ', '-');
    return 'assets/images/$formattedName.jpg';
  }

  static List<Product> get sampleProducts => [
    Product(
      title: 'Bayam Hijau Organik',
      price: 'Rp 4.500',
      oldPrice: 'Rp 6.000',
      weight: '250g',
      category: 'Sayur Daun',
      imageUrl: 'assets/images/bayam-hijau-organik.jpg',
      rating: 4.9,
      badgeText: 'Paling Segar',
      description:
          'Bayam hijau organik segar hasil petik subuh. Daun lebar, renyah, dan kaya zat besi untuk kesehatan keluarga.',
      vitamins: 'Zat Besi, Vitamin A, Vitamin K',
      benefits: 'Mencegah anemia, menjaga kesehatan mata, dan mengontrol tekanan darah.',
      calories: '23 kkal / 100g',
      recipe: 'Sayur Bening Bayam: Rebus air dengan irisan bawang merah dan temu kunci. Masukkan jagung manis, lalu tambahkan bayam. Beri garam dan gula secukupnya.',
    ),
    Product(
      title: 'Wortel Brastagi Manis',
      price: 'Rp 8.000',
      oldPrice: 'Rp 10.000',
      weight: '500g',
      category: 'Umbi',
      imageUrl: 'assets/images/wortel-brastagi-manis.jpg',
      rating: 4.8,
      badgeText: 'Kaya Vitamin A',
      description:
          'Wortel renyah manis asli Brastagi. Sangat lezat dijus atau dimasak sop sayur segar.',
      vitamins: 'Beta-Karoten, Vitamin A, Vitamin C',
      benefits: 'Meningkatkan penglihatan, memperkuat sistem kekebalan tubuh, dan menyehatkan kulit.',
      calories: '41 kkal / 100g',
      recipe: 'Tumis Wortel Buncis: Potong wortel memanjang. Tumis bersama buncis, bawang putih, dan saus tiram hingga empuk.',
    ),
    Product(
      title: 'Brokoli Segar Hijau',
      price: 'Rp 15.000',
      oldPrice: 'Rp 18.000',
      weight: '300g',
      category: 'Sayur Daun',
      imageUrl: 'assets/images/brokoli-segar-hijau.jpg',
      rating: 4.9,
      badgeText: 'Superfood',
      description:
          'Kuntum brokoli padat hijau tua tanpa residu pestisida kimia. Superfood sarat antioksidan dan kalsium.',
      vitamins: 'Vitamin C, Kalsium, Antioksidan',
      benefits: 'Mencegah pertumbuhan sel kanker, melancarkan pencernaan, dan menjaga tulang tetap kuat.',
      calories: '34 kkal / 100g',
      recipe: 'Brokoli Cah Sapi: Rebus sebentar brokoli, lalu tumis dengan irisan daging sapi, bawang bombay, saus tiram, dan lada hitam.',
    ),
    Product(
      title: 'Tomat Cherry Manis',
      price: 'Rp 12.000',
      oldPrice: 'Rp 14.000',
      weight: '200g',
      category: 'Buah',
      imageUrl: 'assets/images/tomat-cherry-manis.jpg',
      rating: 4.8,
      badgeText: 'Manis Berair',
      description:
          'Tomat cherry merah ranum matang di pohon. Rasanya manis segar berair, pas untuk salad dan cemilan sehat.',
      vitamins: 'Lycopene, Vitamin C, Kalium',
      benefits: 'Menangkal radikal bebas, menyehatkan jantung, dan menjaga kelembapan kulit.',
      calories: '18 kkal / 100g',
      recipe: 'Salad Tomat Cherry: Belah dua tomat, campurkan dengan daun selada, minyak zaitun, perasan lemon, dan sedikit garam.',
    ),
    Product(
      title: 'Kangkung Hidroponik',
      price: 'Rp 3.500',
      weight: '1 Ikat',
      category: 'Sayur Daun',
      imageUrl: 'assets/images/kangkung-hidroponik.jpg',
      rating: 4.8,
      badgeText: 'Bebas Tanah',
      description:
          'Kangkung cabut hidroponik yang bersih dari tanah dan lumpur. Batang renyah lembut dan nikmat dimasak plecing.',
      oldPrice: 'Rp 5.000',
      benefits: 'Meningkatkan vitalitas, mencegah insomnia, dan menjaga kesehatan mata.',
      vitamins: 'Vitamin A, Vitamin C, Zat Besi',
      calories: '19 kkal / 100g',
      recipe: 'Kangkung Terasi Panas: Tumis bumbu halus dan terasi bakar, masukkan kangkung, masak cepat dengan api besar agar tetap renyah.',
    ),
    Product(
      title: 'Kentang Dieng Super',
      price: 'Rp 14.000',
      oldPrice: 'Rp 16.000',
      weight: '1 kg',
      category: 'Umbi',
      imageUrl: 'assets/images/kentang-dieng-super.jpg',
      rating: 4.7,
      badgeText: 'Pulen',
      description:
          'Kentang kuning bermutu tinggi dari tanah vulkanik Dieng. Tekstur gurih pulen cocok untuk perkedel dan sup.',
      benefits: 'Sumber energi yang mengenyangkan, menjaga fungsi saraf, dan mengontrol gula darah.',
      vitamins: 'Vitamin B6, Vitamin C, Kalium',
      calories: '87 kkal / 100g',
      recipe: 'Perkedel Kentang Panggang: Kukus kentang lalu haluskan. Campur dengan seledri, daging giling, dan telur. Bentuk bulat lalu panggang atau goreng hingga kecokelatan.',
    ),
    Product(
      title: 'Bawang Merah Brebes',
      price: 'Rp 18.000',
      weight: '250g',
      category: 'Bumbu',
      imageUrl: 'assets/images/bawang-merah-brebes.jpg',
      rating: 4.9,
      badgeText: 'Aroma Tajam',
      description:
          'Bawang merah Brebes berkualitas tinggi dengan kadar air rendah dan wangi sedap menyengat.',
      oldPrice: 'Rp 22.000',
      benefits: 'Menurunkan kolesterol, mengandung antibakteri alami, dan melegakan pernapasan.',
      vitamins: 'Vitamin C, Vitamin B6, Asam Folat',
      calories: '40 kkal / 100g',
      recipe: 'Bawang Merah Goreng Renyah: Iris tipis, taburi sedikit garam dan tepung beras, lalu goreng dengan api sedang hingga keemasan.',
    ),
    Product(
      title: 'Cabai Rawit Merah',
      price: 'Rp 9.500',
      oldPrice: 'Rp 12.000',
      weight: '100g',
      category: 'Bumbu',
      imageUrl: 'assets/images/cabai-rawit-merah.jpg',
      rating: 4.8,
      badgeText: 'Pedas Juara',
      description:
          'Cabai rawit merah petik langsung dari pohon. Tingkat kepedasan alami yang menggelegar untuk sambal segar.',
      benefits: 'Meningkatkan metabolisme tubuh, meredakan nyeri alami, dan tinggi antioksidan.',
      vitamins: 'Vitamin C, Vitamin A, Capsaicin',
      calories: '40 kkal / 100g',
      recipe: 'Sambal Bawang Rawit: Ulek kasar cabai rawit dan bawang putih yang sudah digoreng, beri garam, dan siram dengan minyak panas.',
    ),
    Product(
      title: 'Jagung Manis Madu',
      price: 'Rp 7.000',
      weight: '2 Buah',
      category: 'Sayur Daun',
      imageUrl: 'assets/images/jagung-manis-madu.jpg',
      rating: 4.9,
      badgeText: 'Manis Alami',
      description:
          'Jagung manis madu dengan butir padat berisi. Rasa manis alami cocok direbus atau dibakar.',
      oldPrice: 'Rp 9.000',
      benefits: 'Melancarkan pencernaan, baik untuk ibu hamil, dan menjaga kesehatan mata.',
      vitamins: 'Vitamin B1, Folat, Vitamin C',
      calories: '86 kkal / 100g',
      recipe: 'Sup Krim Jagung Manis: Pipil jagung, masak bersama susu cair, kaldu ayam, dan irisan sosis. Kentalkan dengan tepung maizena.',
    ),
    Product(
      title: 'Selada Keriting Hijau',
      price: 'Rp 6.000',
      weight: '200g',
      category: 'Sayur Daun',
      imageUrl: 'assets/images/selada-keriting-hijau.jpg',
      rating: 4.8,
      badgeText: 'Renyah',
      description:
          'Selada keriting hijau hidroponik yang sangat renyah dan segar, sangat cocok untuk burger dan salad.',
      oldPrice: 'Rp 8.000',
      benefits: 'Membantu hidrasi tubuh, merawat kesehatan jantung, dan memperkuat tulang.',
      vitamins: 'Vitamin K, Vitamin A, Asam Folat',
      calories: '15 kkal / 100g',
      recipe: 'Sandwich Sayur Sehat: Gunakan lembaran selada segar sebagai pelapis roti gandum utuh bersama telur rebus dan tomat iris.',
    ),
    Product(
      title: 'Paprika Merah Segar',
      price: 'Rp 16.000',
      oldPrice: 'Rp 19.000',
      weight: '250g',
      category: 'Buah',
      imageUrl: 'assets/images/paprika-merah-segar.jpg',
      rating: 4.7,
      badgeText: 'Kaya Antioksidan',
      description:
          'Paprika merah segar berdaging tebal dan manis tanpa rasa pedas, cocok untuk tumisan daging dan pizza.',
      benefits: 'Meningkatkan imunitas secara optimal, menjaga kesehatan kulit, dan mengurangi peradangan.',
      vitamins: 'Vitamin C, Vitamin A, Vitamin B6',
      calories: '31 kkal / 100g',
      recipe: 'Ayam Tumis Paprika: Potong dadu dada ayam dan paprika merah. Tumis dengan bawang bombay, saus tiram, kecap manis, dan lada hitam.',
    ),
    Product(
      title: 'Mentimun Lalap Segar',
      price: 'Rp 5.000',
      weight: '500g',
      category: 'Buah',
      imageUrl: 'assets/images/mentimun-lalap-segar.jpg',
      rating: 4.6,
      badgeText: 'Segar & Berair',
      description:
          'Timun lalap renyah dengan biji kecil dan kandungan air tinggi untuk menyegarkan tenggorokan.',
      oldPrice: 'Rp 7.000',
      benefits: 'Menghidrasi tubuh dengan cepat, menyehatkan kulit, dan membantu membuang racun (detoks).',
      vitamins: 'Vitamin K, Vitamin C, Kalium',
      calories: '15 kkal / 100g',
      recipe: 'Acar Mentimun Segar: Potong dadu mentimun (buang biji), campurkan dengan irisan bawang merah, rawit, beri sedikit gula, garam, dan cuka.',
    ),
  ];
}
