import 'dart:io';
import 'dart:typed_data';
import 'package:debs_driver_app/core/infrastructure/extenstion/uint8_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signature/signature.dart';

class SignatureProofPage extends StatefulWidget {
  const SignatureProofPage({super.key, required this.onConfirmed});
  final Function(File file) onConfirmed;
  @override
  State<SignatureProofPage> createState() => _SignatureProofPageState();
}

class _SignatureProofPageState extends State<SignatureProofPage> {
  late SignatureController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SignatureController(
      penStrokeWidth: 4,
      penColor: const Color(0xFF1A237E), // Elegant Navy
      exportBackgroundColor: Colors.white,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text(
          "Customer Signature",
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Header Instruction
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Icon(Icons.history_edu_rounded,
                    color: const Color(0xFF1A237E).withOpacity(0.5), size: 32),
                const SizedBox(height: 12),
                const Text(
                  "Confirm Delivery Receipt",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "Ask the customer to sign inside the white area.",
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                ),
              ],
            ),
          ),

          // --- THE CANVAS CARD ---
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.blueGrey.shade50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Stack(
                  children: [
                    Signature(
                      controller: _controller,
                      backgroundColor: Colors.white,
                      height: double.infinity,
                      width: double.infinity,
                    ),

                    // The "Sign Here" Guide
                    IgnorePointer(
                      child: Align(
                        alignment: const Alignment(0, 0.75),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(width: 220, height: 1, color: Colors.grey.shade200),
                            const SizedBox(height: 8),
                            Text(
                              "X  SIGNATURE LINE",
                              style: TextStyle(
                                color: Colors.grey.shade300,
                                fontWeight: FontWeight.w900,
                                fontSize: 10,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // --- ELEGANT ACTIONS ---
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
            child: Row(
              children: [
                // Secondary Action: Reset
                SizedBox(
                  height: 56,
                  child: TextButton.icon(
                    onPressed: () {
                      _controller.clear();
                      HapticFeedback.lightImpact();
                    },
                    icon: Icon(Icons.refresh_rounded, size: 20, color: Colors.blueGrey.shade300),
                    label: Text(
                      "RESET",
                      style: TextStyle(
                        color: Colors.blueGrey.shade600,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        fontSize: 12,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Primary Action: Confirm
                Expanded(
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2E7D32).withOpacity(0.25),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_controller.isEmpty) {
                          HapticFeedback.vibrate(); // Error feedback
                          return;
                        }

                        HapticFeedback.mediumImpact();
                        final Uint8List? bytes = await _controller.toPngBytes();

                        if (bytes != null && mounted) {
                          // Using the Extension created above
                          final File sigFile = await bytes.toFile(prefix: 'delivery_sig');
                          widget.onConfirmed (sigFile);
                          Navigator.pop(context, );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      ),
                      child: const Text(
                        "CONFIRM & FINISH",
                        style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
