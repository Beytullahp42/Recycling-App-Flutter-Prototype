import 'package:flutter/material.dart';
import '../components/product_tile.dart';
import '../models/product.dart';
import '../models/user_profile.dart';
import '../services/api_calls.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late Future<Map<String, dynamic>> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = _loadData();
  }

  Future<Map<String, dynamic>> _loadData() async {
    final results = await Future.wait([
      ApiCalls.getProducts(),
      ApiCalls.getUserProfile(),
    ]);

    return {
      'products': results[0] as List<Product>,
      'balance': (results[1] as UserProfile).balance,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Products")),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final products = snapshot.data!['products'] as List<Product>;
          final balance = snapshot.data!['balance'] as int;

          return Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.monetization_on),
                    const SizedBox(width: 4),
                    Text(
                      "Balance: $balance points",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.49, // specific ratio...
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      final canAfford = balance >= product.price;
                      return ProductTile(
                        product: product,
                        canAfford: canAfford,
                      );
                    },


                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
