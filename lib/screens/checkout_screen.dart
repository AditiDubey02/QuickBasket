import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'order_success_screen.dart';

import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../models/order.dart';
import '../models/product_data.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController addressController = TextEditingController();

  String selectedPayment = 'Cash on Delivery';

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: const Color(0xFFF7CB45),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          final deliveryFee = cart.totalPrice >= 199 ? 0.0 : 25.0;
          final grandTotal = cart.totalPrice + deliveryFee;

          if (cart.totalItems == 0) {
            return const Center(child: Text('Your cart is empty'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Delivery Address',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: addressController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Enter your complete delivery address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  'Order Summary',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                ...products
                    .where((product) {
                      return cart.getQuantity(product.id) > 0;
                    })
                    .map((product) {
                      final quantity = cart.getQuantity(product.id);

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(product.name),
                        subtitle: Text('Quantity: $quantity'),
                        trailing: Text(
                          '₹${(product.price * quantity).toStringAsFixed(2)}',
                        ),
                      );
                    }),

                const Divider(height: 30),

                const Text(
                  'Payment Method',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                RadioListTile<String>(
                  title: const Text('Cash on Delivery'),
                  value: 'Cash on Delivery',
                  groupValue: selectedPayment,
                  onChanged: (value) {
                    setState(() {
                      selectedPayment = value!;
                    });
                  },
                ),

                RadioListTile<String>(
                  title: const Text('UPI'),
                  value: 'UPI',
                  groupValue: selectedPayment,
                  onChanged: (value) {
                    setState(() {
                      selectedPayment = value!;
                    });
                  },
                ),

                const Divider(height: 30),

                const Text(
                  'Bill Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                billRow('Subtotal', cart.totalPrice),
                billRow('Delivery Fee', deliveryFee),
                const Divider(),
                billRow('Grand Total', grandTotal, isBold: true),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF7CB45),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.all(16),
                    ),
                    onPressed: () {
                      // Step 1: Validate the delivery address.
                      final address = addressController.text.trim();

                      if (address.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter your delivery address'),
                          ),
                        );
                        return;
                      }

                      // Step 2: Get the providers.
                      final cartProvider = context.read<CartProvider>();
                      final orderProvider = context.read<OrderProvider>();

                      // Step 3: Ensure the cart contains products.
                      if (cartProvider.totalItems == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Your cart is empty')),
                        );
                        return;
                      }

                      // Step 4: Calculate the final bill.
                      final subtotal = cartProvider.totalPrice;

                      final deliveryFee = subtotal >= 199 ? 0.0 : 25.0;

                      final grandTotal = subtotal + deliveryFee;

                      // Step 5: Copy the cart products into order items.
                      final orderItems = products
                          .where((product) {
                            return cartProvider.getQuantity(product.id) > 0;
                          })
                          .map((product) {
                            return OrderItem(
                              productId: product.id,
                              productName: product.name,
                              productImage: product.image,
                              price: product.price,
                              quantity: cartProvider.getQuantity(product.id),
                            );
                          })
                          .toList();

                      // Step 6: Generate a unique order ID.
                      final now = DateTime.now();

                      final orderId = 'QB-${now.millisecondsSinceEpoch}';

                      // Step 7: Create the order.
                      final order = Order(
                        id: orderId,
                        items: orderItems,
                        deliveryAddress: address,
                        paymentMethod: selectedPayment,
                        subtotal: subtotal,
                        deliveryFee: deliveryFee,
                        totalAmount: grandTotal,
                        orderDate: now,
                        status: 'Placed',
                      );

                      // Step 1: Save the order.
                      orderProvider.addOrder(order);

                      // Step 2: Clear the cart.
                      cartProvider.clearCart();

                      // Step 3: Navigate to the Order Success screen.
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return OrderSuccessScreen(order: order);
                          },
                        ),
                      );
                    },
                    child: Text(
                      'Place Order • ₹${grandTotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget billRow(String title, double amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '₹${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
