import 'package:asn_center_app/components/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DialogInfo extends StatefulWidget {
  final String title;
  final String description;
  final List<String> dataName;
  final List<dynamic> listData;
  const DialogInfo(
      {super.key,
      required this.listData,
      required this.title,
      required this.description,
      required this.dataName});

  @override
  State<DialogInfo> createState() => _DialogInfoState();
}

class _DialogInfoState extends State<DialogInfo> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      scrollable: true,
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      contentPadding: const EdgeInsets.all(0),
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Text(widget.description),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 2.5,
            width: MediaQuery.of(context).size.width,
            child: widget.listData.isEmpty
                ? const Center(
                    child: Loading(loadingState: true),
                  )
                : ListView.builder(
                    itemCount: widget.listData.length,
                    itemBuilder: (context, index) {
                      String nama = widget.listData[index][widget.dataName[0]];
                      String id = widget.listData[index][widget.dataName[1]];
                      String necessaryData =
                          widget.listData[index][widget.dataName[2]].toString();
                      return InkWell(
                        onLongPress: () async {
                          debugPrint("key: $id");
                          await Clipboard.setData(
                              ClipboardData(text: "$id - $nama"));
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.blueAccent.shade200,
                              content: const Text("Data berhasil dicopy!"),
                              showCloseIcon: true,
                            ),
                          );
                        },
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 0),
                          title: Text(
                            nama,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle:
                              Text("${widget.dataName[2]} - $necessaryData"),
                          leading: Text(
                            id,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("OK"),
        ),
      ],
    );
  }
}
