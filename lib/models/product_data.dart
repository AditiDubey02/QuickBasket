import 'product.dart';

final List<Product> products = [
  Product(
    id: 1,
    name: 'Fresh Apples',
    description: 'Fresh red apples',
    image: 'assets/images/apple.png',
    price: 120,
    quantity: '1 kg',
    category: 'Fruits',
  ),

  Product(
    id: 2,
    name: 'Fresh Milk',
    description: 'Full cream milk',
    image: 'assets/images/milk.png',
    price: 30,
    quantity: '500 ml',
    category: 'Dairy',
  ),

  Product(
    id: 3,
    name: 'Bananas',
    description: 'Fresh yellow bananas',
    image: 'assets/images/banana.png',
    price: 50,
    quantity: '1 dozen',
    category: 'Fruits',
  ),

  Product(
    id: 4,
    name: 'Tomatoes',
    description: 'Fresh red tomatoes',
    image: 'assets/images/tomato.png',
    price: 40,
    quantity: '1 kg',
    category: 'Vegetables',
  ),
];
