import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductTile extends StatelessWidget {
  final Product product;

  final bool canAfford;

  const ProductTile({
    super.key,
    required this.product,
    required this.canAfford,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Square Image
          AspectRatio(
            aspectRatio: 1, // Square
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: product.image != null
                  ? Image.network(
                product.image!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.broken_image, size: 40),
                ),
              )
                  : const Center(
                child: Icon(Icons.image_not_supported, size: 40),
              ),
            ),
          ),
          // Info Section - Expanded to take remaining space
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 4, left: 12, right: 12, top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // This distributes space evenly
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    product.description,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: canAfford ? () {
                        // TODO: handle buy
                      } : (){}, // disables the button
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canAfford
                            ? Theme.of(context).colorScheme.primary
                            : Color.fromRGBO(90, 90, 90, 1.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.monetization_on, size: 18, color: Colors.white),
                          const SizedBox(width: 2),
                          Text(
                            '${product.price}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}