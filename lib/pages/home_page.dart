import 'dart:convert';

import 'package:asn_center_app/components/drawer.dart';
import 'package:asn_center_app/components/layanan_card.dart';
import 'package:asn_center_app/logic/http_request.dart';
import 'package:asn_center_app/logic/storage.dart';
import 'package:asn_center_app/pages/efile_page.dart';
import 'package:asn_center_app/pages/login_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _layanan = [
    const LayananCard(
        title: "E-File", icon: Icons.file_present_rounded, route: EfilePage())
  ];
  Map<String, dynamic>? _userData;

  void _getUserData() async {
    String? token = await MainStorage.read("token");
    debugPrint("token: $token");

    final response = await Rekues().getData(
        url: "profile/data_utama", header: {"Authorization": "$token"});

    if (!context.mounted) return;
    if (!response.isSuccess) {
      String message = response.message.toString();
      debugPrint(message);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent.shade200,
          content: const Text("Data pengguna gagal diambil!"),
          showCloseIcon: true,
        ),
      );
      return;
    }

    setState(() {
      _userData = response.data;
    });
    MainStorage.write("data_pengguna", jsonEncode(response.data));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.lightGreen,
        content: Text("Data pengguna tersinkronisasi!"),
        showCloseIcon: true,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    debugPrint("initState: ${Rekues().downloadDir}");
    MainStorage.checkUserValidity().then((value) {
      if (!value) {
        return Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
      }
      _getUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Layanan'),
      ),
      drawer: UserDrawer(userData: _userData),
      body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemCount: _layanan.length,
          itemBuilder: (BuildContext context, int index) {
            return _layanan[index];
          }),
    );
  }
}
