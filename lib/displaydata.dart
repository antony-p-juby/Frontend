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
          _users = jsonResponse['data'];
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

Future<void> deleteData(dynamic id) async {
  try {
    final urlWithId = deletedata.replaceFirst(':id', id.toString()); // convert to String
    final response = await http.delete(Uri.parse(urlWithId));

    if (response.statusCode == 200) {
      setState(() {
        _users.removeWhere((user) => user['id'] == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data deleted successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete: ${response.statusCode}")),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $e")),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_error.isNotEmpty) {
      return Scaffold(body: Center(child: Text(_error)));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scanned Data"),
        backgroundColor: Colors.purple.withValues(alpha: 0.1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: Table(
              columnWidths: const {
                0: FixedColumnWidth(50),
                1: FixedColumnWidth(200),
                2: FixedColumnWidth(150),
                3: FixedColumnWidth(150),
              },
              border: TableBorder.all(width: 1, color: Colors.black),
              children: [
                TableRow(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 214, 168, 223),
                  ),
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "ID",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "Data",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "Date",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "Action",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                ..._users.map((user) {
                  final index = _users.indexOf(user) + 1;
                  return TableRow(
                    children: [
                      Container(
                        color: index % 2 == 0
                            ? Colors.purple[50]
                            : Colors.white,
                        padding: const EdgeInsets.all(15),
                        child: Text(user['id'].toString()),
                      ),
                      Container(
                        color: index % 2 == 0
                            ? Colors.purple[50]
                            : Colors.white,
                        padding: const EdgeInsets.all(15),
                        child: Text(user['data'] ?? ''),
                      ),
                      Container(
                        color: index % 2 == 0
                            ? Colors.purple[50]
                            : Colors.white,
                        padding: const EdgeInsets.all(15),
                        child: Text(user['date'] ?? ''),
                      ),
                      Container(
                        color: index % 2 == 0
                            ? Colors.purple[50]
                            : Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.blueGrey),
                          onPressed: () {
                            deleteData(user['id']);
                          },
                        ),
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
