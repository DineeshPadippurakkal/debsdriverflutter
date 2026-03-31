import 'dart:io';

import 'package:flutter/material.dart';

class DropOrderDto {
  final int orderID;
  final File? deliveryImage;
  final File? signatureFile;
  final double? amountDue;

  DropOrderDto(
      {required this.orderID,
      required this.deliveryImage,
      required this.signatureFile,
      required this.amountDue});
}
