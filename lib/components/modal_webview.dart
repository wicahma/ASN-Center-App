import 'package:asn_center_app/logic/storage.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ModalWebview extends StatefulWidget {
  final String namaFile;
  const ModalWebview({super.key, required this.namaFile});

  @override
  State<ModalWebview> createState() => _ModalWebviewState();
}

class _ModalWebviewState extends State<ModalWebview> {
  final WebViewController webvController = WebViewController();

  @override
  void initState() {
    super.initState();
    _getWebview();
  }

  Future<void> _getWebview() async {
    try {
      String? token = await MainStorage.read("token");
      webvController.setBackgroundColor(Theme.of(context).colorScheme.surface);
      webvController.enableZoom(true);
      webvController.clearCache();
      webvController.setJavaScriptMode(JavaScriptMode.unrestricted);
      webvController.loadRequest(
          Uri.parse(
              "https://asncenter.rembangkab.go.id/api/v1/efile/download/${widget.namaFile}"),
          headers: {"Authorization": token.toString()});
      debugPrint("nama file: ${widget.namaFile}");
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent.shade200,
          content: Text(e.toString()),
          showCloseIcon: true,
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 5 / 6,
      child: WebViewWidget(controller: webvController),
    );
  }
}
