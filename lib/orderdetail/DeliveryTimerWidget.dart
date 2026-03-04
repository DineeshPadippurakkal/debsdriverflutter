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
  late DateTime expectedTime;

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

  expectedTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(time);

  final now = DateTime.now();
  totalSeconds = expectedTime.difference(now).inSeconds;
  if (totalSeconds < 0) totalSeconds = 0;

  _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    final now = DateTime.now();
    final diffSeconds = expectedTime.difference(now).inSeconds;

    setState(() {
      remainingSeconds = diffSeconds;
      isExpired = diffSeconds < 0;
    });
  });
}


 String get formattedTime {
  final isNegative = remainingSeconds < 0;
  final absSeconds = remainingSeconds.abs();

  // ✅ Android-style: ignore hours & days
  final secondsInHour = absSeconds % 3600;
  final minutes = secondsInHour ~/ 60;
  final seconds = secondsInHour % 60;

  final time =
      "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";

  return isNegative ? "-$time" : time;
}

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = totalSeconds <= 0
        ? 0.0
        : remainingSeconds > 0
            ? remainingSeconds / totalSeconds
            : 0.0;

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
