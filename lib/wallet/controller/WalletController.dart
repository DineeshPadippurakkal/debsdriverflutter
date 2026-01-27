import 'dart:convert';

import 'dart:developer';
import 'package:debs_driver_app/Utils/Utils.dart';
import 'package:debs_driver_app/wallet/model/CODOrdersResponse.dart';
import 'package:debs_driver_app/wallet/model/WalletDepositResponse';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:debs_driver_app/wallet/model/WalletResponse.dart';

class Walletcontroller {
  String baseUrl = "https://staging.allowmena.com/api/v1";

  Future<WalletResponse?> fetchWallet(
      BuildContext context) async {
    final url =
        Uri.parse("$baseUrl/driver/wallet");
    String? token = await Utils().getToken();
    log(url.toString());
    try {
      final response = await http.get(url, headers: {
        'Authorization': '$token',
        'Content-Type': 'application/json',
      });

      log(response.body);
      if (response.statusCode == 200) {
        return WalletResponse.fromJson(jsonDecode(response.body));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("${response.statusCode}")));
        // throw "${response.body}";
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
      // throw "${response.body}";
    }
    return null;
  }

   Future<CODOrdersResponse?> fetchCOD_Orders(
      BuildContext context) async {
    final url =
        Uri.parse("$baseUrl/driver/cod-orders");
    String? token = await Utils().getToken();
    log(url.toString());
    try {
      final response = await http.get(url, headers: {
        'Authorization': '$token',
        'Content-Type': 'application/json',
      });

      log(response.body);
      if (response.statusCode == 200) {
        return CODOrdersResponse.fromJson(jsonDecode(response.body));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("${response.statusCode}")));
        // throw "${response.body}";
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
      // throw "${response.body}";
    }
    return null;
  }

    Future<WalletDepositResponse?> fetchDeposits(
      BuildContext context) async {
    final url =
        Uri.parse("$baseUrl/driver-wallet-deposits");
    String? token = await Utils().getToken();
    log(url.toString());
    try {
      final response = await http.get(url, headers: {
        'Authorization': '$token',
        'Content-Type': 'application/json',
      });

      log(response.body);
      if (response.statusCode == 200) {
        return WalletDepositResponse.fromJson(jsonDecode(response.body));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("${response.statusCode}")));
        // throw "${response.body}";
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
      // throw "${response.body}";
    }
    return null;
  }

  
}
