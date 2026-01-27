import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DeliveryTimerWidget extends StatefulWidget {
  final String deliveryTime; // "yyyy-MM-dd HH:mm:ss"

  const DeliveryTimerWidget({
    super.key,
    required this.deliveryTime,
  });

  @override
  State<DeliveryTimerWidget> createState() => _DeliveryTimerWidgetState();
}

class _DeliveryTimerWidgetState extends State<DeliveryTimerWidget> {
  Timer? _timer;

  int totalSeconds = 0;
  int remainingSeconds = 0;
  bool isExpired = false;

  @override
  void initState() {
    super.initState();
    _startDeliveryTimer(widget.deliveryTime);
  }

   void _startDeliveryTimer(String time) {
  _timer?.cancel();

  final now = DateTime.now();
  final expected = DateFormat("yyyy-MM-dd HH:mm:ss").parse(time);

  final diffSeconds = expected.difference(now).inSeconds;

  if (diffSeconds <= 0) {
    setState(() {
      isExpired = true;
      remainingSeconds = 0;
    });
    return;
  }

  // 🔥 EXACT ANDROID LOGIC
  final days = diffSeconds ~/ (24 * 3600);
  final remainingAfterDays = diffSeconds - (days * 24 * 3600);

  final hours = remainingAfterDays ~/ 3600;
  final minutes = (remainingAfterDays - (hours * 3600)) ~/ 60;
  final seconds = remainingAfterDays % 60;

  // ✅ Android-style total seconds (NO DAYS)
  totalSeconds = (hours * 3600) + (minutes * 60) + seconds;
  remainingSeconds = totalSeconds;

  _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    if (remainingSeconds <= 0) {
      timer.cancel();
      setState(() => isExpired = true);
    } else {
      setState(() => remainingSeconds--);
    }
  });
}


  String get formattedTime {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress =
        totalSeconds == 0 ? 0.0 : remainingSeconds / totalSeconds;

    return Column(
      children: [
        const Text(
          "Expected Delivery",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 10),

        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 80,
              width: 80,
              child: CircularProgressIndicator(
                value: isExpired ? 1 : progress,
                strokeWidth: 6,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isExpired ? Colors.red : Colors.blue,
                ),
              ),
            ),

            Column(
              children: [
                Text(
                  formattedTime,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isExpired ? Colors.red : Colors.black,
                  ),
                ),
                const Text(
                  "Min",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
