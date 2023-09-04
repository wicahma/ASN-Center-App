import 'dart:convert';
import 'dart:io';

import 'package:asn_center_app/logic/http_request.dart';
import 'package:asn_center_app/logic/storage.dart';
import 'package:asn_center_app/pages/setting_pages/notification_page.dart';
import 'package:asn_center_app/pages/user_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  final String nama, userID;
  const SettingPage({super.key, required this.nama, required this.userID});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String _downloadDir = "";

  @override
  void initState() {
    super.initState();
    _getDownloadDirectory();
  }

  Future<void> _getDownloadDirectory() async {
    try {
      String? result = await MainStorage.read("download_dir");
      if (result == null) throw Exception("Tidak ada direktori yang dipilih!");

      setState(() {
        _downloadDir = result;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _setDownloadDirectory() async {
    try {
      String? result = await FilePicker.platform.getDirectoryPath();
      if (result == null) throw Exception("Tidak ada direktori yang dipilih!");

      debugPrint("result: $result");

      await MainStorage.write("download_dir", result);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.lightGreen,
          content: Text("Direktori berhasil dipilih!"),
          showCloseIcon: true,
        ),
      );
      _getDownloadDirectory();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent.shade200,
          content: Text(e.toString()),
          showCloseIcon: true,
        ),
      );
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const UserPage()));
              },
              child: Card(
                elevation: 0,
                color: Colors.transparent,
                child: ListTile(
                  leading: const Icon(
                    Icons.account_circle_rounded,
                    size: 50,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  title: Text(
                    widget.nama,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 18),
                  ),
                  subtitle: Text(
                    "ID-${widget.userID}",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10, height: 1),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                color: Colors.green.shade100,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              width: double.maxFinite,
              height: 120,
              child: Stack(
                children: [
                  Positioned(
                    top: -25,
                    right: 10,
                    child: Icon(Icons.bookmark_outline_rounded,
                        size: 100, color: Colors.green.shade900),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("ASN App",
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.green.shade900,
                                fontWeight: FontWeight.w800)),
                        Text(
                          "Kelola seluruh data anda disini.",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.green.shade900,
                              height: 1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(7, 15, 7, 7),
                child: ListView(
                  children: <Widget>[
                    InkWell(
                      splashColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade300,
                      focusColor: Colors.grey.shade300,
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NotificationPage())),
                      child: const ListTile(
                        title: Text(
                          "Notifikasi",
                          style: TextStyle(fontSize: 17),
                        ),
                        leading: Icon(
                          Icons.notifications_rounded,
                          size: 30,
                        ),
                        trailing: Icon(Icons.arrow_forward_ios_rounded),
                      ),
                    ),
                    InkWell(
                      splashColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade300,
                      focusColor: Colors.grey.shade300,
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      onTap: () => _setDownloadDirectory(),
                      child: ListTile(
                        title: const Text(
                          "Lokasi Download",
                          style: TextStyle(fontSize: 17),
                        ),
                        leading: const Icon(
                          Icons.download_done_rounded,
                          size: 30,
                        ),
                        subtitle: Card(
                          margin: EdgeInsets.zero,
                          elevation: 0,
                          color: Colors.grey.shade200,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 1),
                            child: Text(
                              _downloadDir,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 11),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        appBar: AppBar(
          title: const Text("Setting Page"),
        ));
  }
}
