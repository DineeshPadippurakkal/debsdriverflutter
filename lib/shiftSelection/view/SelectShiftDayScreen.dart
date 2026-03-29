import 'package:debs_driver_app/shiftSelection/controller/ShitSlectionController.dart';
import 'package:debs_driver_app/shiftSelection/model/GetAllShiftDayResponse.dart';
import 'package:debs_driver_app/shiftSelection/model/ShiftDay.dart';
import 'package:flutter/material.dart';

class SelectShiftDayScreen extends StatefulWidget {
  final int weekScheduleId;

  const SelectShiftDayScreen({
    Key? key,
    required this.weekScheduleId,
  }) : super(key: key);

  @override
  State<SelectShiftDayScreen> createState() => _SelectShiftDayScreenState();
}

class _SelectShiftDayScreenState extends State<SelectShiftDayScreen> {
  bool isLoading = true;

 List<Days> days = [];

  int? selectedShiftId;

  @override
  void initState() {
    super.initState();
    fetchShiftDays();
  }

  void fetchShiftDays() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await Shitslectioncontroller()
          .fetchSuggestShift(context, widget.weekScheduleId);

      if (!mounted) return;

      setState(() {
        days = response?.data?.days ?? [];
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void submitShift() async {
    if (selectedShiftId == null) return;

    final response = await Shitslectioncontroller()
        .submitShift(context, widget.weekScheduleId, selectedShiftId!);

 
    if (response!.status) {
     setState(() {
       fetchShiftDays();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Shift selected successfully")),
      );
    }
  }

  Widget shiftTimeItem(Shifts shift) {
    return RadioListTile<int>(
      value: shift.shift!,
      groupValue: selectedShiftId,
      onChanged: (value) {
        setState(() {
          selectedShiftId = value;
        });
      },
      title: Text(
        shift.time!.first,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  Widget shiftDayCard(Days day) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Day + Date + Arrow
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    day.day ?? "",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    day.date ?? "",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.arrow_forward_ios, size: 18)
            ],
          ),

          const SizedBox(height: 10),

          /// If shift already selected
          if (day.selectedShift != null && day.selectedShift!.isNotEmpty)
            Text(
              day.selectedShift!.first,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),

          /// Active day → show time slots
          if (day.isActive == true && day.shifts != null)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: day.shifts!.length,
              itemBuilder: (context, index) {
                final shift = day.shifts![index];

                return shiftTimeItem(shift);
              },
            ),

          const SizedBox(height: 10),

          /// Next button
          if (day.isActive == true)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submitShift,
                child: const Text("Next"),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Shift"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: days.length,
              itemBuilder: (context, index) {
                return shiftDayCard(days[index]);
              },
            ),
    );
  }
}
