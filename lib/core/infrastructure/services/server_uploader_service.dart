import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:debs_driver_app/core/infrastructure/clients/http_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:mime/mime.dart';

enum UploadedFileType {
  signatureProof('signature_proof'),
  deliveryProof('delivery_proof');

  final String param;

  const UploadedFileType(this.param);
}

@LazySingleton()
class ServerUploaderService {
  ServerUploaderService(this._client);

  final HttpApiClient _client;

  Future<int> uploadFile(
    UploadedFile file,
  ) async {
    log(jsonEncode(_client.api.options.headers));
    log(jsonEncode(file.toJson()));
    final result = await _client.api.post('/files/upload-url', data: file.toJson());

    final data = result.data['data'];

    final uploadedFileResponse = UploadFileResponse.fromJson(data);

   print('headers: ${jsonEncode(uploadedFileResponse.headers)}');
   print('method: ${uploadedFileResponse.method}');
   log('uploadUrl: ${uploadedFileResponse.uploadUrl}');
    final uploadResult = await _client.instance.request(
      uploadedFileResponse.uploadUrl,
      data: file.file.openRead(),
      options: Options(
        method: uploadedFileResponse.method,
        headers: uploadedFileResponse.headers,
      ),
    );
    return uploadedFileResponse.fileId;
  }
}

class UploadedFile {
  UploadedFile({
    required this.file,
    required this.type,
  });

  final File file;
  final UploadedFileType type;

  Map toJson() {
    return {
      'file_name': file.path.split('/').last,
      'file_type': type.param,
      'content_type': lookupMimeType(file.path),
      'file_size': file.lengthSync(),
    };
  }
}

class UploadFileResponse {
  UploadFileResponse({
    required this.uploadUrl,
    required this.method,
    required this.headers,
    required this.fileId,
  });

  final String uploadUrl;
  final String method;
  final Map<String, dynamic> headers;
  final int fileId;

  factory UploadFileResponse.fromJson(Map<String, dynamic> json) {
    return UploadFileResponse(
        uploadUrl: json['upload_url'],
        method: json['method'],
        headers: json['headers'] == null ? {} : Map<String, dynamic>.from(json['headers']),
        fileId: json['file_id']);
  }
}
