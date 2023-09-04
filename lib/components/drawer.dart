import 'package:asn_center_app/logic/storage.dart';
import 'package:asn_center_app/pages/login_page.dart';
import 'package:asn_center_app/pages/setting_pages/setting_page.dart';
import 'package:asn_center_app/pages/user_page.dart';
import 'package:flutter/material.dart';

class UserDrawer extends StatelessWidget {
  final Map<String, dynamic>? userData;
  const UserDrawer({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          DrawerHeader(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              decoration: BoxDecoration(
                // borderRadius: const BorderRadius.all(Radius.circular(25)),
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              child: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.account_circle_rounded,
                      size: 80,
                      color: Theme.of(context).colorScheme.primaryContainer),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userData?['nama'].toString() ?? 'Nama Pengguna',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          userData?['email'] ?? 'Email Pengguna',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ))),
          Flexible(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              children: [
                ListTile(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  leading: const Icon(Icons.account_circle_outlined),
                  title: const Text('Data Pengguna'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserPage()));
                  },
                ),
                const Divider(
                  height: 25,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextButton.icon(
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all<Size>(
                                const Size(double.minPositive, 45)),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.red.shade400),
                            foregroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.red.shade100),
                            iconColor: MaterialStateColor.resolveWith(
                                (states) => Colors.red.shade100),
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                      title: const Text(
                                        'Anda yakin ingin keluar?',
                                        style: TextStyle(height: 1),
                                        textAlign: TextAlign.left,
                                      ),
                                      content: const Text(
                                        'Seluruh data anda pada aplikasi ASN akan dihapus, dan anda harus login ulang untuk menggunakan aplikasi ini kembali.',
                                        textAlign: TextAlign.left,
                                      ),
                                      actions: [
                                        TextButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                            Color>(
                                                        Colors.green.shade400),
                                                foregroundColor:
                                                    MaterialStateColor
                                                        .resolveWith((states) =>
                                                            Colors.white)),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text("Batal")),
                                        TextButton(
                                            style: ButtonStyle(
                                                foregroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(Colors.red)),
                                            onPressed: () => {
                                                  MainStorage.deleteAll(),
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const LoginPage()))
                                                },
                                            child: const Text("Keluar"))
                                      ],
                                    ));
                          },
                          icon: const Icon(Icons.exit_to_app_rounded),
                          label: const Text("Keluar")),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextButton.icon(
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all<Size>(
                              const Size(double.minPositive, 45)),
                          foregroundColor: MaterialStateColor.resolveWith(
                              (states) => Colors.grey.shade800),
                          iconColor: MaterialStateColor.resolveWith(
                              (states) => Colors.grey.shade800),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SettingPage(
                                        nama: userData?['nama'],
                                        userID: userData?['id'],
                                      )));
                        },
                        label: const Text("Pengaturan"),
                        icon: const Icon(Icons.settings),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
