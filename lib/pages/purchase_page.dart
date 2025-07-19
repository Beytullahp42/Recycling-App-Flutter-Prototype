import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/api_calls.dart';

class PurchaseSheet extends StatefulWidget {
  final Product product;
  final bool canAfford;
  final VoidCallback onPurchase;

  const PurchaseSheet({
    super.key,
    required this.product,
    required this.canAfford,
    required this.onPurchase,
  });

  @override
  State<PurchaseSheet> createState() => _PurchaseSheetState();
}

class _PurchaseSheetState extends State<PurchaseSheet> {
  bool _isLoading = false;
  bool _purchased = false;
  String? _message;

  void _handleBuy() async {
    if (!widget.canAfford || _purchased) return;

    setState(() {
      _isLoading = true;
      _message = null;
    });

    final result = await ApiCalls.redeemProduct(widget.product.id);
    final message =
        "Product ${widget.product.name} purchased successfully!\nProduct key: ${result['message'] ?? 'N/A'}";

    setState(() {
      _isLoading = false;
      _message = message;
      if (result['success'] == true) {
        _purchased = true;
        widget.onPurchase();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets.add(const EdgeInsets.all(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.product.name,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(widget.product.description),
          const SizedBox(height: 20),
          if (_message != null) ...[
            Text(
              _message!,
              style: TextStyle(
                color: _message!.contains("successfully") ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (_message!.contains("successfully")) ...[
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.info, color: Colors.black, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "You can see your product keys and transaction history in the Transactions page.",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ],
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: (_isLoading || !widget.canAfford || _purchased)
                      ? null
                      : _handleBuy,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.canAfford
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.monetization_on, size: 18, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.product.price}',
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
        ],
      ),
    );
  }
}
