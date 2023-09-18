import 'package:asn_center_app/components/modal_file_view.dart';
import 'package:asn_center_app/logic/http_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardListFile extends StatefulWidget {
  final String namaDokumen, fileStatus, fileTahun, namaFile;
  final Map<String, dynamic> mainData;
  const CardListFile(
      {super.key,
      this.namaDokumen = "nama-dokumen",
      this.fileStatus = "status",
      this.fileTahun = "tahun",
      this.namaFile = "nama-file",
      required this.mainData});

  @override
  State<CardListFile> createState() => _CardListFileState();
}

class _CardListFileState extends State<CardListFile> {
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
                    scrollable: true,
                    titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    title: const Text("Detail File"),
                    contentPadding: const EdgeInsets.all(0),
                    content: SizedBox(
                      height: MediaQuery.of(context).size.height / 2.5,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        itemCount: widget.mainData.length,
                        itemBuilder: (context, index) {
                          String key =
                              widget.mainData.keys.elementAt(index).toString();
                          String value = widget.mainData[key].toString();
                          return ListTile(
                            onLongPress: () async {
                              debugPrint("key: $key");
                              await Clipboard.setData(
                                  ClipboardData(text: value));
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.blueAccent.shade200,
                                  content: const Text("Data berhasil dicopy!"),
                                  showCloseIcon: true,
                                ),
                              );
                            },
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 0),
                            title: Text(key.toUpperCase()),
                            subtitle: Text(value.toString() == "" ||
                                    value.toString() == "null"
                                ? "-"
                                : value.toString()),
                          );
                        },
                      ),
                    ),
                  ),
                ),
            child: Stack(
              children: [
                Positioned(
                  top: -25,
                  left: -25,
                  child: Card(
                      clipBehavior: Clip.antiAlias,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                      color: Colors.green.shade200,
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              showDragHandle: false,
                              isScrollControlled: true,
                              enableDrag: false,
                              context: context,
                              builder: (context) => ModalFileView(
                                    namaFile: widget.namaFile,
                                    type: "efile",
                                    url: "efile/download/${widget.namaFile}",
                                  ));
                        },
                        splashColor: Colors.green,
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Icon(
                            widget.namaFile.contains(".pdf")
                                ? Icons.picture_as_pdf_outlined
                                : Icons.image_rounded,
                            size: 30,
                            color: Colors.green.shade800,
                          ),
                        ),
                      )),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: Text(widget.namaDokumen,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      height: 1)),
                            ),
                            const SizedBox(height: 15),
                            Text(widget.namaFile,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12)),
                            Text(widget.fileTahun,
                                style:
                                    const TextStyle(fontSize: 12, height: 1)),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 15),
                          Card(
                            color: "Terverifikasi".contains(widget.fileStatus)
                                ? Colors.lightGreen.shade200
                                : Colors.red.shade200,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              child: Text(
                                widget.fileStatus,
                                style: TextStyle(
                                    color: "Terverifikasi"
                                            .contains(widget.fileStatus)
                                        ? Colors.lightGreen.shade900
                                        : Colors.red.shade900),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          IconButton.filled(
                              onPressed: () {
                                showModalBottomSheet(
                                    showDragHandle: false,
                                    isScrollControlled: true,
                                    enableDrag: false,
                                    context: context,
                                    builder: (context) => ModalFileView(
                                          namaFile: widget.namaFile,
                                          type: "efile",
                                          url:
                                              "efile/download/${widget.namaFile}",
                                        ));
                              },
                              icon: const Icon(Icons.remove_red_eye_rounded))
                        ],
                      )
                    ],
                  ),
                ),
              ],
            )));
  }
}
