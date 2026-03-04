import 'dart:convert';
import 'package:debs_driver_app/Utils/color.dart';
import 'package:debs_driver_app/shiftSelection/controller/ShitSlectionController.dart';
import 'package:debs_driver_app/shiftSelection/model/AvialableShiftResponse.dart'; 
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


class AvailableShiftScreen extends StatefulWidget {
  const AvailableShiftScreen({Key? key}) : super(key: key);

  @override
  State<AvailableShiftScreen> createState() => _AvailableShiftScreenState();
}
class _AvailableShiftScreenState extends State<AvailableShiftScreen> {

  bool isLoading = false;

  List<Data> shifts = [];   // 👈 IMPORTANT (use your inner model class)

  @override
  void initState() {
    super.initState();
    fetchShifts();
  }

  void fetchShifts() async {
    setState(() {
      isLoading = true;
    });

    final response =
        await Shitslectioncontroller().fetchShifts(context);

    if (response != null && response.status == true) {
      setState(() {
        shifts = response.data ?? [];   // 👈 STORE LIST HERE
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat("dd MMM yyyy").format(parsedDate);
  }

  Widget shiftCard(Data shift) {   // 👈 Use Data model
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              shift.year ?? "",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "${formatDate(shift.startDate!)} - ${formatDate(shift.endDate!)}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.location_on,
                    size: 18, color: Colors.blue),
                const SizedBox(width: 6),
                Text(
                  shift.zoneName ?? "",
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (shift.isOffDateSelected == false)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Available",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Off",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Available Shifts",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: ColorTheme().colorPrimary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : shifts.isEmpty
              ? const Center(child: Text("No Available Shifts"))
              : ListView.builder(
                  itemCount: shifts.length,
                  itemBuilder: (context, index) {
                    return shiftCard(shifts[index]);
                  },
                ),
    );
  }
}