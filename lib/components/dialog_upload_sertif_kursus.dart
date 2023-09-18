import 'dart:io';
import 'package:asn_center_app/components/loading.dart';
import 'package:asn_center_app/logic/http_request.dart';
import 'package:asn_center_app/logic/storage.dart';
import 'package:asn_center_app/logic/validation.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DialogUploadSertifKursus extends StatefulWidget {
  final List<dynamic> refJenisKursus;
  final List<dynamic> refLokasiKursus;
  final Function(bool status) isUploading;
  const DialogUploadSertifKursus(
      {super.key,
      required this.refJenisKursus,
      required this.isUploading,
      required this.refLokasiKursus});

  @override
  State<DialogUploadSertifKursus> createState() =>
      _DialogUploadSertifKursusState();
}

class _DialogUploadSertifKursusState extends State<DialogUploadSertifKursus> {
  File? fileResult;
  bool _isLoading = false;
  String? fileName;
  String? lokasi;
  TextEditingController startDate = TextEditingController(),
      endDate = TextEditingController(),
      jenis = TextEditingController(),
      institusiPenyelenggara = TextEditingController(),
      nomorSertifikat = TextEditingController(),
      tahunDiklat = TextEditingController(),
      lokasiSearch = TextEditingController(),
      namaKursus = TextEditingController(),
      durasiJam = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    fileResult = null;
    fileName = null;
    lokasi = null;
    startDate.dispose();
    endDate.dispose();
    jenis.dispose();
    institusiPenyelenggara.dispose();
    nomorSertifikat.dispose();
    tahunDiklat.dispose();
    durasiJam.dispose();
    lokasiSearch.dispose();
    namaKursus.dispose();
  }

  Future<void> _addUsulan({required Map<String, dynamic> data}) async {
    try {
      setState(() {
        _isLoading = true;
      });
      String? token = await MainStorage.read("token");
      final response = await Rekues().postData(
        url: "profile/kursus/usulan/create",
        header: {"Authorization": "$token"},
        data: data,
        fileIncluded: true,
        listFieldFilename: ["file_sertifikat"],
        listFilename: [fileName.toString()],
      );

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
    return AlertDialog(
      scrollable: true,
      title: const Text(
        'Tambah Riwayat',
        style: TextStyle(height: 1),
        textAlign: TextAlign.left,
      ),
      actions: [
        TextButton(
          onPressed: _isLoading
              ? null
              : () {
                  FilePicker.platform.clearTemporaryFiles();
                  Navigator.pop(context);
                },
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: _isLoading
              ? null
              : () {
                  if (!_formKey.currentState!.validate()) return;
                  if (fileResult == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.redAccent,
                        content: Text('File belum dipilih!'),
                      ),
                    );
                    return;
                  }
                  debugPrint(_formKey.toString());
                  widget.isUploading(true);
                  _addUsulan(data: {
                    "jenis": jenis.text,
                    "penyelenggara": institusiPenyelenggara.text,
                    "nomor_sertifikat": nomorSertifikat.text,
                    "tanggal_mulai": startDate.text,
                    "tanggal_selesai": endDate.text,
                    "tahun": tahunDiklat.text,
                    "durasi_jam": durasiJam.text,
                    "file_sertifikat": fileResult,
                    "lokasi": lokasi,
                    "nama_kursus": namaKursus.text,
                  }).then((value) => widget.isUploading(false));
                },
          child: const Text('Upload'),
        ),
      ],
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 2 / 5,
        child: SingleChildScrollView(
          child: _isLoading
              ? Loading(loadingState: _isLoading)
              : Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField2(
                        hint: Text('Pilih Jenis Kursus',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.grey.shade800)),
                        iconStyleData: const IconStyleData(
                          icon: Icon(Icons.arrow_drop_down_rounded),
                        ),
                        dropdownStyleData: DropdownStyleData(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15))),
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(0, 20, 10, 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        isExpanded: true,
                        validator: (value) {
                          if (Validation().nullCheck(value.toString())) {
                            return 'Jenis kursus tidak boleh kosong!';
                          }
                          return null;
                        },
                        onChanged: (selected) {
                          debugPrint(selected.toString());
                          setState(() {
                            jenis.text = selected.toString();
                          });
                        },
                        items: widget.refJenisKursus.map((e) {
                          return DropdownMenuItem(
                            value: e['id '],
                            child: Text(
                              "${e['id ']} - ${e['nama']}",
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
                        dropdownSearchData: DropdownSearchData(
                          searchController: lokasiSearch,
                          searchInnerWidgetHeight: 60,
                          searchInnerWidget: Container(
                            height: 60,
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: TextFormField(
                              expands: true,
                              maxLines: null,
                              controller: lokasiSearch,
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
                        hint: Text('Pilih Lokasi Kursus',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.grey.shade800)),
                        iconStyleData: const IconStyleData(
                          icon: Icon(Icons.arrow_drop_down_rounded),
                        ),
                        dropdownStyleData: DropdownStyleData(
                            maxHeight:
                                MediaQuery.of(context).size.height * 2 / 5,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15))),
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(0, 20, 10, 20),
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
                            lokasi = selected.toString();
                          });
                        },
                        items: widget.refLokasiKursus.map((e) {
                          return DropdownMenuItem(
                            value: e['id'],
                            child: Text(
                              e['text'],
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
                        controller: namaKursus,
                        obscureText: false,
                        validator: (value) {
                          if (Validation().nullCheck(value)) {
                            return 'Nama Kursus tidak boleh kosong!';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          labelText: 'Nama Kursus',
                        ),
                        cursorColor: Colors.white,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: institusiPenyelenggara,
                        obscureText: false,
                        validator: (value) {
                          if (Validation().nullCheck(value)) {
                            return 'Institusi tidak boleh kosong!';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          labelText: 'Institusi Penyelenggara',
                        ),
                        cursorColor: Colors.white,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: nomorSertifikat,
                        obscureText: false,
                        validator: (value) {
                          if (Validation().nullCheck(value)) {
                            return 'Nomor sertif tidak boleh kosong!';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          labelText: 'Nomor Sertifikat',
                        ),
                        cursorColor: Colors.white,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: tahunDiklat,
                        obscureText: false,
                        validator: (value) {
                          if (Validation().nullCheck(value)) {
                            return 'Tahun diklat tidak boleh kosong!';
                          }
                          if (Validation().isNumeric(value!)) {
                            return 'Tahun diklat harus berupa angka!';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          labelText: 'Tahun Diklat',
                        ),
                        keyboardType: TextInputType.number,
                        cursorColor: Colors.white,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        readOnly: true,
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          DateTime? newSelectedDate = await showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  DatePickerDialog(
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100),
                                    initialDate: DateTime.now(),
                                  ));
                          if (newSelectedDate == null) return;
                          setState(() {
                            startDate.text =
                                DateFormat('dd-MM-yyy').format(newSelectedDate);
                          });
                        },
                        obscureText: false,
                        validator: (value) {
                          if (Validation().nullCheck(value)) {
                            return 'Tanggal mulai tidak boleh kosong!';
                          }
                          return null;
                        },
                        controller: startDate,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.date_range_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          labelText: 'Tanggal Mulai',
                        ),
                        cursorColor: Colors.white,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        readOnly: true,
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          DateTime? newSelectedDate = await showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  DatePickerDialog(
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100),
                                    initialDate: DateTime.now(),
                                  ));
                          if (newSelectedDate == null) return;
                          setState(() {
                            endDate.text =
                                DateFormat('dd-MM-yyy').format(newSelectedDate);
                          });
                        },
                        obscureText: false,
                        validator: (value) {
                          if (Validation().nullCheck(value)) {
                            return 'Tanggal selesai tidak boleh kosong!';
                          }
                          return null;
                        },
                        controller: endDate,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.date_range_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          labelText: 'Tanggal Selesai',
                        ),
                        cursorColor: Colors.white,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: durasiJam,
                        obscureText: false,
                        validator: (value) {
                          if (Validation().nullCheck(value)) {
                            return 'Durasi tidak boleh kosong!';
                          }
                          if (Validation().isNumeric(value!)) {
                            return 'Durasi harus berupa angka!';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          labelText: 'Durasi Jam',
                        ),
                        keyboardType: TextInputType.number,
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
                                        backgroundColor:
                                            Colors.redAccent.shade200,
                                        content: const Text(
                                            "User canceled the picker!"),
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
                                        backgroundColor:
                                            Colors.redAccent.shade200,
                                        content: const Text(
                                            "Jenis File tidak didukung!"),
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
                                        backgroundColor:
                                            Colors.redAccent.shade200,
                                        content: const Text(
                                            "Ukuran file lebih dari 1Mb!"),
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
                                      backgroundColor:
                                          Colors.greenAccent.shade200,
                                      content:
                                          const Text("Data berhasil dipilih!"),
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
      ),
    );
  }
}
