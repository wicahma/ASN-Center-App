import 'dart:ffi';
import 'dart:io';

import 'package:asn_center_app/logic/http_request.dart';
import 'package:asn_center_app/logic/storage.dart';
import 'package:asn_center_app/logic/validation.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class SKP extends StatefulWidget {
  const SKP({super.key});

  @override
  State<SKP> createState() => _SKPState();
}

class _SKPState extends State<SKP> {
  bool _isLoading = false;
  List<String> listEkspektasi = [
    "Diatas Ekspektasi",
    "Sesuai Ekspektasi",
    "Dibawah Ekspektasi"
  ];
  String? fileName;
  File? fileResult;
  TextEditingController hasilKinerjaNilai = TextEditingController(),
      perilakuKerjaNilai = TextEditingController(),
      statusPenilai = TextEditingController(),
      penilaiUnorNama = TextEditingController(),
      penilaiJabatan = TextEditingController(),
      penilaiGolongan = TextEditingController(),
      penilaiNipNrp = TextEditingController(),
      penilaiNama = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    hasilKinerjaNilai.dispose();
    perilakuKerjaNilai.dispose();
    statusPenilai.dispose();
    penilaiUnorNama.dispose();
    penilaiJabatan.dispose();
    penilaiGolongan.dispose();
    penilaiNipNrp.dispose();
    penilaiNama.dispose();
    fileResult = null;
    fileName = null;
  }

  Future<void> _addUsulan({required Map<String, dynamic> data}) async {
    try {
      setState(() {
        _isLoading = true;
      });
      String? token = await MainStorage.read("token");
      final response = await Rekues().postData(
        url: "profile/skp2022/update",
        header: {"Authorization": "$token"},
        data: data,
        fileIncluded: true,
        listFieldFilename: ["file_skp"],
        listFilename: [fileName.toString()],
      );
/*
hasilKinerjaNilai
perilakuKerjaNilai
statusPenilai
penilaiUnorNama
penilaiJabatan
penilaiGolongan
penilaiNipNrp
penilaiNama
file_skp
*/
      if (!response.isSuccess) {
        debugPrint(response.message.toString());
        debugPrint(data['jenis']);
        throw Exception(response.errorMessage);
      }

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.greenAccent.shade200,
          content: const Text("Data berhasil ditambahkan!"),
          showCloseIcon: true,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent.shade200,
          content: Text(e.toString()),
          showCloseIcon: true,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SKP"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Form(
          child: Column(
            children: [
              DropdownButtonFormField2(
                hint: Text('Hasil Kinerja',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade800)),
                iconStyleData: const IconStyleData(
                  icon: Icon(Icons.arrow_drop_down_rounded),
                ),
                dropdownStyleData: DropdownStyleData(
                    maxHeight: MediaQuery.of(context).size.height * 2 / 5,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(15))),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(0, 20, 10, 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                isExpanded: true,
                validator: (value) {
                  if (Validation().nullCheck(value.toString())) {
                    return 'Lokasi kursus tidak boleh kosong!';
                  }
                  return null;
                },
                onChanged: (selected) {
                  debugPrint(selected.toString());
                  setState(() {
                    hasilKinerjaNilai.text = selected.toString();
                  });
                },
                items: listEkspektasi.map((e) {
                  return DropdownMenuItem(
                    value: listEkspektasi.indexOf(e) + 1,
                    child: Text(
                      e,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField2(
                hint: Text('Perilaku Kerja',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade800)),
                iconStyleData: const IconStyleData(
                  icon: Icon(Icons.arrow_drop_down_rounded),
                ),
                dropdownStyleData: DropdownStyleData(
                    maxHeight: MediaQuery.of(context).size.height * 2 / 5,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(15))),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(0, 20, 10, 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                isExpanded: true,
                validator: (value) {
                  if (Validation().nullCheck(value.toString())) {
                    return 'Lokasi kursus tidak boleh kosong!';
                  }
                  return null;
                },
                onChanged: (selected) {
                  debugPrint(selected.toString());
                  setState(() {
                    perilakuKerjaNilai.text = selected.toString();
                  });
                },
                items: listEkspektasi.map((e) {
                  return DropdownMenuItem(
                    value: listEkspektasi.indexOf(e) + 1,
                    child: Text(
                      e,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField2(
                hint: Text('Status Penilai',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade800)),
                iconStyleData: const IconStyleData(
                  icon: Icon(Icons.arrow_drop_down_rounded),
                ),
                dropdownStyleData: DropdownStyleData(
                    maxHeight: MediaQuery.of(context).size.height * 2 / 5,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(15))),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(0, 20, 10, 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                isExpanded: true,
                validator: (value) {
                  if (Validation().nullCheck(value.toString())) {
                    return 'Lokasi kursus tidak boleh kosong!';
                  }
                  return null;
                },
                onChanged: (selected) {
                  debugPrint(selected.toString());
                  setState(() {
                    statusPenilai.text = selected.toString();
                  });
                },
                items: ['ASN', 'NON ASN'].map((e) {
                  return DropdownMenuItem(
                    value: ['ASN', 'NON ASN'].indexOf(e) + 1,
                    child: Text(
                      e,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: penilaiUnorNama,
                obscureText: false,
                validator: (value) {
                  if (Validation().nullCheck(value)) {
                    return 'Unit Organisasi Penilai tidak boleh kosong!';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  labelText: 'Unit Organisasi Penilai',
                ),
                cursorColor: Colors.white,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: penilaiJabatan,
                obscureText: false,
                validator: (value) {
                  if (Validation().nullCheck(value)) {
                    return 'Nama Jabatan Penilai Penilai tidak boleh kosong!';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  labelText: 'Nama Jabatan Penilai',
                ),
                cursorColor: Colors.white,
              ),
              const SizedBox(height: 15),
              // NOTE - Undone
              DropdownButtonFormField2(
                hint: Text('Golongan Penilai',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade800)),
                iconStyleData: const IconStyleData(
                  icon: Icon(Icons.arrow_drop_down_rounded),
                ),
                dropdownStyleData: DropdownStyleData(
                    maxHeight: MediaQuery.of(context).size.height * 2 / 5,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(15))),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(0, 20, 10, 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                isExpanded: true,
                validator: (value) {
                  if (Validation().nullCheck(value.toString())) {
                    return 'Golongan Penilai tidak boleh kosong!';
                  }
                  return null;
                },
                onChanged: (selected) {
                  debugPrint(selected.toString());
                  setState(() {
                    statusPenilai.text = selected.toString();
                  });
                },
                items: ['ASN', 'NON ASN'].map((e) {
                  return DropdownMenuItem(
                    value: (listEkspektasi.indexOf(e) + 1).toString(),
                    child: Text(
                      e,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: penilaiNipNrp,
                obscureText: false,
                validator: (value) {
                  if (Validation().nullCheck(value)) {
                    return 'NIP Penilai tidak boleh kosong!';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  labelText: 'NIP Penilai Penilai',
                ),
                cursorColor: Colors.white,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: penilaiNama,
                obscureText: false,
                validator: (value) {
                  if (Validation().nullCheck(value)) {
                    return 'Nama Penilai tidak boleh kosong!';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  labelText: 'Nama Penilai',
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
                        style: const TextStyle(height: 1, color: Colors.white),
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
                    backgroundColor: Theme.of(context).colorScheme.surfaceTint,
                  ),
                  onPressed: _isLoading
                      ? null
                      : () async {
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
                              path: file.path, listType: ['pdf'])) {
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
                              size: file.lengthSync(), maxSize: 1)) {
                            FilePicker.platform.clearTemporaryFiles();
                            if (!context.mounted) return;
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.redAccent.shade200,
                                content:
                                    const Text("Ukuran file lebih dari 1Mb!"),
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
