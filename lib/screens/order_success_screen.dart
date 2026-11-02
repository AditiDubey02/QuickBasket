import 'package:flutter/material.dart';

import '../models/order.dart';

class OrderSuccessScreen extends StatelessWidget {
  final Order order;

  const OrderSuccessScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text('Order Confirmation'),
        backgroundColor: const Color(0xFFF7CB45),
        automaticallyImplyLeading: false,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SUCCESS ICON
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                  ),

                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 90,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // SUCCESS MESSAGE
              const Center(
                child: Text(
                  'Order Placed Successfully!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 10),

              const Center(
                child: Text(
                  'Thank you for shopping with QuickBasket.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ),

              const SizedBox(height: 25),

              // ORDER ID CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8DF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF7CB45)),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Order ID',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),

                    const SizedBox(height: 6),

                    SelectableText(
                      order.id,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'Status: ${order.status}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // DELIVERY ADDRESS
              const Text(
                'Delivery Address',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              Card(
                elevation: 0,
                color: Colors.grey.shade50,

                child: ListTile(
                  leading: const Icon(Icons.location_on, color: Colors.green),

                  title: Text(order.deliveryAddress),

                  subtitle: const Text('Delivery location'),
                ),
              ),

              const SizedBox(height: 25),

              // ORDERED PRODUCTS
              const Text(
                'Ordered Products',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              ...order.items.map((item) {
                return Card(
                  elevation: 0,
                  color: Colors.grey.shade50,

                  margin: const EdgeInsets.only(bottom: 10),

                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),

                      child: Image.asset(
                        item.productImage,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,

                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.shopping_basket),
                          );
                        },
                      ),
                    ),

                    title: Text(
                      item.productName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),

                    subtitle: Text(
                      '₹${item.price.toStringAsFixed(2)} × '
                      '${item.quantity}',
                    ),

                    trailing: Text(
                      '₹${item.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 20),

              // BILL DETAILS
              const Text(
                'Bill Details',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              _billRow('Total Items', '${order.totalItems}'),

              _billRow('Subtotal', '₹${order.subtotal.toStringAsFixed(2)}'),

              _billRow(
                'Delivery Fee',
                order.deliveryFee == 0
                    ? 'FREE'
                    : '₹${order.deliveryFee.toStringAsFixed(2)}',
              ),

              const Divider(height: 25),

              _billRow(
                'Grand Total',
                '₹${order.totalAmount.toStringAsFixed(2)}',
                isBold: true,
              ),

              const SizedBox(height: 20),

              // PAYMENT METHOD
              Card(
                elevation: 0,
                color: Colors.grey.shade50,

                child: ListTile(
                  leading: const Icon(Icons.payment, color: Colors.green),

                  title: const Text('Payment Method'),

                  subtitle: Text(order.paymentMethod),
                ),
              ),

              const SizedBox(height: 10),

              // ORDER DATE
              _billRow('Order Date', _formatDate(order.orderDate)),

              const SizedBox(height: 30),

              // CONTINUE SHOPPING BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },

                  icon: const Icon(Icons.shopping_bag),

                  label: const Text(
                    'Continue Shopping',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF7CB45),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              const Center(
                child: Text(
                  'Thank you for choosing QuickBasket!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),

              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  // REUSABLE BILL ROW
  Widget _billRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 17 : 14,
            ),
          ),
        ],
      ),
    );
  }

  // FORMAT ORDER DATE
  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$day/$month/$year  $hour:$minute';
  }
}
