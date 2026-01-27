import 'package:debs_driver_app/Utils/color.dart';
import 'package:debs_driver_app/orderdetail/controller/OrderDetailController.dart';
import 'package:debs_driver_app/orderdetail/model/HoldOrderReasonResponse.dart';
import 'package:debs_driver_app/orderdetail/model/HoldOrderRequest.dart';
import 'package:debs_driver_app/orderdetail/model/HoldOrderResponse.dart';
import 'package:flutter/material.dart';

class Holderorder extends StatefulWidget {
  int? orderID;
  Holderorder({super.key, this.orderID});

  @override
  State<Holderorder> createState() => _HolderorderState();
}

class _HolderorderState extends State<Holderorder> {
  int? selectedReasonId;
  bool isLoading = false;
  HoldOrderReasonResponse holderOrderReasonResponse = HoldOrderReasonResponse();
 HoldOrderResponse holderOrderResponse = HoldOrderResponse();
  final TextEditingController otherController = TextEditingController();

  void callHoldOrderReasons() async {
    setState(() {
      isLoading = true;
    });
    final response =
        await Orderdetailcontroller().callHoldOrderReasonApi(context);

    if (response != null) {
      setState(() {
        holderOrderReasonResponse = response;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callHoldOrderReasons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          foregroundColor: Colors.white,
          backgroundColor: ColorTheme().colorPrimary,
          title: Text(
            "Hold Order",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildBody());
  }

  Widget _buildBody() {
    final reasons = holderOrderReasonResponse.data ?? [];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Order Number
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: Text(
                "Order Number: ${widget.orderID}",
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            /// Subtitle
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Please select why you want to hold this order",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),

            const SizedBox(height: 10),

            /// Radio List (RecyclerView equivalent)
            SizedBox(
              height: 300,
              child: reasons.isEmpty
                  ? const Center(child: Text("No reasons available"))
                  : ListView.builder(
                      itemCount: reasons.length,
                      itemBuilder: (context, index) {
                        final item = reasons[index];
                        return RadioListTile<int>(
                          value: item.id ?? 0,
                          groupValue: selectedReasonId,
                          title: Text(
                            item.label ?? "",
                            style: const TextStyle(fontSize: 18),
                          ),
                          onChanged: (value) {
                            setState(() {
                              selectedReasonId = value;
                            });
                          },
                        );
                      },
                    ),
            ),

            /// Other Reason Input
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: otherController,
                textAlignVertical: TextAlignVertical.top,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: "Other",
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            /// Submit Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorTheme().colorPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    elevation: 10,
                  ),
                  onPressed: _onSubmit,
                  child: const Text(
                    "Submit",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSubmit() {
    if (selectedReasonId == null && otherController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select or enter a reason")),
      );
      return;
    }
    var reasons = holderOrderReasonResponse.data ?? [];
    
  String finalReason;
    if (selectedReasonId != null) {
    final selectedReason = reasons.firstWhere(
      (r) => r.id == selectedReasonId,
      orElse: () => reasons.first,
    );
    finalReason = selectedReason.label.toString();
  }
  // ✅ If user typed custom reason
  else {
    finalReason = otherController.text.trim();
  }
    debugPrint("Selected reason id: $selectedReasonId");
    debugPrint("Selected Reason: $finalReason");
    debugPrint("Other text: ${otherController.text}");

    // TODO: call HOLD ORDER submit API
  final request = HoldOrderRequest(
    reason: finalReason,
  );
    callHoldOrderApi(widget.orderID!,request);
  }

  void callHoldOrderApi(int orderID,HoldOrderRequest request) async {
    setState(() {
      isLoading = true;
    });
    final response =
        await Orderdetailcontroller().callHoldOrderApi(context,orderID,request);

    if (response != null) {
      otherController.clear();
      setState(() {
        holderOrderResponse = response;
        _showSuccessDialog(holderOrderResponse.message.toString());
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showSuccessDialog(String message) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // close dialog
            Navigator.pop(context); // go back (optional)
             Navigator.pop(context,true); 
          },
          child: const Text("OK"),
        ),
      ],
    ),
  );
}
}
