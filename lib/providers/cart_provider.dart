import 'package:flutter/material.dart';

import '../models/product.dart';
import '../models/product_data.dart';

class CartProvider extends ChangeNotifier {
  final Map<int, int> _items = {};

  Map<int, int> get items => _items;

  int get totalItems {
    return _items.values.fold(0, (sum, quantity) => sum + quantity);
  }

  double get totalPrice {
    double total = 0;

    for (var entry in _items.entries) {
      final product = products.firstWhere((product) => product.id == entry.key);

      total += product.price * entry.value;
    }

    return total;
  }

  void addToCart(Product product) {
    _items.update(product.id, (quantity) => quantity + 1, ifAbsent: () => 1);

    notifyListeners();
  }

  void removeFromCart(Product product) {
    if (!_items.containsKey(product.id)) return;

    if (_items[product.id] == 1) {
      _items.remove(product.id);
    } else {
      _items[product.id] = _items[product.id]! - 1;
    }

    notifyListeners();
  }

  int getQuantity(int productId) {
    return _items[productId] ?? 0;
  }

  void clearCart() {
    if (_items.isEmpty) return;

    _items.clear();

    notifyListeners();
  }
}
