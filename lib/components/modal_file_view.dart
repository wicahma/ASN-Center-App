import 'dart:async';
import 'dart:io';
import 'package:asn_center_app/components/loading.dart';
import 'package:asn_center_app/logic/http_request.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:asn_center_app/logic/storage.dart';
import 'package:flutter/material.dart';

class ModalFileView extends StatefulWidget {
  final String namaFile;
  final String type;
  final String url;
  const ModalFileView(
      {super.key,
      required this.namaFile,
      required this.type,
      required this.url});

  @override
  State<ModalFileView> createState() => _ModalFileViewState();
}

class _ModalFileViewState extends State<ModalFileView> {
  Completer<PDFViewController> _controllerPDF = Completer<PDFViewController>();
  int? pages = 0, currentPage = 0;
  bool _isLoading = false;
  bool _unduhLoading = false;
  late File fileData;

  @override
  void initState() {
    super.initState();
    _getDataView();
  }

  @override
  void dispose() {
    super.dispose();
    _controllerPDF = Completer<PDFViewController>();
    fileData = File("");
  }

  Future<bool> _getDataView() async {
    try {
      setState(() {
        _isLoading = true;
      });
      String? token = await MainStorage.read("token"),
          downloadDir = await MainStorage.read("download_dir");
      bool isFileExist = await File("$downloadDir/${widget.namaFile}").exists();

      File file = File("$downloadDir/${widget.namaFile}");
      if (isFileExist) {
        debugPrint("========File exist========");
        setState(() {
          fileData = file;
        });
        return true;
      }
      final response = await http.get(
          Uri.parse("https://asncenter.rembangkab.go.id/api/v1/${widget.url}"),
          headers: {"Authorization": "$token"});
      var bytes = response.bodyBytes;
      File urlFile = await file.writeAsBytes(bytes);

      setState(() {
        fileData = urlFile;
      });
      return true;
    } catch (e) {
      if (!context.mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent.shade200,
          content: Text(e.toString()),
          showCloseIcon: true,
        ),
      );
      return false;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close)),
              TextButton.icon(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all<Color>(
                        Colors.white.withOpacity(0.2)),
                    splashFactory: InkRipple.splashFactory,
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).colorScheme.background),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).colorScheme.primary),
                  ),
                  onPressed: () {
                    setState(() {
                      _unduhLoading = true;
                    });
                    Rekues().downloadEfile(url: widget.url).then((value) {
                      setState(() {
                        _unduhLoading = false;
                      });
                      if (!value) {
                        return ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.redAccent.shade200,
                            content: const Text("Gagal mengunduh file!"),
                            showCloseIcon: true,
                          ),
                        );
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                          content: Text(
                              "Berhasil mengunduh file ${widget.namaFile}!"),
                          showCloseIcon: true,
                        ),
                      );
                    });
                  },
                  icon: SizedBox(
                      height: 25,
                      width: 25,
                      child: _unduhLoading
                          ? CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.background,
                              strokeWidth: 1,
                            )
                          : const Icon(Icons.download, size: 25)),
                  label: SizedBox(
                    width: 100,
                    child: Text(
                      "Unduh ${widget.namaFile}",
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
            ],
          ),
        ),
        _isLoading
            ? SizedBox(
                height: MediaQuery.of(context).size.height * 1 / 2,
                child: Loading(loadingState: _isLoading))
            : Card(
                elevation: 10,
                clipBehavior: Clip.antiAlias,
                margin: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 4 / 6,
                    maxWidth: MediaQuery.of(context).size.width,
                  ),
                  child: "pdf".contains(
                          widget.namaFile.split('.').last.toLowerCase())
                      ? PDFView(
                          filePath: fileData.path,
                          fitEachPage: true,
                          enableSwipe: true,
                          swipeHorizontal: false,
                          autoSpacing: true,
                          pageSnap: true,
                          defaultPage: currentPage!,
                          fitPolicy: FitPolicy.WIDTH,
                          nightMode: false,
                          preventLinkNavigation: true,
                          onRender: (pagesPDF) {
                            pages = pagesPDF;
                          },
                          onError: (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.redAccent.shade200,
                                content: Text(error.toString()),
                                showCloseIcon: true,
                              ),
                            );
                          },
                          onPageError: (page, error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.redAccent.shade200,
                                content: Text(error.toString()),
                                showCloseIcon: true,
                              ),
                            );
                          },
                          onViewCreated: (PDFViewController pdfViewController) {
                            if (!_controllerPDF.isCompleted) {
                              _controllerPDF.complete(pdfViewController);
                            }
                          },
                        )
                      : SingleChildScrollView(
                          child: Image.file(
                            fileData,
                            width: double.maxFinite,
                            fit: BoxFit.fill,
                          ),
                        ),
                )),
      ],
    );
  }
}
