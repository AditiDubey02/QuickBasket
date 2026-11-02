import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/order.dart';

class OrderProvider extends ChangeNotifier {
  static const String _ordersKey = 'quickbasket_orders';

  final List<Order> _orders = [];

  List<Order> get orders => List.unmodifiable(_orders);

  int get orderCount => _orders.length;

  // Save all orders to local storage.
  Future<void> _saveOrders() async {
    final prefs = await SharedPreferences.getInstance();

    final String encodedOrders = jsonEncode(
      _orders.map((order) => order.toJson()).toList(),
    );

    await prefs.setString(_ordersKey, encodedOrders);
  }

  // Add an order and save it to local storage.
  Future<void> addOrder(Order order) async {
    final savedOrder = Order(
      id: order.id,
      items: List.unmodifiable(order.items),
      deliveryAddress: order.deliveryAddress,
      paymentMethod: order.paymentMethod,
      subtotal: order.subtotal,
      deliveryFee: order.deliveryFee,
      totalAmount: order.totalAmount,
      orderDate: order.orderDate,
      status: order.status,
    );

    _orders.insert(0, savedOrder);

    notifyListeners();

    await _saveOrders();
  }

  // Find an order using its ID.
  Order? getOrderById(String orderId) {
    for (final order in _orders) {
      if (order.id == orderId) {
        return order;
      }
    }

    return null;
  }

  // Remove all orders and update local storage.
  Future<void> clearOrders() async {
    if (_orders.isEmpty) {
      return;
    }

    _orders.clear();

    notifyListeners();

    await _saveOrders();
  }
}
