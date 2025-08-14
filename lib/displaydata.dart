import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/config.dart';
import 'package:http/http.dart' as http;

class Displaydata extends StatefulWidget {
  const Displaydata({super.key});

  @override
  State<Displaydata> createState() => _DisplaydataState();
}

class _DisplaydataState extends State<Displaydata> {
  List<dynamic> _users = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(finddata));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          _users = jsonResponse['data']; // from Node.js {status:true, data:[...]}
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = "Error: ${response.statusCode}";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = "Failed to load data: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error.isNotEmpty) {
      return Scaffold(
        body: Center(child: Text(_error)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Scanned Data"),
        backgroundColor: Colors.purple.withValues(alpha: 0.1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal, // allow horizontal scroll
          child: SingleChildScrollView(
            child: Table(
            columnWidths: const {
              0: FixedColumnWidth(50),    // ID
              1: FixedColumnWidth(200),  // Data column
              2: FixedColumnWidth(150),     // Date takes 1 part
            },
              border: TableBorder.all(width: 1, color: Colors.black),
              children: [
                // Header row
                TableRow(
                  decoration: const BoxDecoration(color: Colors.purple ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text("ID", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text("Data", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text("Date", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                // Data rows
                ..._users.map((user) {
                  final index = _users.indexOf(user) + 1; // ID number
                  return TableRow(
                    children: [
                      Container(
                        color: index % 2 == 0 ? Colors.purple[50] : Colors.white,
                        padding: const EdgeInsets.all(15),
                        child: Text(index.toString()),
                      ),
                      Container(
                        color: index % 2 == 0 ? Colors.purple[50] : Colors.white,
                        padding: const EdgeInsets.all(15),
                        child: Text(user['data'] ?? ''),
                      ),
                      Container(
                        color: index % 2 == 0 ? Colors.purple[50] : Colors.white,
                        padding: const EdgeInsets.all(15),
                        child: Text(user['date'] ?? ''),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
