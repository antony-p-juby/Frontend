import 'package:flutter/material.dart';
import 'package:frontend/print.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateQrCode extends StatefulWidget {
  final String? initialData;
  const GenerateQrCode({super.key, this.initialData});

  @override
  State<GenerateQrCode> createState() => _GenerateQrCodeState();
}

class _GenerateQrCodeState extends State<GenerateQrCode> {
  late TextEditingController sectionController;
  String? qrData;
  List<String> generatedData = [];

  @override
  void initState() {
    super.initState();
    qrData = widget.initialData;
    sectionController = TextEditingController();
  }

  @override
  void dispose() {
    sectionController.dispose();
    super.dispose();
  }

  void generateSections() {
    final count = int.tryParse(sectionController.text.trim()) ?? 0;
    if (qrData == null || qrData!.isEmpty || count <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid data and section count")),
      );
      return;
    }

    setState(() {
      generatedData = List.generate(count, (i) => "$qrData/${i + 1}");
    });
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: sectionController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter a number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelText: 'Enter number of sections',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: generateSections,
                child: const Text('Generate Sections'),
              ),
              const SizedBox(height: 20),

              if (generatedData.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: generatedData.length,
                  itemBuilder: (context, index) {
                    final item = generatedData[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                      child: ListTile(
                        title: Text(item, style: const TextStyle(fontSize: 18)),
                        leading: QrImageView(data: item, size: 60),
                  trailing: IconButton(
                    icon: const Icon(Icons.print, color: Colors.blue),
                    onPressed: () {
                      PrintQ.printQrCode(item);
                    },
                  ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
