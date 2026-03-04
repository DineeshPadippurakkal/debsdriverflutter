import 'dart:convert';
import 'package:debs_driver_app/shiftSelection/controller/ShitSlectionController.dart'; 
import 'package:debs_driver_app/shiftSelection/model/OffDateModelResponse.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


class OffDateScreen extends StatefulWidget {
  final int weekScheduleId;

  const OffDateScreen({Key? key, required this.weekScheduleId})
      : super(key: key);

  @override
  State<OffDateScreen> createState() => _OffDateScreenState();
}
class _OffDateScreenState extends State<OffDateScreen> {
  bool isLoading = true;
  bool isSubmitting = false;

  List<OffDateData> offDates = [];
  int? selectedId;

  @override
  void initState() {
    super.initState();
    fetchOffDates();
  }

  void fetchOffDates() async {
    setState(() => isLoading = true);

    final response = await Shitslectioncontroller()
        .fetchOffDates(context, widget.weekScheduleId);

    if (response != null && response.status == true) {
      offDates = response.data ?? [];
    }

    setState(() => isLoading = false);
  }

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat("dd/MM/yyyy").format(parsedDate);
  }

  void submitOffDate() async {
    if (selectedId == null) return;

    setState(() => isSubmitting = true);

    // final success = await Shitslectioncontroller()
    //     .submitOffDate(context, selectedId!);

    setState(() => isSubmitting = false);

    // if (success == true) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text("Off Date Selected Successfully")),
    //   );

    //   Navigator.pop(context, true); // return success
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Off Date"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : offDates.isEmpty
              ? const Center(child: Text("No Off Dates"))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: offDates.length,
                        itemBuilder: (context, index) {
                          return offDateCard(offDates[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize:
                              const Size(double.infinity, 50),
                        ),
                        onPressed: selectedId == null || isSubmitting
                            ? null
                            : submitOffDate,
                        child: isSubmitting
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text("Confirm Off Date"),
                      ),
                    )
                  ],
                ),
    );
  }

  Widget offDateCard(OffDateData offDate) {
    return Card(
      margin:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: RadioListTile<int>(
        value: offDate.id ?? 0,
        groupValue: selectedId,
        onChanged: (value) {
          setState(() {
            selectedId = value;
          });
        },
        title: Text(
          offDate.day ?? "",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          formatDate(offDate.date ?? ""),
          style: const TextStyle(fontSize: 16),
        ),
        activeColor: Colors.red,
      ),
    );
  }
}