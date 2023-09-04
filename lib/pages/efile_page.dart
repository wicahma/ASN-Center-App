import 'package:asn_center_app/components/dialog_file.dart';
import 'package:asn_center_app/components/card_list_file.dart';
import 'package:asn_center_app/components/loading.dart';
import 'package:asn_center_app/logic/http_request.dart';
import 'package:asn_center_app/logic/storage.dart';
import 'package:flutter/material.dart';

class EfilePage extends StatefulWidget {
  const EfilePage({super.key});

  @override
  State<EfilePage> createState() => _EfilePageState();
}

class _EfilePageState extends State<EfilePage> {
  bool _isLoading = false;
  List<dynamic>? _efileData;

  @override
  void initState() {
    super.initState();

    _getEfile();
  }

  Future<void> _getEfile() async {
    setState(() {
      _isLoading = true;
    });
    String? token = await MainStorage.read("token");

    final response = await Rekues()
        .getData(url: "efile/list", header: {"Authorization": "$token"});

    debugPrint("Response: ${response.isSuccess.toString()}");

    if (!context.mounted) return;
    if (!response.isSuccess) {
      String message = response.message.toString();
      debugPrint("Pesan errornya: $message");
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent.shade200,
          content: const Text("Data efile gagal diambil!"),
          showCloseIcon: true,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = false;
      _efileData = response.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("E-File"),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.upload_rounded,
            size: 30,
            color: Theme.of(context).colorScheme.surfaceTint,
          ),
          onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => const DialogBuilder(),
          ),
        ),
        body: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () => _getEfile(),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                itemCount: _efileData?.length ?? 0,
                itemBuilder: (context, index) {
                  var data = _efileData?[index];
                  return CardListFile(
                    mainData: _efileData?[index],
                    namaDokumen: data['nama_dokumen'],
                    fileStatus: data['file_status'],
                    fileTahun: data['file_tahun'] ?? "-",
                    namaFile: data['file_nama'],
                  );
                },
              ),
            ),
            Loading(loadingState: _isLoading)
          ],
        ));
  }
}
