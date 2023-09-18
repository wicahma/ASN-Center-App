import 'package:asn_center_app/components/modal_file_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardListDiklat extends StatefulWidget {
  final Map<String, dynamic> data;
  final String dataName;
  final String id;
  final String title;
  final String subtitle_1;
  final String? subtitle_2;
  final String tanggalMulai;
  final String? tanggalSelesai;
  final List<dynamic>? path;
  final String cardType;
  final String url;

  const CardListDiklat({
    super.key,
    required this.data,
    this.path = const [],
    required this.cardType,
    required this.dataName,
    required this.id,
    required this.title,
    required this.subtitle_1,
    this.subtitle_2,
    required this.tanggalMulai,
    this.tanggalSelesai,
    required this.url,
  });

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
                    if ("riwayat".contains(widget.cardType))
                      Card(
                        elevation: 0,
                        color: Theme.of(context).colorScheme.primary,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: [
                            if (widget.path != null) ...[
                              for (int i = 0; i < widget.path!.last.length; i++)
                                ListTile(
                                  onLongPress: () async {
                                    await Clipboard.setData(ClipboardData(
                                        text: widget.path!.last['dok_uri']
                                            .elementAt(i)
                                            .toString()));
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor:
                                            Colors.blueAccent.shade200,
                                        content:
                                            const Text("Data berhasil dicopy!"),
                                        showCloseIcon: true,
                                      ),
                                    );
                                  },
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 0),
                                  title: Text(
                                      widget.path!.last.keys
                                          .elementAt(i)
                                          .toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      )),
                                  subtitle: Text(
                                    widget.path!.last.values
                                        .elementAt(i)
                                        .toString(),
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer,
                                    ),
                                  ),
                                )
                            ] else ...[
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Dokumen tidak ada!",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ]
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
                            widget.title,
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
                            widget.subtitle_1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                height: 1,
                                fontSize: 11,
                                fontWeight: FontWeight.w500),
                          ),
                          widget.subtitle_2 != null
                              ? Text(
                                  widget.subtitle_2!,
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
                                      widget.tanggalMulai,
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
                                  widget.tanggalSelesai != null
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 3),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Colors.white,
                                          ),
                                          child: Text(
                                            widget.tanggalSelesai!,
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
                          onPressed: () {
                            if ("riwayat".contains(widget.cardType) &&
                                widget.path == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  duration: Duration(milliseconds: 500),
                                  backgroundColor: Colors.red,
                                  content: Text("Dokumen tidak tersedia!"),
                                  showCloseIcon: true,
                                ),
                              );
                            } else {
                              showModalBottomSheet(
                                  showDragHandle: false,
                                  isScrollControlled: true,
                                  enableDrag: false,
                                  context: context,
                                  builder: (context) => ModalFileView(
                                        namaFile: "riwayat"
                                                .contains(widget.cardType)
                                            ? "Riwayat-${widget.path!.last['id']}.pdf"
                                            : "Usulan-${widget.data['id']}.pdf",
                                        type: widget.dataName,
                                        url: widget.url,
                                      ));
                            }
                          },
                          icon: const Icon(Icons.remove_red_eye_rounded)),
                    ],
                  )
                ],
              )),
        ));
  }
}
