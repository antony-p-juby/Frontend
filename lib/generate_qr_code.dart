import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'printQR.dart';

class GenerateQrCode extends StatefulWidget {
  final String? initialData;
  const GenerateQrCode({super.key, this.initialData});

  @override
  State<GenerateQrCode> createState() => _GenerateQrCodeState();
}

class _GenerateQrCodeState extends State<GenerateQrCode> {
  late TextEditingController urlController;
  String? qrData;

  @override
  void initState() {
    super.initState();
    urlController = TextEditingController(text: widget.initialData ?? '');
    qrData = widget.initialData;
  }

  @override
  void dispose() {
    urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Generate QR Code')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (qrData != null && qrData!.isNotEmpty)
                PrintQr.wrapQrWidget(
                  QrImageView(data: qrData!, size: 200),
                ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: urlController,
                  decoration: InputDecoration(
                    hintText: 'Enter your data',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelText: 'Enter your data',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    qrData = urlController.text;
                  });
                },
                child: const Text('Generate QR Code'),
              ),
              const SizedBox(height: 10),
              if (qrData != null && qrData!.isNotEmpty)
                ElevatedButton(
                  onPressed: () => PrintQr.printQrCode(),
                  child: const Text('Print QR Code'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
