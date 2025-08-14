import 'package:flutter/material.dart';
import 'package:frontend/displaydata.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import './scan_qr_code.dart';

class Dashboard extends StatefulWidget {
  final String token;
  const Dashboard({super.key, required this.token});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late String email;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    email = jwtDecodedToken['email'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR/Barcode Scanner'),
        backgroundColor: Colors.purple.withValues(alpha: 0.1),
        actions: [
          Row(
            children: [
              const Icon(Icons.person),
              const SizedBox(width: 5),
              Text('Welcome, $email', style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 10),
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ScanQrCode()),
                );
              },
              child: const Text('Scan QR/Bar Code'),
            ),
            const SizedBox(height: 40),
              ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Displaydata()),
                );
              },
              child: const Text('Display Scanned Data'),
            ),
          ],
        ),
      ),
    );
  }
}
