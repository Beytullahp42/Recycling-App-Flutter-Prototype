import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transactions.dart';
import '../services/api_calls.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  late Future<List<TransactionModel>> _future;
  String _selectedType = 'ALL';
  String _selectedSort = 'newest';

  @override
  void initState() {
    super.initState();
    _future = ApiCalls.getTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transaction History")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedType,
                    decoration: const InputDecoration(
                      labelText: 'Filter by type',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: const [
                      DropdownMenuItem(value: 'ALL', child: Text('All')),
                      DropdownMenuItem(value: 'SQR', child: Text('QR Scan')),
                      DropdownMenuItem(value: 'RED', child: Text('Redeem')),
                      DropdownMenuItem(value: 'SRW', child: Text('Season Reward')),
                      DropdownMenuItem(value: 'INV', child: Text('Invalid')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedSort,
                    decoration: const InputDecoration(
                      labelText: 'Sort by date',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: const [
                      DropdownMenuItem(value: 'newest', child: Text('Newest First')),
                      DropdownMenuItem(value: 'oldest', child: Text('Oldest First')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedSort = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<TransactionModel>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                List<TransactionModel> transactions = snapshot.data!;

                // Filter by type
                if (_selectedType != 'ALL') {
                  transactions = transactions
                      .where((tx) => tx.type == _selectedType)
                      .toList();
                }

                // Sort by date
                transactions.sort((a, b) {
                  return _selectedSort == 'newest'
                      ? b.createdAt.compareTo(a.createdAt)
                      : a.createdAt.compareTo(b.createdAt);
                });

                if (transactions.isEmpty) {
                  return const Center(child: Text("No transactions found."));
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: transactions.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final tx = transactions[index];
                    final isPositive = tx.amount >= 0;
                    final dateStr = DateFormat('yyyy-MM-dd HH:mm').format(tx.createdAt);
                    final reason = tx.reason.replaceAll(r'\n', '\n');

                    return ListTile(
                      leading: Icon(
                        tx.type == 'SQR'
                            ? Icons.qr_code
                            : tx.type == 'RED'
                            ? Icons.shopping_cart_outlined
                            : tx.type == 'SRW'
                            ? Icons.emoji_events
                            : Icons.info_outline,
                        color: isPositive ? Colors.green : Colors.red,
                      ),
                      title: Text(reason),
                      subtitle: Text(dateStr),
                      trailing: Text(
                        '${isPositive ? '+' : ''}${tx.amount} pts',
                        style: TextStyle(
                          color: isPositive ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
