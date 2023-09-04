import 'package:asn_center_app/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MainStorage {
  static const storage = FlutterSecureStorage();
  static const options = AndroidOptions(
      encryptedSharedPreferences: true,
      sharedPreferencesName: "asn_center_app_storage",
      resetOnError: true,
      keyCipherAlgorithm:
          KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_CBC_PKCS7Padding);

  static Future<String?> read(String key) async {
    try {
      return await storage.read(key: key, aOptions: options);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static Future<void> write(String key, String value) async {
    try {
      await storage.write(key: key, value: value, aOptions: options);
      debugPrint("Write $key success");
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> delete(String key) async {
    try {
      await storage
          .delete(key: key, aOptions: options)
          .then((value) => debugPrint("Delete $key success"));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> deleteAll() async {
    try {
      await storage
          .deleteAll(aOptions: options)
          .then((value) => debugPrint("Delete all success"));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<bool> checkUserValidity() async {
    String? token = await storage.read(key: "token", aOptions: options);
    if (token == null) {
      debugPrint("Token is empty");
      return false;
    }
    debugPrint("Token is not empty");
    debugPrint(token);
    return true;
  }
}
