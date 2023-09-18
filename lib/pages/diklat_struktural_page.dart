import 'dart:convert';

import 'package:asn_center_app/components/card_list_diklat.dart';
import 'package:asn_center_app/components/dialog_info.dart';
import 'package:asn_center_app/components/dialog_upload_sertif.dart';
import 'package:asn_center_app/components/loading.dart';
import 'package:asn_center_app/logic/http_request.dart';
import 'package:asn_center_app/logic/storage.dart';
import 'package:flutter/material.dart';

class DiklatStrukturalPage extends StatefulWidget {
  const DiklatStrukturalPage({super.key});

  @override
  State<DiklatStrukturalPage> createState() => _DiklatStrukturalPageState();
}

class _DiklatStrukturalPageState extends State<DiklatStrukturalPage> {
  List<dynamic> _refDiklatData = [];
  List<dynamic>? _riwayatData;
  List<dynamic>? _usulanData;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initRequest();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _initRequest() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await _getRefJenis();
      await _getRiwayatDiklat();
      await _getUsulanDiklat();
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
      final response = await Rekues()
          .getData(url: "profile/diklat_struktural/ref_jenis", header: {
        "Authorization": "$token",
      });

      if (!response.isSuccess) throw Exception("Data Ref Jenis gagal diambil!");

      setState(() {
        _refDiklatData = response.data;
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

  Future<void> _getUsulanDiklat() async {
    try {
      String? token = await MainStorage.read("token");
      final response = await Rekues()
          .getData(url: "profile/diklat_struktural/usulan/list", header: {
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

  Future<void> _getRiwayatDiklat() async {
    try {
      String? token = await MainStorage.read("token");
      final response = await Rekues()
          .getData(url: "profile/diklat_struktural/list", header: {
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
                                title: "Informasi & Jenis Diklat",
                                description:
                                    "Diklat Struktural adalah diklat yang diberikan kepada Pegawai Negeri Sipil (PNS) untuk mempersiapkan diri dalam melaksanakan tugas, fungsi, dan kewajiban jabatan fungsionalnya.",
                                dataName: const ["nama", "id ", "efile_kode"],
                                listData: _refDiklatData,
                              );
                            }))
                  },
                  icon: const Icon(Icons.info_outline_rounded),
                ),
                const SizedBox(
                  width: 5,
                )
              ],
              title: const Text("Diklat Struktural"),
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
                      builder: (BuildContext context) => DialogUploadSertif(
                            refJenisKursus: _refDiklatData,
                            isUploading: (status) => isUploading = status,
                          ));
                }),
            body: TabBarView(children: [
              RefreshIndicator(
                onRefresh: () => _getRiwayatDiklat(),
                child: Card(
                  child: ListView.builder(
                    itemCount: _riwayatData?.length ?? 0,
                    itemBuilder: (context, index) {
                      var data = _riwayatData?[index];
                      var path = jsonDecode(data['path']).values.toList();
                      return CardListDiklat(
                        data: data,
                        path: path,
                        cardType: 'riwayat',
                      );
                    },
                  ),
                ),
              ),
              RefreshIndicator(
                onRefresh: () => _getUsulanDiklat(),
                child: Card(
                  child: ListView.builder(
                    itemCount: _usulanData?.length ?? 0,
                    itemBuilder: (context, index) {
                      var data = _usulanData?[index];
                      return CardListDiklat(
                        data: data,
                        cardType: 'usulan',
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
