import 'dart:convert';
import 'dart:io';
import 'package:asn_center_app/logic/storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_downloader/flutter_downloader.dart';

class Response {
  String? message;
  dynamic data;
  dynamic status;
  bool get isSuccess => status == "success" || status == true;
  String? errorMessage;
  dynamic body;
}

class Rekues {
  final String baseUrl = "https://asncenter.rembangkab.go.id/api/v1/";
  String downloadDir = '/storage/emulated/0/Download/ASN';

  Rekues() {
    MainStorage.read("download_dir").then((value) {
      if (value == null) {
        Directory(downloadDir).createSync(recursive: true);
        MainStorage.write("download_dir", downloadDir);
        return;
      }
      downloadDir = value.toString();
    });
  }

  var getResponse = Response();
  Future<Response> getData(
      {String? url,
      Map<String, dynamic>? data,
      Map<String, String>? header}) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl$url"),
        headers: header,
      );

      Map<String, dynamic> res = jsonDecode(response.body);
      
      getResponse.body = response.body;
      getResponse.status = res['status'];
      getResponse.message = res['message'];
      getResponse.data = res['data'];

      return getResponse;
    } catch (e) {
      debugPrint("Getdata Error : ${e.toString()}");
      getResponse.errorMessage = e.toString();
      return getResponse;
    }
  }

  Future<Response> postData(
      {String? url,
      Map<String, dynamic>? data,
      Map<String, String>? header,
      bool fileIncluded = false,
      List<String> listFieldFilename = const [],
      List<String> listFilename = const []}) async {
    var postResponse = Response();
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse("$baseUrl$url"),
      );

      request.headers.addAll(header ?? {});
      request.fields
          .addAll(data!.map((key, value) => MapEntry(key, value.toString())));

      if (fileIncluded) {
        for (var i = 0; i < listFieldFilename.length; i++) {
          request.files.add(http.MultipartFile(
            listFieldFilename[i],
            data[listFieldFilename[i]].readAsBytes().asStream(),
            data[listFieldFilename[i]].lengthSync(),
            filename: listFilename[i],
          ));
        }
      }

      final sended = await request.send();
      final response = await http.Response.fromStream(sended);

      Map<String, dynamic> res = jsonDecode(response.body);

      postResponse.body = response.body;
      postResponse.message = res['message'];
      postResponse.data = res['data'];
      postResponse.status = res['status'];

      return postResponse;
    } catch (e) {
      debugPrint("Error: ${e.toString()}");
      postResponse.errorMessage = e.toString();
      return postResponse;
    }
  }

  Future<Response> putData(
      {String? url,
      Map<String, dynamic>? data,
      Map<String, String>? header}) async {
    var putResponse = Response();
    try {
      final response = await http.put(
        Uri.parse("$baseUrl$url"),
        headers: header,
        body: data,
      );

      Map<String, dynamic> res = jsonDecode(response.body);

      putResponse.body = response.body;
      putResponse.message = res['message'];
      putResponse.data = res['data'];
      putResponse.status = res['status'];

      return putResponse;
    } catch (e) {
      debugPrint(e.toString());
      putResponse.errorMessage = e.toString();
      return putResponse;
    }
  }

  Future<Response> deleteData(
      {String? url,
      Map<String, dynamic>? data,
      Map<String, String>? header}) async {
    var deleteResponse = Response();
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl$url"),
        headers: header,
      );

      Map<String, dynamic> res = jsonDecode(response.body);

      deleteResponse.body = response.body;
      deleteResponse.message = res['message'];
      deleteResponse.data = res['data'];
      deleteResponse.status = res['status'];

      return deleteResponse;
    } catch (e) {
      debugPrint(e.toString());
      deleteResponse.errorMessage = e.toString();
      return deleteResponse;
    }
  }

  Future<bool> downloadEfile({String? url}) async {
    try {
      String? token = await MainStorage.read("token");
      return await FlutterDownloader.enqueue(
              url: "$baseUrl$url",
              headers: {"Authorization": "$token"},
              savedDir: downloadDir.toString(),
              showNotification: true,
              openFileFromNotification: true,
              saveInPublicStorage: false)
          .then((value) {
        debugPrint("Download success $value");
        return true;
      });
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<Response> patchData(
      {String? url,
      Map<String, dynamic>? data,
      Map<String, String>? header}) async {
    var patchResponse = Response();
    try {
      final response = await http.patch(
        Uri.parse("$baseUrl$url"),
        headers: header,
        body: data,
      );

      Map<String, dynamic> res = jsonDecode(response.body);

      patchResponse.body = response.body;
      patchResponse.message = res['message'];
      patchResponse.data = res['data'];
      patchResponse.status = res['status'];

      return patchResponse;
    } catch (e) {
      debugPrint(e.toString());
      patchResponse.errorMessage = e.toString();
      return patchResponse;
    }
  }
}
