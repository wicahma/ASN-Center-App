import 'dart:convert';

import 'package:asn_center_app/components/loading.dart';
import 'package:asn_center_app/logic/http_request.dart';
import 'package:asn_center_app/logic/storage.dart';
import 'package:asn_center_app/pages/home_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController nip = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool showPassword = true;
  bool _isLoading = false;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nip.dispose();
    password.dispose();
    super.dispose();
  }

  Future<bool> _validateUser(String nip, String password) async {
    try {
      if (nip.isEmpty || password.isEmpty) {
        throw Exception("nip atau password tidak boleh kosong!");
      }

      setState(() {
        _isLoading = true;
      });
      
      var map = <String, String>{};
      map['nip'] = nip;
      map['password'] = password;

      final response = await Rekues().postData(url: "auth", data: map);

      if (!response.isSuccess) {
        String message = response.message.toString();
        setState(() {
          _isLoading = false;
          _errorMsg = message;
        });
        return false;
      }

      setState(() {
        _isLoading = false;
        _errorMsg = null;
      });

      MainStorage.write("token", response.data?['access_token']);
      MainStorage.write("nip", response.data?['nip']);
      return true;
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMsg = e.toString().split("Exception: ").last;
      });
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Login",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.primary),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      TextField(
                        obscureText: false,
                        controller: nip,
                        onChanged: (value) => setState(() {}),
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          labelText: 'NIP',
                        ),
                        cursorColor: Colors.black,
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        obscureText: showPassword,
                        controller: password,
                        onChanged: (value) => setState(() {}),
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          suffixIcon: GestureDetector(
                            onTap: () => setState(() {
                              showPassword = !showPassword;
                            }),
                            child: Icon(
                                !showPassword
                                    ? Icons.visibility_rounded
                                    : Icons.visibility_off_rounded,
                                size: 25),
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          labelText: 'Password',
                        ),
                        cursorColor: Colors.black,
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.surface,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () => _validateUser(nip.text, password.text)
                            .then((value) {
                          if (!value) {
                            return ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.redAccent.shade200,
                                content: Text(_errorMsg ?? "Gagal login!"),
                                showCloseIcon: true,
                              ),
                            );
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.lightGreen,
                              content: Text("Berhasil login!"),
                              showCloseIcon: true,
                            ),
                          );
                          return Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()));
                        }),
                        child: const Text("Login"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Loading(loadingState: _isLoading),
        ],
      ),
    );
  }
}
