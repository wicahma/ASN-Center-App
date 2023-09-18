import 'dart:convert';

import 'package:asn_center_app/components/drawer.dart';
import 'package:asn_center_app/components/layanan_card.dart';
import 'package:asn_center_app/logic/http_request.dart';
import 'package:asn_center_app/logic/storage.dart';
import 'package:asn_center_app/pages/diklat_struktural_page.dart';
import 'package:asn_center_app/pages/efile_page.dart';
import 'package:asn_center_app/pages/kursus_page.dart';
import 'package:asn_center_app/pages/login_page.dart';
import 'package:asn_center_app/pages/skp_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _layanan = [
    const LayananCard(
        title: "E-File", icon: Icons.file_present_rounded, route: EfilePage()),
    const LayananCard(
        title: "Diklat Struktural",
        icon: Icons.book,
        route: DiklatStrukturalPage()),
    const LayananCard(
        title: "Kursus", icon: Icons.golf_course_rounded, route: KursusPage()),
    const LayananCard(
        title: "SKP", icon: Icons.stacked_bar_chart_rounded, route: SKP())
  ];
  Map<String, dynamic>? _userData;

  Future<void> _getUserData() async {
    try {
      String? token = await MainStorage.read("token");
      debugPrint("token: $token");

      final response = await Rekues().getData(
          url: "profile/data_utama", header: {"Authorization": "$token"});

      if (!context.mounted) return;
      if (!response.isSuccess) {
        String message = response.message.toString();
        throw Exception(message);
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent.shade200,
          content: Text(e.toString().split("Exception: ").last),
          showCloseIcon: true,
        ),
      );
    }
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
      body: RefreshIndicator(
        onRefresh: () {
          setState(() {});
          return _getUserData();
        },
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: _layanan.length,
            itemBuilder: (BuildContext context, int index) {
              return _layanan[index];
            }),
      ),
    );
  }
}
