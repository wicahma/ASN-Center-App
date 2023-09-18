import 'dart:convert';

import 'package:asn_center_app/components/card_list_diklat.dart';
import 'package:asn_center_app/components/dialog_info.dart';
import 'package:asn_center_app/components/dialog_upload_sertif_diklat.dart';
import 'package:asn_center_app/components/dialog_upload_sertif_kursus.dart';
import 'package:asn_center_app/components/loading.dart';
import 'package:asn_center_app/logic/http_request.dart';
import 'package:asn_center_app/logic/storage.dart';
import 'package:flutter/material.dart';

class KursusPage extends StatefulWidget {
  const KursusPage({super.key});

  @override
  State<KursusPage> createState() => _KursusPageState();
}

class _KursusPageState extends State<KursusPage> {
  List<dynamic> _refKursusData = [];
  List<dynamic> _refKabupatenData = [];
  List<dynamic>? _riwayatData;
  List<dynamic>? _usulanData;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initRequest();
  }

  Future<void> _initRequest() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await _getRefJenis();
      await _getRefKabupaten();
      await _getRiwayatKursus();
      await _getUsulanKursus();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getRefJenis() async {
    try {
      String? token = await MainStorage.read("token");
      final response =
          await Rekues().getData(url: "profile/kursus/ref_jenis", header: {
        "Authorization": "$token",
      });

      if (!response.isSuccess) throw Exception("Data Ref Jenis gagal diambil!");

      setState(() {
        _refKursusData = response.data;
      });
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

  Future<void> _getRefKabupaten() async {
    try {
      String? token = await MainStorage.read("token");
      final response = await Rekues()
          .getData(url: "profile/kursus/ref_kabupaten_kota", header: {
        "Authorization": "$token",
      });

      if (!response.isSuccess) throw Exception("Data Ref Jenis gagal diambil!");
      debugPrint("Data Ref Kabupaten Kota: ${response.data}");
      setState(() {
        _refKabupatenData = response.data;
      });
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

  Future<void> _getUsulanKursus() async {
    try {
      String? token = await MainStorage.read("token");
      final response =
          await Rekues().getData(url: "profile/kursus/usulan/list", header: {
        "Authorization": "$token",
      });

      if (!response.isSuccess) {
        throw Exception("Data Usulan Diklat gagal diambil!");
      }

      setState(() {
        _usulanData = response.data;
      });
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

  Future<void> _getRiwayatKursus() async {
    try {
      String? token = await MainStorage.read("token");
      final response =
          await Rekues().getData(url: "profile/kursus/list", header: {
        "Authorization": "$token",
      });

      if (!response.isSuccess) {
        throw Exception("Data Riwayat Diklat gagal diambil!");
      }

      setState(() {
        _riwayatData = response.data;
      });
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
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  style: ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                      backgroundColor: MaterialStatePropertyAll(
                          Theme.of(context).colorScheme.secondaryContainer)),
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () => {
                    showDialog(
                        context: context,
                        builder: (context) => FutureBuilder<void>(
                            future: _getRefJenis(),
                            builder: (context, AsyncSnapshot<void> snapshot) {
                              return DialogInfo(
                                title: "Informasi Kabupaten Kota",
                                description:
                                    "Data kabupaten kota digunakan untuk memberikan lokasi kepada data kursus terkait.",
                                dataName: const ["text", "id"],
                                listData: _refKabupatenData,
                                customList: (id, nama) {
                                  return ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 0),
                                    title: Text(
                                      nama,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(id),
                                  );
                                },
                              );
                            }))
                  },
                  icon: const Icon(Icons.map_rounded),
                ),
                IconButton(
                  style: ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                      backgroundColor: MaterialStatePropertyAll(
                          Theme.of(context).colorScheme.secondaryContainer)),
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () => {
                    showDialog(
                        context: context,
                        builder: (context) => FutureBuilder<void>(
                            future: _getRefJenis(),
                            builder: (context, AsyncSnapshot<void> snapshot) {
                              return DialogInfo(
                                title: "Informasi & Jenis Kursus",
                                description:
                                    "Kursus meruapakan suatu lembaga pelatihan dari satuan pendidikan non formal. Dan metode pembelajaran berlangsung seperti halnya kegiatan belajar mengajar pada umumnya. Perbedaanya adalah biasanya kusus memepelajari satu keterampilan dan dengan waktu yang sangat singkat.",
                                dataName: const ["nama", "id ", "efile_kode"],
                                listData: _refKursusData,
                              );
                            }))
                  },
                  icon: const Icon(Icons.info_outline_rounded),
                ),
                const SizedBox(
                  width: 5,
                )
              ],
              title: const Text("Kursus"),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: TabBar(
                    indicatorWeight: 5,
                    dividerColor: Colors.transparent,
                    splashBorderRadius: BorderRadius.circular(15),
                    tabs: const [
                      Tab(
                        text: "Riwayat Terverifikasi",
                      ),
                      Tab(
                        text: "Usulan",
                      ),
                    ]),
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
                label: const Text("Tambah Usulan"),
                icon: Icon(
                  Icons.note_add_rounded,
                  size: 30,
                  color: Theme.of(context).colorScheme.surfaceTint,
                ),
                onPressed: () {
                  bool isUploading = true;
                  showDialog<String>(
                      barrierDismissible: isUploading,
                      context: context,
                      builder: (BuildContext context) =>
                          DialogUploadSertifKursus(
                            refJenisKursus: _refKursusData,
                            refLokasiKursus: _refKabupatenData,
                            isUploading: (status) => isUploading = status,
                          ));
                }),
            body: TabBarView(children: [
              RefreshIndicator(
                onRefresh: () => _getRiwayatKursus(),
                child: Card(
                  child: ListView.builder(
                    itemCount: _riwayatData?.length ?? 0,
                    itemBuilder: (context, index) {
                      var data = _riwayatData?[index];
                      List<dynamic>? path;
                      if (data['path'] != null) {
                        path = jsonDecode(data['path']).values.toList();
                      }
                      return CardListDiklat(
                        dataName: "kursus",
                        id: data['id'],
                        title: data['jenisKursusSertifikat'],
                        subtitle_1:
                            "${data['namaKursus']} - ${data['jumlahJam']}",
                        subtitle_2: data['institusiPenyelenggara'],
                        tanggalMulai: data['tanggalKursus'],
                        tanggalSelesai: data['tanggalSelesai'] ?? "-",
                        data: data,
                        path: path,
                        cardType: 'riwayat',
                        url: path == null
                            ? ""
                            : "efile/siasn_dokumen?filePath=${path.last['dok_uri']}",
                      );
                    },
                  ),
                ),
              ),
              RefreshIndicator(
                onRefresh: () => _getUsulanKursus(),
                child: Card(
                  child: ListView.builder(
                    itemCount: _usulanData?.length ?? 0,
                    itemBuilder: (context, index) {
                      var data = _usulanData?[index];
                      return CardListDiklat(
                        dataName: "kursus",
                        id: data['id'],
                        title: data['jenisKursusSertipikat'],
                        subtitle_1:
                            "${data['institusiPenyelenggara']} - ${data['jumlahJam']}",
                        tanggalMulai: data['tanggalKursus'],
                        data: data,
                        cardType: 'usulan',
                        url: "profile/kursus/usulan/sertifikat/${data['id']}",
                      );
                    },
                  ),
                ),
              ),
            ]),
          ),
        ),
        Loading(loadingState: _isLoading)
      ],
    );
  }
}
