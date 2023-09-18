import 'dart:io';
import 'package:asn_center_app/components/loading.dart';
import 'package:asn_center_app/logic/http_request.dart';
import 'package:asn_center_app/logic/storage.dart';
import 'package:asn_center_app/logic/validation.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class DialogBuilder extends StatefulWidget {
  final List<dynamic> refKodeFile;
  const DialogBuilder({super.key, required this.refKodeFile});
  @override
  State<DialogBuilder> createState() => _DialogBuilderState();
}

class _DialogBuilderState extends State<DialogBuilder> {
  bool _isLoading = false;
  File? fileResult;
  String? fileName;
  final TextEditingController searchJenisDokumen = TextEditingController();
  final TextEditingController tahun = TextEditingController();
  String? idDokumen;
  @override
  void initState() {
    super.initState();
    fileResult = null;
    fileName = null;
    searchJenisDokumen.clear();
    tahun.clear();
  }

  @override
  void dispose() {
    fileResult = null;
    fileName = null;
    searchJenisDokumen.dispose();
    tahun.dispose();
    super.dispose();
  }

  Future<void> _uploadEfile() async {
    try {
      setState(() {
        _isLoading = true;
      });
      String? token = await MainStorage.read("token");
      if (idDokumen == null || tahun.text.isEmpty || fileResult == null) {
        throw Exception("Kode File, Tahun & File tidak boleh kosong!");
      }

      final response = await Rekues().postData(
          url: "efile/upload",
          header: {"Authorization": "$token"},
          data: {
            "dokumen": fileResult,
            "id_jenis_dokumen": idDokumen,
            "tahun": tahun.text,
          },
          fileIncluded: true,
          listFieldFilename: ["dokumen"],
          listFilename: [fileName.toString()]);

      if (!context.mounted) return;
      debugPrint(response.isSuccess.toString());
      if (!response.isSuccess) throw Exception("Gagal mengupload file!");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.greenAccent.shade200,
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
    } finally {
      setState(() {
        _isLoading = true;
      });
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
      content: SizedBox(
        height: 300,
        child: _isLoading
            ? Loading(loadingState: _isLoading)
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pilih file yang akan diupload',
                      style: TextStyle(height: 1),
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField2(
                      dropdownSearchData: DropdownSearchData(
                        searchController: searchJenisDokumen,
                        searchInnerWidgetHeight: 60,
                        searchInnerWidget: Container(
                          height: 60,
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: TextFormField(
                            expands: true,
                            maxLines: null,
                            controller: searchJenisDokumen,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              hintText: 'Cari Jenis Kursus...',
                              hintStyle: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w400),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        searchMatchFn: (item, searchValue) {
                          return item.child
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchValue.toLowerCase()) ||
                              item.value.toString().contains(searchValue);
                        },
                      ),
                      hint: const Text(
                        "Jenis Kursus",
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                      isExpanded: true,
                      dropdownStyleData: DropdownStyleData(
                          maxHeight: MediaQuery.of(context).size.height * 1 / 3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          )),
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(0, 20, 10, 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      validator: (value) {
                        if (Validation().nullCheck(value.toString())) {
                          return 'Jenis kursus tidak boleh kosong!';
                        }
                        return null;
                      },
                      onChanged: (selected) {
                        setState(() {
                          idDokumen = selected.toString();
                        });
                      },
                      onMenuStateChange: (isOpen) {
                        if (!isOpen) {
                          searchJenisDokumen.clear();
                        }
                      },
                      value: idDokumen,
                      isDense: true,
                      items: widget.refKodeFile
                          .map((e) => DropdownMenuItem(
                                value: e['id'],
                                child: Text(
                                  "${e['id']} - ${e['nama']}",
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400),
                                ),
                              ))
                          .toList(),
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Text(
                              fileName ?? "Belum ada file yang dipilih",
                              style: const TextStyle(
                                  height: 1, color: Colors.white),
                            )),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          backgroundColor:
                              Theme.of(context).colorScheme.surfaceTint,
                        ),
                        onPressed: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                            allowMultiple: false,
                            allowedExtensions: ['pdf', 'jpg', 'jpeg'],
                            type: FileType.custom,
                          );

                          if (result == null) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.redAccent.shade200,
                                content:
                                    const Text("User canceled the picker!"),
                                showCloseIcon: true,
                              ),
                            );
                            return;
                          }

                          File file = File(result.files.single.path!);

                          // Type Checker
                          if (!Validation().isTypeCorrect(
                              path: file.path,
                              listType: ['pdf', 'jpg', 'jpeg'])) {
                            FilePicker.platform.clearTemporaryFiles();
                            if (!context.mounted) return;
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.redAccent.shade200,
                                content:
                                    const Text("Jenis File tidak didukung!"),
                                showCloseIcon: true,
                              ),
                            );
                            return;
                          }

                          // Size Checker
                          if (!Validation().isSizeCorrect(
                              size: file.lengthSync(), maxSize: 2)) {
                            FilePicker.platform.clearTemporaryFiles();
                            if (!context.mounted) return;
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.redAccent.shade200,
                                content:
                                    const Text("Ukuran file lebih dari 2Mb!"),
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
              ),
      ),
    );
  }
}
