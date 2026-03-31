import 'dart:io';

import 'package:flutter/material.dart';

class DeliveryProofDialog extends StatelessWidget {
  const DeliveryProofDialog({Key? key, required this.onTap, required this.image}) : super(key: key);
  final VoidCallback onTap;
  final File? image;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min, // 🔑 IMPORTANT
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: 320,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: image == null
                  ? const Center(
                      child: Icon(Icons.camera_alt, size: 40),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(image!.path),
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
