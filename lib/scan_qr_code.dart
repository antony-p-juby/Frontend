import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import './generate_qr_code.dart';

class ScanQrCode extends StatefulWidget {
  const ScanQrCode({super.key});

  @override
  State<ScanQrCode> createState() => _ScanQrCodeState();
}

class _ScanQrCodeState extends State<ScanQrCode> {
  String scannedText = 'Scanned data will appear here';
  bool isScanned = false;

  void handleDetect(BarcodeCapture capture) {
    if (isScanned) return;

    final barcode = capture.barcodes.first;
    final String code = barcode.rawValue ?? "---";

    setState(() {
      scannedText = code;
      isScanned = true;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Scanned:,$code")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR/Bar Code'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Column(
        children: [
          Expanded(flex: 2, child: MobileScanner(onDetect: handleDetect)),
          Expanded(
            flex: 2,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    scannedText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isScanned = false;
                        scannedText = 'Scanned data wil appear here';
                      });
                    },
                    child: const Text('Scan Again'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (scannedText.isNotEmpty &&
                          scannedText != 'Scanned data will appear here') {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                GenerateQrCode(initialData: scannedText),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'No data to generate to generate QR code',
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text('Generate QR Code'),
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
