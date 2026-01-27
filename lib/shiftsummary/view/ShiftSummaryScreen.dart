import 'package:debs_driver_app/Utils/color.dart';
import 'package:debs_driver_app/shiftsummary/controller/ShiftSummaryController.dart';
import 'package:debs_driver_app/shiftsummary/model/ShiftSummaryResponse.dart';
import 'package:flutter/material.dart';

class ShiftSummaryScreen extends StatefulWidget {
  const ShiftSummaryScreen({super.key});

  @override
  State<ShiftSummaryScreen> createState() => _ShiftSummaryScreenState();
}

class _ShiftSummaryScreenState extends State<ShiftSummaryScreen> {
  String selectedDate = "20 Mar 2022 - 15 Apr 2022";

  bool isloading = false;
  ShiftSummaryResponse shiftSummaryResponse = ShiftSummaryResponse();

  @override
  void initState() {
    super.initState();
    fetchShiftSummary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Shift Summary",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: ColorTheme().colorPrimary,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            if (isloading)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 20),
                    CircularProgressIndicator(),
                  ],
                ),
              )
            else ...[
              _dateHeader(),
              _riderSummary(),
              Expanded(child: _summaryList()),
            ],
          ],
        ),
      ),
    );
  }

  // ================= DATE HEADER =================
  Widget _dateHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.flag, size: 18, color: Colors.blue),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Selected Dates",
                  style: TextStyle(
                    fontSize: 14,
                    color: ColorTheme().colorPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  selectedDate,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ColorTheme().colorPrimary),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorTheme().colorPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onPressed: () {
              // open calendar
            },
            icon: const Icon(
              Icons.edit,
              size: 16,
              color: Colors.white,
            ),
            label: const Text(
              "Edit",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  // ================= RIDER SUMMARY =================
  Widget _riderSummary() {
    return Container(
      width: double.infinity,
      color: ColorTheme().colorPrimary,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.note, color: Colors.white),
              SizedBox(width: 8),
              Text(
                "Rider Summary",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _timeBlock(
                  "ACTUAL",
                  shiftSummaryResponse.data!.summary!.actualWorkingHours
                      .toString()),
              _timeBlock(
                  "PLANNED",
                  shiftSummaryResponse.data!.summary!.plannedWorkingHours
                      .toString()),
              _timeBlock("BREAK",
                  shiftSummaryResponse.data!.summary!.breakHours.toString()),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statBox("SHIFTS",
                  shiftSummaryResponse.data!.summary!.shifts.toString()),
              _statBox("ORDERS",
                  shiftSummaryResponse.data!.summary!.orders.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _timeBlock(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _statBox(String label, String value) {
    return Container(
      width: 80,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white70),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryList() {
    List<Rows>? summaryList = shiftSummaryResponse.data!.rows;
    if (summaryList!.isEmpty) {
      return const Center(
        child: Text("No data available"),
      );
    }
    return ListView.builder(
      itemCount: summaryList.length,
      itemBuilder: (context, index) {
        final item = summaryList[index];
        return _summaryCard(item);
      },
    );
  }

  Widget _summaryCard(Rows item) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.all(16),
      child: Card(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column( crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== DATE =====
                  Text(
                    item.date.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ColorTheme().colorPrimary,
                    ),
                  ),
 
                ],
              ),
            ),
 

            // ===== SUMMARY SECTION =====
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: ColorTheme().lightgrey,
                borderRadius: BorderRadius.circular(0),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // ===== ACTUAL =====
                      _infoColumn("ACTUAL", item.actualWorkingHours.toString()),

                      // ===== PLANNED =====
                      _infoColumn(
                          "PLANNED", item.plannedWorkingHours.toString()),

                      // ===== BREAK =====
                      _infoColumn("BREAK", item.breakHours.toString()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // ===== SHIFTS & ORDERS =====
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _miniBox("SHIFTS", item.shifts.toString()),
                        _miniBox("ORDERS", item.orders.toString()),
                      ],
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

  Widget _infoColumn(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
      ],
    );
  }

  Widget _miniBox(String title, String value) {
    return Container(
      width: 80,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: ColorTheme().bluedark),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Text(
            title,
            style:   TextStyle(
              fontSize: 12,
              color: ColorTheme().bluedark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style:   TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorTheme().bluedark,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fetchShiftSummary() async {
    try {
      setState(() {
        isloading = true;
      });
      final data = await Shiftsummarycontroller()
          .fetchShiftSummary(context, "2026-01-01", "2026-01-25");
      if (data != null) {
        setState(() {
          shiftSummaryResponse = data;
          isloading = false;
        });
      } else {
        setState(() {
          isloading = false;
        });
      }
    } catch (e) {
      setState(() {
        isloading = false;
      });
      rethrow;
    }
  }
}
