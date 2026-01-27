import 'package:debs_driver_app/wallet/DepositItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
Widget depositListItem(DepositItem item) {
  return Container(
    width: double.infinity,
    color: Colors.white,
    padding: const EdgeInsets.all(25),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.day,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  item.date,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            Text(
              "+ ${item.amount.toStringAsFixed(2)}",
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          height: 1,
          margin: const EdgeInsets.only(left: 25),
          color: Colors.black12,
        ),
      ],
    ),
  );
}
