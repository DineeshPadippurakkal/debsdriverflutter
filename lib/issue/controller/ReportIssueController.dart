import 'dart:convert';
import 'dart:io';

import 'package:debs_driver_app/Utils/Utils.dart';
import 'package:debs_driver_app/issue/model/ReportIssueRespone.dart';
import 'package:debs_driver_app/issue/model/ReportIssueTypeRespone.dart';

import 'package:http/http.dart' as http;

class Reportissuecontroller {
  String baseUrl = "https://staging.allowmena.com/api/v1";

  Future<ReportIssueTypeRespone?> fetchissueTypes() async {
    final url = Uri.parse("$baseUrl/issue-types");
    String? token = await Utils().getToken();
    try {
      final response =
          await http.get(url, headers: {'Authorization': '$token'});
      // print(url);
      // print('this is the status code ${response.statusCode}');
      // print('this is the status code ${response.body}');
      if (response.statusCode == 200) {
        final jsondata =
            ReportIssueTypeRespone.fromJson(jsonDecode(response.body));

        print(response.body);
        return jsondata;
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ReportIssueRespone?> callReportIssue(
      String description,
      int issueType,
      double latitude,
      double longitude,
      File? selectedImage) async {
    final url = Uri.parse("$baseUrl/driver/issues");
    String? token = await Utils().getToken();

    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      'Authorization': '$token', 
    });
    request.fields['description'] = description;
    request.fields['issue_type'] = issueType.toString();
    request.fields['latitude'] = latitude.toString();
    request.fields['longitude'] = longitude.toString();
 
    if (selectedImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          selectedImage.path,
        ),
      );
    }

    try {
     final streamedResponse = await request.send();

    final responseBody =
        await streamedResponse.stream.bytesToString();
 
    if (streamedResponse.statusCode == 200 ||
        streamedResponse.statusCode == 201) {
      return ReportIssueRespone.fromJson(
        jsonDecode(responseBody),
      );
    } else {
      return null;
    }
       
    } catch (e) {
      rethrow;
    }
  }
}
