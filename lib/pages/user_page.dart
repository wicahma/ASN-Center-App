import 'dart:convert';

import 'package:asn_center_app/components/loading.dart';
import 'package:asn_center_app/logic/storage.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Map<String, dynamic>? userData;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    MainStorage.read("data_pengguna").then((value) => setState(() {
          userData = jsonDecode(value.toString());
          _isLoading = false;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Pengguna'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                padding: const EdgeInsets.all(20),
                child: Center(
                    child: Column(
                  children: [
                    Icon(Icons.account_circle_rounded,
                        size: 100,
                        color: Theme.of(context).colorScheme.primaryContainer),
                    Text(userData?['nama'] ?? "Nama Pengguna",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                        )),
                    Text(
                      userData?['email'] ?? "Email Pengguna",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    )
                  ],
                )),
              ),
              const ListTile(
                title: Text('Data Pengguna',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: userData?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      String key =
                          userData?.keys.elementAt(index).toString() ?? "";
                      String value = userData?[key].toString() ?? "";
                      return ListTile(
                        title: Text(key.toUpperCase()),
                        subtitle: Text(
                            value.toString() == "" || value.toString() == "null"
                                ? "-"
                                : value.toString()),
                      );
                    }),
              ),
            ],
          ),
          Loading(loadingState: _isLoading)
        ],
      ),
    );
  }
}
