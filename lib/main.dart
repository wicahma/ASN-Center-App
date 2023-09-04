import 'package:asn_center_app/logic/storage.dart';
import 'package:asn_center_app/pages/home_page.dart';
import 'package:asn_center_app/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool isValidatedUser = await MainStorage.checkUserValidity();
  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );
  runApp(MyApp(
    isValidated: isValidatedUser,
  ));
}

class MyApp extends StatelessWidget {
  final bool isValidated;
  const MyApp({super.key, required this.isValidated});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ASN App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 125, 183, 58)),
        useMaterial3: true,
      ),
      home: isValidated ? const HomePage() : const LoginPage(),
    );
  }
}
