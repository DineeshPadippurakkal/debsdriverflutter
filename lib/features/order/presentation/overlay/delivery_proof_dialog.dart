import 'dart:io';
import 'package:debs_driver_app/core/infrastructure/injection/injection_setup.dart';
import 'package:debs_driver_app/features/order/application/controllers/order_details_bloc/order_details_bloc.dart';
import 'package:debs_driver_app/features/order/domain/repos/orders_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeliveryProofPickerDialog extends StatefulWidget {
  const DeliveryProofPickerDialog({
    super.key,
    required this.onChanged,
    required this.onConfirm,
    this.image,
  });

  final Function(File image) onChanged;
  final VoidCallback onConfirm;
  final File? image;

  @override
  State<DeliveryProofPickerDialog> createState() => _DeliveryProofPickerDialogState();
}

class _DeliveryProofPickerDialogState extends State<DeliveryProofPickerDialog> {
  late File? image = widget.image;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32)),
      ),
      child: Container(
        padding: const EdgeInsets.all(8), // Subtle outer padding
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- TOP HANDLE BAR (Aesthetics only) ---
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Text(
                    "Upload Proof",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Visual confirmation ensures a safe delivery.",
                    style: TextStyle(color: Colors.grey[500], fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // --- THE IMAGE AREA ---
            GestureDetector(
              onTap: () async {
                final result = await getIt<OrdersRepo>().pickImageAndCompress();

                result.fold(
                  (failure) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to pick image: ${failure.toString()}")),
                  ),
                  (file) {
                    image = file;
                    setState(() {});
                    widget.onChanged(file);
                  },
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: const Color(0xFFF8F9FB),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: image == null ? _buildEmptyState() : _buildPreviewState(),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // --- ACTIONS ---
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: image == null ? null : widget.onConfirm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey[200],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: const Text("Complete Delivery",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle, // Simplified Circle
          ),
          child: const Icon(Icons.camera_alt_outlined, color: Colors.black, size: 30),
        ),
        const SizedBox(height: 16),
        const Text(
          "Open Camera",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildPreviewState() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.file(image!, fit: BoxFit.cover),
        Positioned(
          top: 12,
          right: 12,
          child: IconButton.filled(
            style: IconButton.styleFrom(backgroundColor: Colors.white),
            onPressed: () async {
              final result = await getIt<OrdersRepo>().pickImageAndCompress();

              result.fold(
                (failure) => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Failed to pick image: ${failure.toString()}")),
                ),
                (file) {
                  image = file;
                  setState(() {});

                  widget.onChanged(file);
                },
              );
            },
            icon: const Icon(Icons.edit_outlined, color: Colors.black, size: 18),
          ),
        ),
      ],
    );
  }
}
