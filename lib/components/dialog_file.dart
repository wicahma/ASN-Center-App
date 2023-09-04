import 'dart:ffi';
import 'dart:io';
import 'package:asn_center_app/logic/http_request.dart';
import 'package:asn_center_app/logic/storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class DialogBuilder extends StatefulWidget {
  const DialogBuilder({super.key});

  @override
  State<DialogBuilder> createState() => _DialogBuilderState();
}

class _DialogBuilderState extends State<DialogBuilder> {
  File? fileResult;
  String? fileName;
  final TextEditingController idJenisDokumen = TextEditingController();
  final TextEditingController tahun = TextEditingController();

  @override
  void initState() {
    super.initState();
    fileResult = null;
    fileName = null;
    idJenisDokumen.clear();
    tahun.clear();
  }

  @override
  void dispose() {
    fileResult = null;
    fileName = null;
    idJenisDokumen.dispose();
    tahun.dispose();
    super.dispose();
  }

  bool isTypeCorrect(String path) {
    String extension = path.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return true;
      case 'jpg':
        return true;
      case 'jpeg':
        return true;
      default:
        return false;
    }
  }

  bool isSizeCorrect(int size) {
    // 2 MB limit
    if (size > 2097152) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> _uploadEfile() async {
    try {
      String? token = await MainStorage.read("token");
      if (idJenisDokumen.text.isEmpty ||
          tahun.text.isEmpty ||
          fileResult == null) {
        throw Exception("Kode File, Tahun & File tidak boleh kosong!");
      }

      debugPrint(idJenisDokumen.text);
      debugPrint(tahun.text);
      debugPrint(fileResult!.path);
      debugPrint(token);

      final response = await Rekues().postData(url: "efile/upload", header: {
        "Authorization": "$token"
      }, data: {
        "dokumen": fileResult,
        "id_jenis_dokumen": idJenisDokumen.text,
        "tahun": tahun.text,
      });

      if (!context.mounted) return;
      debugPrint(response.isSuccess.toString());
      if (!response.isSuccess) throw Exception("Gagal mengupload file!");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent.shade200,
          content: const Text("Berhasil mengupload file!"),
          showCloseIcon: true,
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent.shade200,
          content: Text(e.toString().split("Exception: ").last),
          showCloseIcon: true,
        ),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      actions: [
        TextButton(
          onPressed: () {
            FilePicker.platform.clearTemporaryFiles();
            Navigator.pop(context);
          },
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () {
            // Navigator.pop(context);
            _uploadEfile();
          },
          child: const Text('Upload'),
        ),
      ],
      title: const Text(
        'Upload File',
        style: TextStyle(height: 1),
        textAlign: TextAlign.left,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pilih file yang akan diupload',
            style: TextStyle(height: 1),
          ),
          const SizedBox(height: 15),
          TextField(
            obscureText: false,
            controller: idJenisDokumen,
            onChanged: (value) => setState(() {}),
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                labelText: 'Kode File',
                helperText: "*hint: Dapat diambil dari detail file."),
            cursorColor: Colors.white,
          ),
          const SizedBox(height: 15),
          TextField(
            obscureText: false,
            controller: tahun,
            onChanged: (value) => setState(() {}),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              labelText: 'Tahun',
            ),
            cursorColor: Colors.white,
          ),
          Card(
            margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
            color: Theme.of(context).colorScheme.surfaceTint,
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Text(
                    fileName ?? "Belum ada file yang dipilih",
                    style: const TextStyle(height: 1, color: Colors.white),
                  )),
            ),
          ),
          const SizedBox(height: 25),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primaryContainer,
                backgroundColor: Theme.of(context).colorScheme.surfaceTint,
              ),
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  allowMultiple: false,
                  allowedExtensions: ['pdf', 'jpg', 'jpeg'],
                  type: FileType.custom,
                );

                if (result == null) {
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.redAccent.shade200,
                      content: const Text("User canceled the picker!"),
                      showCloseIcon: true,
                    ),
                  );
                }

                File file = File(result!.files.single.path!);

                // Type Checker
                if (!isTypeCorrect(file.path)) {
                  FilePicker.platform.clearTemporaryFiles();
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.redAccent.shade200,
                      content: const Text("Jenis File tidak didukung!"),
                      showCloseIcon: true,
                    ),
                  );
                  return;
                }

                // Size Checker
                if (!isSizeCorrect(file.lengthSync())) {
                  FilePicker.platform.clearTemporaryFiles();
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.redAccent.shade200,
                      content: const Text("Ukuran file lebih dari 2Mb!"),
                      showCloseIcon: true,
                    ),
                  );
                  return;
                }

                // State Updater
                setState(() {
                  fileResult = file;
                  fileName = file.uri.pathSegments.last;
                });

                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.greenAccent.shade200,
                    content: const Text("Data berhasil dipilih!"),
                    showCloseIcon: true,
                  ),
                );
              },
              icon: const Icon(Icons.file_upload_outlined),
              label: const Text('Pilih File'),
            ),
          )
        ],
      ),
    );
  }
}
