import 'package:flutter/material.dart';

import '../models/product_data.dart';
import '../widgets/product_card.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Fruits',
    'Vegetables',
    'Dairy',
    'Snacks',
  ];

  @override
  Widget build(BuildContext context) {
    final filteredProducts = selectedCategory == 'All'
        ? products
        : products
              .where((product) => product.category == selectedCategory)
              .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Shop by Category',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),

        // Category buttons
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];

              final isSelected = selectedCategory == category;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),

                child: ChoiceChip(
                  label: Text(category),
                  selected: isSelected,

                  selectedColor: const Color(0xFFF7CB45),

                  onSelected: (selected) {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 15),

        // Filtered products
        Expanded(
          child: filteredProducts.isEmpty
              ? const Center(child: Text('No products available'))
              : GridView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filteredProducts.length,

                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.68,
                  ),

                  itemBuilder: (context, index) {
                    return ProductCard(product: filteredProducts[index]);
                  },
                ),
        ),
      ],
    );
  }
}
