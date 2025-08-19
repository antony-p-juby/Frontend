// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:flutter/rendering.dart';
// import 'package:flutter/widgets.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// class PrintQr {
//   static final GlobalKey _qrKey = GlobalKey();

//   /// Wrap your QR widget so it can be captured
//   static Widget wrapQrWidget(Widget qrWidget) {
//     return RepaintBoundary(
//       key: _qrKey,
//       child: qrWidget,
//     );
//   }

//   /// Convert the wrapped QR to image bytes
//   static Future<Uint8List> _captureQrAsImage() async {
//     final boundary = _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
//     final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
//     final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
//     return byteData!.buffer.asUint8List();
//   }

//   /// Print the QR code widget inside a PDF
//   static Future<void> printQrCode() async {
//     final qrBytes = await _captureQrAsImage();

//     final pdf = pw.Document();
//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         build: (context) => pw.Center(
//           child: pw.Image(pw.MemoryImage(qrBytes), width: 200, height: 200),
//         ),
//       ),
//     );

//     await Printing.layoutPdf(onLayout: (format) async => pdf.save());
//   }
// }
