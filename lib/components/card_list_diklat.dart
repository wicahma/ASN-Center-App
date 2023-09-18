import 'package:asn_center_app/logic/http_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardListDiklat extends StatefulWidget {
  final Map<String, dynamic> data;
  final List<dynamic> path;
  final String cardType;

  const CardListDiklat(
      {super.key,
      required this.data,
      this.path = const [],
      required this.cardType});

  @override
  State<CardListDiklat> createState() => _CardListDiklatState();
}

class _CardListDiklatState extends State<CardListDiklat> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Card(
        color: Theme.of(context).colorScheme.surface,
        elevation: 15,
        shadowColor: Colors.grey.withOpacity(0.5),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => showDialog<String>(
            barrierColor: Colors.black.withOpacity(0.3),
            context: context,
            builder: (BuildContext context) => AlertDialog(
              clipBehavior: Clip.antiAlias,
              scrollable: true,
              titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              title: const Text("Detail File"),
              contentPadding: const EdgeInsets.all(0),
              content: SizedBox(
                height: MediaQuery.of(context).size.height / 2.5,
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  children: [
                    !"riwayat".contains(widget.cardType)
                        ? const SizedBox()
                        : Card(
                            elevation: 0,
                            color: Theme.of(context).colorScheme.primary,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: [
                                for (int i = 0;
                                    i < widget.path.last.length;
                                    i++)
                                  ListTile(
                                    onLongPress: () async {
                                      await Clipboard.setData(ClipboardData(
                                          text: widget.path.last['dok_uri']
                                              .elementAt(i)
                                              .toString()));
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor:
                                              Colors.blueAccent.shade200,
                                          content: const Text(
                                              "Data berhasil dicopy!"),
                                          showCloseIcon: true,
                                        ),
                                      );
                                    },
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 0),
                                    title: Text(
                                        widget.path.last.keys
                                            .elementAt(i)
                                            .toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        )),
                                    subtitle: Text(
                                      widget.path.last.values
                                          .elementAt(i)
                                          .toString(),
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondaryContainer,
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          ),
                    for (int i = 0; i < widget.data.length; i++)
                      !"path".contains(widget.data.keys.elementAt(i).toString())
                          ? ListTile(
                              onLongPress: () async {
                                await Clipboard.setData(ClipboardData(
                                    text: widget.data.values
                                        .elementAt(i)
                                        .toString()));
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.blueAccent.shade200,
                                    content:
                                        const Text("Data berhasil dicopy!"),
                                    showCloseIcon: true,
                                  ),
                                );
                              },
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 0),
                              title: Text(
                                  widget.data.keys.elementAt(i).toString()),
                              subtitle: Text(
                                  widget.data.values.elementAt(i).toString()),
                            )
                          : const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "riwayat".contains(widget.cardType)
                                ? widget.data['latihanStrukturalNama']
                                : widget.data['jenisKompetensi'],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 18,
                                height: 1,
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${widget.data['institusiPenyelenggara']} - ${widget.data['jumlahJam']} Jam",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                height: 1,
                                fontSize: 11,
                                fontWeight: FontWeight.w500),
                          ),
                          "riwayat".contains(widget.cardType)
                              ? Text(
                                  widget.path.last['dok_nama'],
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      height: 1,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400),
                                )
                              : const SizedBox(),
                          const SizedBox(
                            height: 10,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 3),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white,
                                    ),
                                    child: Text(
                                      widget.data['tanggal'],
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  "riwayat".contains(widget.cardType)
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 3),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Colors.white,
                                          ),
                                          child: Text(
                                            widget.data['tanggalSelesai'],
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        )
                                      : Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 3),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: "Menunggu verifikasi"
                                                      .contains(
                                                          widget.data['status'])
                                                  ? Colors.lightBlue
                                                  : Colors.lightGreen),
                                          child: Text(
                                            widget.data['status'],
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                ]),
                          )
                        ]),
                  ),
                  Row(
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 80),
                        child: TextButton(
                          onPressed: null,
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Theme.of(context).colorScheme.primary),
                              foregroundColor:
                                  const MaterialStatePropertyAll(Colors.white)),
                          child: Text(
                            "ID - ${widget.data['id']}",
                            overflow: TextOverflow.ellipsis,
                          ),
                          // style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      IconButton.filled(
                          iconSize: 25,
                          onPressed: () {
                            setState(() {
                              _isLoading = true;
                            });
                            Rekues()
                                .downloadEfile(
                                    url: "riwayat".contains(widget.cardType)
                                        ? "efile/siasn_dokumen?filePath=${widget.path.last['dok_uri']}"
                                        : "profile/diklat_struktural/usulan/sertifikat/${widget.data['id']}")
                                .then((value) {
                              setState(() {
                                _isLoading = false;
                              });
                              if (!value) {
                                return ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.redAccent.shade200,
                                    content:
                                        const Text("Gagal mengunduh file!"),
                                    showCloseIcon: true,
                                  ),
                                );
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text(
                                      "Berhasil mengunduh file ${"riwayat".contains(widget.cardType) ? widget.path.last['dok_nama'] : widget.data['sertifikat_path_lokal'].split('/').last}!"),
                                  showCloseIcon: true,
                                ),
                              );
                            });
                          },
                          icon: SizedBox(
                            height: 25,
                            width: 25,
                            child: _isLoading
                                ? CircularProgressIndicator(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    strokeWidth: 1,
                                  )
                                : const Icon(Icons.download, size: 25),
                          ))
                    ],
                  )
                ],
              )),
        ));
  }
}
