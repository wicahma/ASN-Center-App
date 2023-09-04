import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool _status = true;
  @override
  void initState() {
    super.initState();
    _seeNotificationPermission();
  }

  @override
  void dispose() {
    super.dispose();
    _seeNotificationPermission();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint("state: $state");
    _seeNotificationPermission();
  }

  Future<void> _seeNotificationPermission() async {
    PermissionStatus permission = await Permission.notification.status;
    debugPrint("permission: ${permission.isGranted}");
    if (!permission.isGranted) {
      debugPrint("permission not granted");
      return setState(() {
        _status = false;
      });
    }
    debugPrint("permission not granted");
    return setState(() {
      _status = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifikasi")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey.shade200,
              ),
              padding: const EdgeInsets.all(15),
              child: const Text(
                "Aktifkan segera supaya aplikasi dapat segera memberitahukanmu tentang informasi penting.",
                style: TextStyle(fontSize: 16, height: 1),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  const Text("Status",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          height: 1)),
                  const SizedBox(
                    width: 10,
                  ),
                  const Flexible(child: Divider()),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: _status
                            ? Colors.green.shade100
                            : Colors.red.shade100,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: Text(
                        _status ? "Aktif" : "Tidak Aktif",
                        style: TextStyle(
                            fontSize: 15,
                            height: 1,
                            color: _status ? Colors.green : Colors.red),
                      )),
                ],
              ),
            ),
            Image.asset("assets/images/notification.png"),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => openAppSettings(),
              child: const Text("Aktifkan Notifikasi"),
            ),
          ],
        ),
      ),
    );
  }
}
