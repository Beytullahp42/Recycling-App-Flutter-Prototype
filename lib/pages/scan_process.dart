import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../routes.dart';
import '../services/api_calls.dart';

class ScanProcess extends StatefulWidget {
  final String qrCode;
  const ScanProcess({super.key, required this.qrCode});

  @override
  State<ScanProcess> createState() => _ScanProcessState();
}

class _ScanProcessState extends State<ScanProcess> {
  late Future<String> _scanFuture;

  @override
  void initState() {
    super.initState();
    _scanFuture = ApiCalls.scanQr(widget.qrCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scanning QR Code')),
      body: FutureBuilder<String>(
        future: _scanFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // show spinner
            return const Center(child: CircularProgressIndicator());
          }

          // Once complete (either data or error), schedule a post-frame callback
          // to show a toast & navigate back
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (snapshot.hasError) {
              final err = snapshot.error.toString();
              Fluttertoast.showToast(
                msg: 'Error: $err',
                backgroundColor: Colors.red,
                textColor: Colors.white,
                gravity: ToastGravity.BOTTOM,
              );
            } else {
              final msg = snapshot.data!;
              Fluttertoast.showToast(
                msg: msg,
                gravity: ToastGravity.BOTTOM,
              );
            }
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          });

          // In the meantime, keep the UI minimal
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
