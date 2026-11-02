import 'package:flutter/material.dart';
import 'order_history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(25),
            color: const Color(0xFFF7CB45),
            child: const Column(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 55, color: Colors.black54),
                ),
                SizedBox(height: 12),
                Text(
                  'Welcome to QuickBasket',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text('Manage your account'),
              ],
            ),
          ),

          const SizedBox(height: 15),

          profileOption(
            icon: Icons.person_outline,
            title: 'My Account',
            subtitle: 'View and edit your profile',
          ),

          profileOption(
            icon: Icons.location_on_outlined,
            title: 'My Addresses',
            subtitle: 'Manage delivery addresses',
          ),

          profileOption(
            icon: Icons.shopping_bag_outlined,
            title: 'My Orders',
            subtitle: 'View your previous orders',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrderHistoryScreen(),
                ),
              );
            },
          ),

          profileOption(
            icon: Icons.payment,
            title: 'Payment Methods',
            subtitle: 'Manage payment options',
          ),

          profileOption(
            icon: Icons.help_outline,
            title: 'Help & Support',
            subtitle: 'Get help with your orders',
          ),

          profileOption(
            icon: Icons.info_outline,
            title: 'About QuickBasket',
            subtitle: 'Learn more about us',
          ),
        ],
      ),
    );
  }

  Widget profileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
      ),
      onTap: onTap,
    );
  }
}
