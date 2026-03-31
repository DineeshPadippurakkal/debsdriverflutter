import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PickupTimer extends StatefulWidget {
  final String expectedPickupTime; // "2026-01-14 19:43:01"

  const PickupTimer({super.key, required this.expectedPickupTime});

  @override
  State<PickupTimer> createState() => _PickupTimerState();
}

class _PickupTimerState extends State<PickupTimer> {
  Timer? _timer;
  int totalSeconds = 0;
  int remainingSeconds = 0;
  bool isExpired = false;

  @override
  void initState() {
    super.initState();
    _startPickupTimer(widget.expectedPickupTime);
  }
 void _startPickupTimer(String time) {
  _timer?.cancel();

  final now = DateTime.now();
  final expected = DateFormat("yyyy-MM-dd HH:mm:ss").parse(time);

  final diffMillis =
      expected.millisecondsSinceEpoch - now.millisecondsSinceEpoch;

  if (diffMillis <= 0) {
    setState(() {
      isExpired = true;
      remainingSeconds = 0;
    });
    return;
  }
 
  final days = diffMillis ~/ (1000 * 60 * 60 * 24);

  final hours = ((diffMillis -
          (days * 1000 * 60 * 60 * 24)) ~/
      (1000 * 60 * 60))
      .abs();

  final minutes = ((diffMillis -
          (days * 1000 * 60 * 60 * 24) -
          (hours * 1000 * 60 * 60)) ~/
      (1000 * 60));

  final seconds = ((diffMillis -
          (days * 1000 * 60 * 60 * 24) -
          (hours * 1000 * 60 * 60) -
          (minutes * 1000 * 60)) ~/
      1000);

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
    final minutes = (remainingSeconds ~/ 60);
    final seconds = (remainingSeconds % 60);
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = totalSeconds == 0 ? 0.0 : remainingSeconds / totalSeconds;

    return Column(
      children: [
        const Text(
          "Expected Pickup",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
        const SizedBox(height: 10),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 80,
              width: 80,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 8,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation(
                  isExpired ? Colors.red : Colors.blue,
                ),
              ),
            ),
            Column(
              children: [
                Text(
                  formattedTime,
                  style: TextStyle(
                    fontSize: 14,
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
