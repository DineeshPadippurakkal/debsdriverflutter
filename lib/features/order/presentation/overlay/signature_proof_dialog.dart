import 'dart:io';

import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class SignatureProofDialog extends StatefulWidget {
  const SignatureProofDialog({Key? key, required this.onTap, required this.image}) : super(key: key);
  final VoidCallback onTap;
  final File? image;

  @override
  State<SignatureProofDialog> createState() => _SignatureProofDialogState();
}

class _SignatureProofDialogState extends State<SignatureProofDialog> {
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
  );  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // 🔑 IMPORTANT
        children: [
          const SizedBox(height: 8),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Signature(
              height: 190,
              controller: _signatureController,
              backgroundColor: Colors.transparent,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _signatureController.clear,
              child: const Text("Clear"),
            ),
          ),
        ],
      )
    );
  }
}
