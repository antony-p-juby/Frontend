import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import './scan_qr_code.dart';
class Dashboard extends StatefulWidget {
  
final String token;
  const Dashboard({
    super.key,
    required this.token, 
  });
  
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late String email;
  
  @override
  void initState() {
    super.initState();
    Map<String,dynamic> jwtDecodedToken =JwtDecoder.decode(widget.token);
    email=jwtDecodedToken['email']; 
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text('QR/Barcode Scanner'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(email),
            ElevatedButton(onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context)=>const ScanQrCode()),
              );
            }, child: const Text('Scan QR/Bar Code'))
          ],
        ),
      ),
    );
  }
}