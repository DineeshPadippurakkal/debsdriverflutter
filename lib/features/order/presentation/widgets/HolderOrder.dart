import 'dart:ui';
import 'package:debs_driver_app/Utils/color.dart';
import 'package:debs_driver_app/features/order/application/controllers/OrderDetailController.dart';
import 'package:debs_driver_app/features/order/domain/entities/hold_order_reason.dart';
import 'package:debs_driver_app/temp/HoldOrderRequest.dart';
import 'package:debs_driver_app/temp/HoldOrderResponse.dart';
import 'package:flutter/material.dart';

class Holderorder extends StatefulWidget {
  final int? orderID;
  const Holderorder({super.key, this.orderID});

  @override
  State<Holderorder> createState() => _HolderorderState();
}

class _HolderorderState extends State<Holderorder> {
  int? selectedReasonId;
  bool isLoading = false;
  HoldOrderReasonResponse holderOrderReasonResponse = HoldOrderReasonResponse();
  HoldOrderResponse holderOrderResponse = HoldOrderResponse();
  final TextEditingController otherController = TextEditingController();

  @override
  void initState() {
    super.initState();
    callHoldOrderReasons();
  }

  void callHoldOrderReasons() async {
    setState(() => isLoading = true);
    final response = await Orderdetailcontroller().callHoldOrderReasonApi(context);
    setState(() {
      if (response != null) holderOrderReasonResponse = response;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF2D63FF);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: ColorTheme().colorPrimary,
        title: const Text(
          "Hold Order",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryBlue))
          : _buildBody(primaryBlue),
    );
  }

  Widget _buildBody(Color primaryColor) {
    final reasons = holderOrderReasonResponse.data ?? [];

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Order ID Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.tag, color: primaryColor, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        "Order #${widget.orderID}",
                        style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  "Reason for Hold",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Please select a reason from the list below or provide details in 'Other'.",
                  style: TextStyle(color: Colors.blueGrey, fontSize: 14),
                ),
                const SizedBox(height: 24),

                // 2. Custom Selection Cards
                ...reasons.map((item) => _buildReasonCard(item, primaryColor)).toList(),

                const SizedBox(height: 12),

                // 3. Modern Text Area
                const Padding(
                  padding: EdgeInsets.only(left: 4, bottom: 8, top: 16),
                  child: Text("ADDITIONAL DETAILS",
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.blueGrey, letterSpacing: 1.1)),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 8))],
                  ),
                  child: TextField(
                    controller: otherController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "Type your reason here...",
                      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                      contentPadding: const EdgeInsets.all(16),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // 4. Submit Button (Matching Pick Up/Login Button)
        _buildSubmitButton(primaryColor),
      ],
    );
  }

  Widget _buildReasonCard(dynamic item, Color primaryColor) {
    bool isSelected = selectedReasonId == item.id;

    return GestureDetector(
      onTap: () => setState(() => selectedReasonId = item.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(color: primaryColor.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))
            else
              BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5, offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? primaryColor : Colors.grey[400],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                item.label ?? "",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? primaryColor : Color(0xFF1E293B),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(Color color) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 35),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(colors: [Color(0xFF2D63FF), Color(0xFF003CC5)]),
          boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 8))],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
          onPressed: _onSubmit,
          child: const Text(
            "SUBMIT HOLD",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1),
          ),
        ),
      ),
    );
  }

  // --- LOGIC REMAINS THE SAME ---
  void _onSubmit() {
    if (selectedReasonId == null && otherController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select or enter a reason"), behavior: SnackBarBehavior.floating),
      );
      return;
    }

    var reasons = holderOrderReasonResponse.data ?? [];
    String finalReason;
    if (selectedReasonId != null) {
      final selectedReason = reasons.firstWhere((r) => r.id == selectedReasonId, orElse: () => reasons.first);
      finalReason = selectedReason.label.toString();
    } else {
      finalReason = otherController.text.trim();
    }

    final request = HoldOrderRequest(reason: finalReason);
    callHoldOrderApi(widget.orderID!, request);
  }

  void callHoldOrderApi(int orderID, HoldOrderRequest request) async {
    setState(() => isLoading = true);
    final response = await Orderdetailcontroller().callHoldOrderApi(context, orderID, request);

    if (response != null) {
      otherController.clear();
      setState(() {
        holderOrderResponse = response;
        isLoading = false;
        _showSuccessDialog(holderOrderResponse.message.toString());
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 70),
            const SizedBox(height: 20),
            const Text("Success!", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22)),
            const SizedBox(height: 10),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.blueGrey)),
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
                Navigator.pop(context, true); // go back
              },
              child: const Text("CLOSE", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2D63FF))),
            ),
          ),
        ],
      ),
    );
  }
}